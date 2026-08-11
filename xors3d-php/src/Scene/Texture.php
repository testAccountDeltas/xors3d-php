<?php

declare(strict_types=1);

namespace Xors3D\Scene;

use Xors3D\Ffi\Engine;

/**
 * A loaded texture.
 */
final class Texture
{
    public function __construct(
        private readonly Engine $engine,
        public readonly int $handle,
    ) {
    }

    public static function load(Engine $engine, string $path, int $flags = 9): self
    {
        return new self($engine, $engine->xLoadTexture($path, $flags));
    }

    public function free(): void
    {
        $this->engine->xFreeTexture($this->handle);
    }
}
