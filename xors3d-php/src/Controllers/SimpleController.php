<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\Camera;
use Xors3D\Scene\Cube;
use Xors3D\Scene\Texture;

/**
 * Port of the C++ "simple" sample, now as a routed controller using the
 * Scene OOP wrappers on top of the generated Engine.
 *
 * Route:  php app.php simple [maxFrames]
 */
final class SimpleController extends Controller
{
    public const TITLE = 'Spinning textured cube + camera';

    public function index(int|string $maxFrames = 0): int
    {
        $e         = $this->engine;
        $maxFrames = (int) $maxFrames;

        // license + window
        $e->xKey($this->config->firstKey());
        $e->xSetAntiAliasType($e->xGetMaxAntiAlias());
        $e->xAppTitle('Simple sample (PHP OOP/FFI)');
        $e->xGraphics3D(800, 600, 32, 0, 1);
        $e->xHidePointer();
        $e->xAntiAlias(1);

        // scene
        $camera = Camera::create($e)->position(0, 0, -10);
        $cube   = Cube::create($e);
        $cube->setTexture(Texture::load($e, $this->config->media('Textures/logo.jpg')));

        // mouse-look state
        $mouseSpeed = 0.5;
        $smoothness = 4.5;
        $mxs = 0.0; $mys = 0.0;
        $camXA = 0.0; $camYA = 0.0;
        $frame = 0;

        $center = fn () => $e->xMoveMouse(
            (int) ($e->xGraphicsWidth() / 2),
            (int) ($e->xGraphicsHeight() / 2)
        );
        $center();

        while ($this->running()) {
            // WASD movement
            if ($e->xKeyDown(Constants::KEY_W)) { $camera->move(0, 0,  1); }
            if ($e->xKeyDown(Constants::KEY_S)) { $camera->move(0, 0, -1); }
            if ($e->xKeyDown(Constants::KEY_A)) { $camera->move(-1, 0, 0); }
            if ($e->xKeyDown(Constants::KEY_D)) { $camera->move( 1, 0, 0); }

            // mouse look
            $mxs = $this->curve($e->xMouseXSpeed() * $mouseSpeed, $mxs, $smoothness);
            $mys = $this->curve($e->xMouseYSpeed() * $mouseSpeed, $mys, $smoothness);
            $camXA = fmod($camXA - $mxs, 360.0);
            $camYA = max(-89.0, min(89.0, $camYA + $mys));
            $center();
            $camera->rotate($camYA, $camXA, 0.0);

            // spin the cube + present
            $cube->turn(0, 1, 0);
            $e->xRenderWorld();
            $e->xFlip();

            if ($maxFrames > 0 && ++$frame >= $maxFrames) {
                break;
            }
        }

        $e->xReleaseGraphics();
        return 0;
    }

    /** Mouse-look smoothing, from the original sample. */
    private function curve(float $new, float $old, float $inc): float
    {
        if ($inc >  1.0) { return $old - ($old - $new) / $inc; }
        return $new;
    }
}
