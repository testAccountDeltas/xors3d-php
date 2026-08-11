<?php

declare(strict_types=1);

namespace Xors3D\Core;

use RuntimeException;

/**
 * Resolves SDK / DLL / media paths and the license key from the project layout.
 */
final class Config
{
    public readonly string $sdkDir;
    public readonly string $dllDir;
    public readonly string $mediaDir;
    public readonly string $keysFile;

    /** @param string $root The xors3d root folder (contains the SDK + phpx86). */
    public function __construct(string $root)
    {
        $this->sdkDir   = $root . '\\Xors3dIndie(withSamples)_750';
        $this->dllDir   = $this->sdkDir . '\\dlls';
        $this->mediaDir = $this->sdkDir . '\\Samples\\Media';
        $this->keysFile = $this->sdkDir . '\\keys.txt';
    }

    /** Absolute path to a media asset, e.g. media('Textures/logo.jpg'). */
    public function media(string $relative): string
    {
        return $this->mediaDir . '\\' . str_replace('/', '\\', $relative);
    }

    /** First non-empty license key from keys.txt. */
    public function firstKey(): string
    {
        if (!is_file($this->keysFile)) {
            throw new RuntimeException("keys.txt not found: {$this->keysFile}");
        }
        foreach (file($this->keysFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
            $line = trim($line);
            if ($line !== '') {
                return $line;
            }
        }
        throw new RuntimeException('No license key found in keys.txt');
    }
}
