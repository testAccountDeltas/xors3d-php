<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "clipplane" sample - an animated camera clip plane slicing a level.
 */
final class ClipplaneController extends Controller
{
    public const TITLE = 'Animated camera clip plane';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Clipplane (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 20, 30);
        $e->xRotateEntity($cam->handle(), 0, 180, 0);
        $e->xCameraClsColor($cam->handle(), 92, 192, 255);
        $e->xCameraRange($cam->handle(), 0.1, 1000);

        $e->xLoadFont('Arial', 12);

        $light = $e->xCreateLight(Constants::LIGHT_DIRECTIONAL);
        $e->xRotateEntity($light, -45, 0, 0);

        $e->xLoadMesh($this->media('Meshes/level.b3d'));

        $e->xCameraClipPlane($cam->handle(), 0, 1, 0, 1, 0, 0);
        $pivot = $e->xCreatePivot();

        while ($this->running()) {
            $e->xTurnEntity($pivot, 0, 0, 0.1);
            $e->xTFormPoint(0, 1, 0, $pivot, 0);
            $e->xCameraClipPlane($cam->handle(), 0, 1, $e->xTFormedX(), $e->xTFormedY(), $e->xTFormedZ(), 30);

            $cam->update();

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xColor(255, 0, 0);
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'Polygons: ' . $e->xTrisRendered());
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
