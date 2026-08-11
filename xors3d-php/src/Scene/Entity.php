<?php

declare(strict_types=1);

namespace Xors3D\Scene;

use Xors3D\Ffi\Engine;

/**
 * Object-oriented wrapper around an engine entity handle.
 * Movement methods are fluent so scene code reads naturally.
 */
class Entity
{
    public function __construct(
        protected readonly Engine $engine,
        public readonly int $handle,
    ) {
    }

    public function position(float $x, float $y, float $z): static
    {
        $this->engine->xPositionEntity($this->handle, $x, $y, $z);
        return $this;
    }

    public function move(float $x, float $y, float $z): static
    {
        $this->engine->xMoveEntity($this->handle, $x, $y, $z);
        return $this;
    }

    public function rotate(float $x, float $y, float $z): static
    {
        $this->engine->xRotateEntity($this->handle, $x, $y, $z);
        return $this;
    }

    public function turn(float $x, float $y, float $z): static
    {
        $this->engine->xTurnEntity($this->handle, $x, $y, $z);
        return $this;
    }

    public function setTexture(Texture $texture): static
    {
        $this->engine->xEntityTexture($this->handle, $texture->handle);
        return $this;
    }

    public function free(): void
    {
        $this->engine->xFreeEntity($this->handle);
    }
}
