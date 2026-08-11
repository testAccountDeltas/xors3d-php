<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "r2t" sample - render to texture: the scene sphere is rendered
 * into a texture that is mapped onto a spinning cube.
 */
final class R2tController extends Controller
{
    public const TITLE = 'Render to texture';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Render to texture (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xCreateDSS(1024, 1024);
        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);

        $cam = new MouseLookCamera($e);
        $h = $cam->handle();
        $e->xPositionEntity($h, 15, 10, -100);

        $e->xLoadFont('Arial', 12);

        $light = $e->xCreateLight(Constants::LIGHT_DIRECTIONAL);
        $e->xRotateEntity($light, -45, 0, 0);

        $cube = $e->xCreateCube();
        $e->xScaleEntity($cube, 10, 10, 10);

        $test = $e->xCreateTexture(512, 512);
        $e->xEntityTexture($cube, $test);

        $sphere = $e->xCreateCube();
        $e->xScaleEntity($sphere, 10, 10, 10);
        $e->xEntityShininess($sphere, 1);
        $e->xEntityColor($sphere, 255, 0, 0);
        $e->xHideEntity($sphere);

        while ($this->running()) {
            // render sphere into the texture buffer
            $e->xSetBuffer($e->xTextureBuffer($test));
            $e->xShowEntity($sphere);
            $e->xHideEntity($cube);
            $e->xCameraClsColor($h, 192, 192, 192);
            $e->xCls();
            $e->xRenderWorld();

            // back to the main scene
            $e->xHideEntity($sphere);
            $e->xShowEntity($cube);
            $e->xSetBuffer($e->xBackBuffer());
            $e->xCameraClsColor($h, 0, 0, 0);

            $cam->update();
            $e->xTurnEntity($cube, 0, 1, 0);

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
