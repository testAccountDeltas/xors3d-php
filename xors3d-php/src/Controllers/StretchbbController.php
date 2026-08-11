<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "stretchbb" sample - copies the back buffer into a texture that
 * is mapped onto a cube (feedback effect).
 */
final class StretchbbController extends Controller
{
    public const TITLE = 'Stretch back buffer to texture';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Stretch Back buffer (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, -40, 40, 40);

        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);

        $cam = new MouseLookCamera($e);
        $e->xCameraClsColor($cam->handle(), 192, 192, 192);
        $e->xPositionEntity($cam->handle(), 0, 10, -80);

        $loadTex = $e->xLoadTexture($this->media('Textures/bricks.jpg'));
        $bbTex   = $e->xCreateTexture(800, 600);

        $cube1 = $e->xCreateCube();
        $e->xScaleEntity($cube1, 10, 10, 10);
        $e->xPositionEntity($cube1, 20, 0, 0);
        $e->xEntityTexture($cube1, $bbTex);

        $cube2 = $e->xCreateCube();
        $e->xScaleEntity($cube2, 10, 10, 10);
        $e->xPositionEntity($cube2, -20, 0, 0);
        $e->xEntityTexture($cube2, $loadTex);

        $cube3 = $e->xCreateCube();
        $e->xScaleEntity($cube3, 10, 10, 10);
        $e->xPositionEntity($cube3, 0, 30, 0);
        $e->xEntityTexture($cube3, $loadTex);

        $e->xLoadFont('Arial', 12);

        while ($this->running()) {
            $cam->update();

            $e->xTurnEntity($cube1, 0, -1, 0);

            $e->xCameraClsColor($cam->handle(), 0, 0, 0);
            $e->xRenderWorld();

            $e->xStretchBackBuffer($bbTex, 0, 0, 800, 600, 0);
            $e->xCameraClsColor($cam->handle(), 192, 192, 192);

            $e->xUpdateWorld();
            $e->xRenderWorld();

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
