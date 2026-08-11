<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "animtex" sample - an animated texture on a rotating cube.
 */
final class AnimtexController extends Controller
{
    public const TITLE = 'Animated texture on a cube';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Animation texture (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);

        $camera = $e->xCreateCamera();
        $e->xPositionEntity($camera, 0, 10, -170);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, -45, 0, 0);

        $cube = $e->xCreateCube();
        $e->xScaleEntity($cube, 20, 20, 20);
        $animTex = $e->xLoadAnimTexture($this->media('Textures/boomstrip.bmp'), 1, 64, 64, 0, 39);

        $e->xCameraClsColor($camera, 192, 192, 192);
        $e->xLoadFont('Arial', 12);

        while ($this->running()) {
            $texFrame = intdiv($this->millis(), 50) % 39;
            $e->xEntityTexture($cube, $animTex, $texFrame);

            $pitch = 0.0; $yaw = 0.0; $roll = 0.0;
            if ($e->xKeyDown(Constants::KEY_DOWN))  { $pitch = -1.0; }
            if ($e->xKeyDown(Constants::KEY_UP))    { $pitch =  1.0; }
            if ($e->xKeyDown(Constants::KEY_LEFT))  { $yaw   = -1.0; }
            if ($e->xKeyDown(Constants::KEY_RIGHT)) { $yaw   =  1.0; }
            if ($e->xKeyDown(Constants::KEY_X))     { $roll  = -1.0; }
            if ($e->xKeyDown(Constants::KEY_Z))     { $roll  =  1.0; }
            $e->xTurnEntity($cube, $pitch, $yaw, $roll);

            $e->xRenderWorld();

            $e->xColor(0, 0, 0);
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'Up/Down/Left/Right/Z/X - rotate cube');

            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
