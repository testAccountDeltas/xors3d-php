<?php

declare(strict_types=1);

namespace Xors3D\Scene;

use Xors3D\Ffi\Engine;

/**
 * A built-in cube primitive.
 */
final class Cube extends Entity
{
    public static function create(Engine $engine, int $parent = 0): self
    {
        return new self($engine, $engine->xCreateCube($parent));
    }
}
