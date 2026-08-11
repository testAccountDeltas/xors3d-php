<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\Cubemap;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "cubemap" sample - a reflective teapot using a dynamically
 * rendered cube map.
 */
final class CubemapController extends Controller
{
    public const TITLE = 'Dynamic cube-map reflection';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('CubeMap (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 30, -150);
        $cubeMapCamera = $e->xCreateCamera();
        $e->xCameraZoom($cubeMapCamera, 0);

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPICX16);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, -45, 0, 0);

        $teapot = $e->xLoadMesh($this->media('Meshes/teapot.b3d'));
        $e->xPositionEntity($teapot, 0, 10, -50);
        $e->xEntityFX($teapot, 1);
        $e->xLoadMesh($this->media('Meshes/level.b3d'));

        $tex = $e->xCreateTexture(256, 256, 1 + 128);
        $e->xEntityTexture($teapot, $tex);

        while ($this->running()) {
            $cam->update();

            $e->xTurnEntity($teapot, 0, 1, 0);

            if ($e->xEntityInView($teapot, $cam->handle())) {
                $e->xHideEntity($cam->handle());
                Cubemap::update($e, $tex, $cubeMapCamera, $teapot);
                $e->xShowEntity($cam->handle());
            }

            $e->xRenderWorld();
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 60, 'Mouse - rotate camera');
            $e->xText(10, 80, 'W/A/S/D - move camera');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
