<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "r2i" sample - render to image: a sphere is rendered into an
 * image buffer that is drawn as an overlay while a cube fills the scene.
 */
final class R2iController extends Controller
{
    public const TITLE = 'Render to image';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Render to image (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $h = $cam->handle();
        $e->xPositionEntity($h, 15, 10, -100);

        $e->xLoadFont('Arial', 12);

        $light = $e->xCreateLight(Constants::LIGHT_DIRECTIONAL);
        $e->xRotateEntity($light, -45, 0, 0);

        $cube = $e->xCreateCube();
        $e->xScaleEntity($cube, 10, 10, 10);

        $image = $e->xCreateImage(256, 256);

        $sphere = $e->xCreateSphere();
        $e->xScaleEntity($sphere, 10, 10, 10);
        $e->xEntityShininess($sphere, 1);
        $e->xEntityColor($sphere, 255, 0, 0);
        $e->xHideEntity($sphere);

        while ($this->running()) {
            // render the sphere into the image buffer
            $e->xSetBuffer($e->xImageBuffer($image));
            $e->xShowEntity($sphere);
            $e->xHideEntity($cube);
            $e->xCameraClsColor($h, 192, 192, 192);
            $e->xCls();
            $e->xRenderWorld();

            // back to the main scene with the cube
            $e->xHideEntity($sphere);
            $e->xShowEntity($cube);
            $e->xSetBuffer($e->xBackBuffer());
            $e->xCameraClsColor($h, 0, 0, 0);

            $cam->update();

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xDrawImage($image, 0, 0);
            $e->xText(650, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(650, 50, 'Polygons: ' . $e->xTrisRendered());
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
