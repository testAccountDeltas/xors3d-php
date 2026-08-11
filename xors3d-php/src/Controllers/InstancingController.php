<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "instancing" sample - 1000 instanced cubes (hardware, shader, or
 * software emulation depending on GPU support).
 */
final class InstancingController extends Controller
{
    public const TITLE = '1000 instanced cubes';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Instancing sample (PHP)', 800, 600, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xHidePointer();
        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 13, 13, -50);

        $cube = $e->xCreateCube();
        $logo = $e->xLoadTexture($this->media('Textures/logo.jpg'));
        $e->xEntityTexture($cube, $logo);

        $shader = 0;
        $instancingType = 'Software emulation';
        if ($e->xHWInstancingAvailable()) {
            $shader = $e->xLoadFXFile($this->media('Shaders/hwinstancing.fx'));
            $instancingType = 'Hardware';
        } elseif ($e->xShaderInstancingAvailable()) {
            $shader = $e->xLoadFXFile($this->media('Shaders/shaderinstancing.fx'));
            $instancingType = 'Shaders emulation';
        }
        $e->xSetEntityEffect($cube, $shader);
        $e->xSetEffectTechnique($cube, 'Instancing');

        for ($x = 0; $x < 10; $x++) {
            for ($y = 0; $y < 10; $y++) {
                for ($z = 0; $z < 10; $z++) {
                    $clone = $e->xCreateInstance($cube);
                    $e->xPositionEntity($clone, $x * 3.0, $y * 3.0, $z * 3.0);
                }
            }
        }
        $e->xHideEntity($cube);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, 45, 0, 0);

        while ($this->running()) {
            $cam->update();

            $e->xRenderWorld();
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 50, 'DIP calls: ' . $e->xDIPCounter());
            $e->xText(10, 70, 'Instancing type: ' . $instancingType);
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
