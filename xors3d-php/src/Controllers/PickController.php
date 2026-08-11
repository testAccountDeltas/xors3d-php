<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "pick" sample - CameraPick against a pickable cube.
 */
final class PickController extends Controller
{
    public const TITLE = 'Camera picking (ray/polygon)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Pick sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 2, -10);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, 45, 45, 45);

        $cube = $e->xCreateCube();
        $e->xEntityPickMode($cube, 2); // polygon-accurate picking
        $e->xPositionEntity($cube, 0, 0, 0);
        $e->xRotateEntity($cube, 0, 45, 0);

        while ($this->running()) {
            $cam->update();

            if ($e->xMouseHit(1)) {
                $e->xCameraPick($cam->handle(), $e->xMouseX(), $e->xMouseY());
            }

            $e->xRenderWorld();

            $e->xText(0, 20, 'Use WASD to move');
            $e->xText(0, 40, 'Press left mouse button to CameraPick at the cursor');
            $e->xText(0, 60,  sprintf('PickedX: %f', $e->xPickedX()));
            $e->xText(0, 80,  sprintf('PickedY: %f', $e->xPickedY()));
            $e->xText(0, 100, sprintf('PickedZ: %f', $e->xPickedZ()));
            $e->xText(0, 120, sprintf('PickedNX: %f', $e->xPickedNX()));
            $e->xText(0, 140, sprintf('PickedNY: %f', $e->xPickedNY()));
            $e->xText(0, 160, sprintf('PickedNZ: %f', $e->xPickedNZ()));
            $e->xText(0, 180, sprintf('PickedTime: %d', $e->xPickedTime()));
            $e->xText(0, 200, sprintf('PickedEntity: 0x%08X', $e->xPickedEntity()));
            $e->xText(0, 220, sprintf('PickedSurface: %d', $e->xPickedSurface()));
            $e->xText(0, 240, sprintf('PickedTriangle: %d', $e->xPickedTriangle()));
            $e->xText(0, 280, sprintf('xMouseX: %d', $e->xMouseX()));
            $e->xText(0, 300, sprintf('xMouseY: %d', $e->xMouseY()));

            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
