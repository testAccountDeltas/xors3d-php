<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "meshesintersect" sample - cone turns green when the movable
 * cube intersects it.
 */
final class MeshesintersectController extends Controller
{
    public const TITLE = 'Mesh intersection test';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Mesh intersect sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $camera = $e->xCreateCamera();
        $e->xPositionEntity($camera, 0, 2, -20);

        $light = $e->xCreateLight(Constants::LIGHT_DIRECTIONAL);
        $e->xRotateEntity($light, -20, 0, 0);

        $cone = $e->xCreateCone();
        $cube = $e->xCreateCube();
        $e->xPositionEntity($cube, -3, 0, 0);

        while ($this->running()) {
            if ($e->xMeshesIntersect($cube, $cone)) {
                $e->xEntityColor($cone, 0, 200, 0);
            } else {
                $e->xEntityColor($cone, 255, 255, 255);
            }

            if ($e->xKeyDown(Constants::KEY_W)) { $e->xMoveEntity($cube,  0.0,  0.1, 0.0); }
            if ($e->xKeyDown(Constants::KEY_S)) { $e->xMoveEntity($cube,  0.0, -0.1, 0.0); }
            if ($e->xKeyDown(Constants::KEY_A)) { $e->xMoveEntity($cube, -0.1,  0.0, 0.0); }
            if ($e->xKeyDown(Constants::KEY_D)) { $e->xMoveEntity($cube,  0.1,  0.0, 0.0); }

            $e->xRenderWorld();
            $e->xText(10, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 50, 'W/A/S/D - Move Cube');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
