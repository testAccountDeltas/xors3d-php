<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\Cubemap;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "fx" sample - a bumpy glossy metal shader on a teapot using a
 * dynamic environment cube map.
 */
final class FxController extends Controller
{
    public const TITLE = 'Bumpy glossy metal (FX + env map)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('FX File (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 30, -120);
        $e->xCameraClsColor($cam->handle(), 192, 192, 192);
        $cubeMapCamera = $e->xCreateCamera();
        $e->xCameraZoom($cubeMapCamera, 0.5);

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);

        $teapot = $e->xLoadMesh($this->media('Meshes/teapot.b3d'));
        $e->xPositionEntity($teapot, 0, 10, -50);
        $e->xLoadMesh($this->media('Meshes/level.b3d'));

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, -45, 0, 0);

        $metal = $e->xLoadFXFile($this->media('Shaders/BumpyGlossyMetal.fx'));

        $texColor  = $e->xLoadTexture($this->media('Textures/stones.bmp'));
        $texNormal = $e->xLoadTexture($this->media('Textures/bump_map.bmp'));
        $texGloss  = $e->xLoadTexture($this->media('Textures/bump_map.bmp'));
        $texEnv    = $e->xCreateTexture(256, 256, 1 + 128);

        $e->xSetEntityEffect($teapot, $metal);
        $e->xSetEffectTechnique($teapot, 'Main');
        $e->xSetEffectMatrixSemantic($teapot, 'WorldITXf', Constants::WORLDINVERSETRANSPOSE);
        $e->xSetEffectMatrixSemantic($teapot, 'WVPXf', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($teapot, 'WorldXf', Constants::WORLD);
        $e->xSetEffectMatrixSemantic($teapot, 'ViewIXf', Constants::VIEWINVERSE);
        $e->xSetEffectTexture($teapot, 'colorTexture', $texColor);
        $e->xSetEffectTexture($teapot, 'normalTexture', $texNormal);
        $e->xSetEffectTexture($teapot, 'glossTexture', $texGloss);
        $e->xSetEffectTexture($teapot, 'envTexture', $texEnv);
        $e->xSetEffectFloat($teapot, 'Bumpy', 2);

        while ($this->running()) {
            $cam->update();

            $e->xTurnEntity($teapot, 0, 1, 0);

            if ($e->xEntityInView($teapot, $cam->handle())) {
                $e->xHideEntity($cam->handle());
                Cubemap::update($e, $texEnv, $cubeMapCamera, $teapot);
                $e->xShowEntity($cam->handle());
            }

            $e->xRenderWorld();
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
