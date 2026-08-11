<?php

declare(strict_types=1);

namespace Xors3D\Ffi;

use FFI;
use RuntimeException;

/**
 * Low-level FFI plumbing shared by the generated {@see Engine}.
 *
 * Xors3d.dll exports flat C functions with the __stdcall convention, which on
 * 32-bit Windows are name-decorated as `_name@<bytes>`. PHP's built-in FFI
 * auto-decoration crashes on zero-argument stdcall functions, so we resolve
 * every symbol ourselves via kernel32's GetProcAddress (using the exact
 * decorated name from Engine::FUNCS) and FFI::cast() the address to the typed
 * function pointer declared in Engine::TYPEDEFS.
 *
 * Subclasses must define the constants TYPEDEFS (string) and FUNCS (array).
 */
abstract class NativeLibrary
{
    /** C typedefs for all function pointers (defined by the generated subclass). */
    protected const TYPEDEFS = '';

    /** name => ['sym' => decorated symbol, 'str' => returns C string] */
    protected const FUNCS = [];

    private FFI $k32;
    private FFI $types;
    private object $module;

    /** @var array<string,object> cache of bound (cast) callables */
    private array $bound = [];

    public function __construct(string $dllDir, string $dllName)
    {
        if (PHP_INT_SIZE !== 4) {
            throw new RuntimeException(
                'A 32-bit PHP build is required (Xors3d.dll is x86); current PHP is '
                . (PHP_INT_SIZE * 8) . '-bit.'
            );
        }
        if (!\extension_loaded('ffi')) {
            throw new RuntimeException('The FFI extension is not enabled.');
        }

        $dllPath = $dllDir . '\\' . $dllName;
        if (!\is_file($dllPath)) {
            throw new RuntimeException("Native library not found: $dllPath");
        }

        // kernel32: exported undecorated, so plain declarations resolve fine.
        $this->k32 = FFI::cdef(
            'void* LoadLibraryA(const char*);'
            . 'void* GetProcAddress(void*, const char*);'
            . 'int   SetDllDirectoryA(const char*);',
            'kernel32.dll'
        );

        // let dependent DLLs (Squall.dll, xPhysics.dll, ...) resolve next to it
        $this->k32->SetDllDirectoryA($dllDir);

        $module = $this->k32->LoadLibraryA($dllPath);
        if ($module === null || FFI::isNull($module)) {
            throw new RuntimeException("Failed to load native library: $dllPath");
        }
        $this->module = $module;

        // one scope declaring every function-pointer type
        $this->types = FFI::cdef(static::TYPEDEFS);
    }

    /**
     * Call a native function by name with an ordered argument list.
     * Generated Engine methods are fully typed, so arguments always arrive
     * complete - no default padding is needed here.
     */
    protected function invoke(string $name, array $args): mixed
    {
        $fn  = $this->bound[$name] ??= $this->resolve($name);
        $ret = $fn(...$args);

        if (static::FUNCS[$name]['str']) {
            if ($ret === null) {
                return '';
            }
            if (\is_string($ret)) {
                return $ret;
            }
            return FFI::isNull($ret) ? '' : FFI::string($ret);
        }
        return $ret;
    }

    /** Resolve a decorated export and cast it to its typed function pointer. */
    private function resolve(string $name): object
    {
        $sym  = static::FUNCS[$name]['sym'];
        $addr = $this->k32->GetProcAddress($this->module, $sym);
        if ($addr === null || FFI::isNull($addr)) {
            throw new RuntimeException("Export not found: $sym (for $name)");
        }
        return $this->types->cast('fp_' . $name, $addr);
    }
}
