<?php

declare(strict_types=1);

namespace Xors3D\Scene;

use Xors3D\Ffi\Constants;
use Xors3D\Ffi\Engine;

/**
 * The WASD + mouse-look camera controller shared by most C++ samples.
 * Call {@see update()} once per frame before rendering.
 */
final class MouseLookCamera
{
    public readonly Camera $camera;

    private float $mxs = 0.0;
    private float $mys = 0.0;
    private float $yaw = 0.0;
    private float $pitch = 0.0;
    private float $invert = 1.0; // 1 = normal, -1 = inverted Y

    public function __construct(
        private readonly Engine $engine,
        ?Camera $camera = null,
        private float $mouseSpeed = 0.5,
        private readonly float $smoothness = 4.5,
    ) {
        $this->camera = $camera ?? Camera::create($engine);
        $this->center();
    }

    /** Live mouse-sensitivity control. */
    public function setSensitivity(float $s): void
    {
        $this->mouseSpeed = $s;
    }

    /** Live invert-Y toggle. */
    public function setInvertY(bool $on): void
    {
        $this->invert = $on ? -1.0 : 1.0;
    }

    /** Reset accumulated look angles (e.g. when (re)entering the game). */
    public function reset(): void
    {
        $this->mxs = $this->mys = $this->yaw = $this->pitch = 0.0;
        $this->center();
    }

    /** Recenter the OS mouse cursor in the window. */
    public function center(): void
    {
        $this->engine->xMoveMouse(
            (int) ($this->engine->xGraphicsWidth() / 2),
            (int) ($this->engine->xGraphicsHeight() / 2)
        );
    }

    /** Apply one frame of movement + look. */
    public function update(): void
    {
        $e = $this->engine;

        if ($e->xKeyDown(Constants::KEY_W)) { $this->camera->move(0, 0,  1); }
        if ($e->xKeyDown(Constants::KEY_S)) { $this->camera->move(0, 0, -1); }
        if ($e->xKeyDown(Constants::KEY_A)) { $this->camera->move(-1, 0, 0); }
        if ($e->xKeyDown(Constants::KEY_D)) { $this->camera->move( 1, 0, 0); }

        $this->mxs = $this->curve($e->xMouseXSpeed() * $this->mouseSpeed, $this->mxs);
        $this->mys = $this->curve($e->xMouseYSpeed() * $this->mouseSpeed, $this->mys);
        $this->yaw   = fmod($this->yaw - $this->mxs, 360.0);
        $this->pitch = max(-89.0, min(89.0, $this->pitch + $this->mys * $this->invert));

        $this->center();
        $this->camera->rotate($this->pitch, $this->yaw, 0.0);
    }

    /** Mouse-look only (no WASD): used when the controller drives movement itself. */
    public function lookOnly(): void
    {
        $e = $this->engine;
        $this->mxs = $this->curve($e->xMouseXSpeed() * $this->mouseSpeed, $this->mxs);
        $this->mys = $this->curve($e->xMouseYSpeed() * $this->mouseSpeed, $this->mys);
        $this->yaw   = fmod($this->yaw - $this->mxs, 360.0);
        $this->pitch = max(-89.0, min(89.0, $this->pitch + $this->mys * $this->invert));
        $this->center();
        $this->camera->rotate($this->pitch, $this->yaw, 0.0);
    }

    /** The camera entity handle (for effect constants, etc.). */
    public function handle(): int
    {
        return $this->camera->handle;
    }

    private function curve(float $new, float $old): float
    {
        return $this->smoothness > 1.0
            ? $old - ($old - $new) / $this->smoothness
            : $new;
    }
}
