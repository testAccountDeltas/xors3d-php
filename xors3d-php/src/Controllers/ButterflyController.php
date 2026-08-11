<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "butterfly" sample - iridescent shader on butterfly wings.
 */
final class ButterflyController extends Controller
{
    public const TITLE = 'Iridescent butterfly (FX shader)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Butterfly (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 70, -120);
        $e->xRotateEntity($cam->handle(), 15, 0, 0);
        $e->xCameraClsColor($cam->handle(), 192, 192, 192);

        $wings = $e->xLoadMesh($this->media('Meshes/ButterflyWings.b3d'));
        $e->xRotateEntity($wings, 0, 0, -90);
        $body = $e->xLoadMesh($this->media('Meshes/ButterflyBody.b3d'));
        $e->xRotateEntity($body, 0, 0, -90);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, -45, 0, 0);

        $butterfly = $e->xLoadFXFile($this->media('Shaders/IridescentButterfly.fx'));
        if (!$e->xValidateEffectTechnique($butterfly, 'IridescentButterfly')) {
            fwrite(STDERR, "Warning: 'IridescentButterfly' technique is not supported by this GPU.\n");
        }

        $tex1 = $e->xLoadTexture($this->media('Textures/gradientMap.bmp'));
        $tex2 = $e->xLoadTexture($this->media('Textures/baseOpacityMap.tga'));
        $tex3 = $e->xLoadTexture($this->media('Textures/bumpGlossMap.tga'));

        $e->xSetEntityEffect($wings, $butterfly);
        $e->xSetEffectTechnique($wings, 'IridescentButterfly');
        $e->xSetEffectMatrixSemantic($wings, 'world_view_proj_matrix', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($wings, 'inv_view_matrix', Constants::VIEWINVERSE);
        $e->xSetEffectTexture($wings, 'baseOpacityMap_Tex', $tex2);
        $e->xSetEffectTexture($wings, 'bumpGlossMap_Tex', $tex3);
        $e->xSetEffectTexture($wings, 'gradientMap_Tex', $tex1);
        $e->xEntityAlpha($wings, 0.5);

        while ($this->running()) {
            $cam->update();

            $e->xSetEffectVector(
                $wings,
                'view_position',
                $e->xEntityX($cam->handle()),
                $e->xEntityY($cam->handle()),
                $e->xEntityZ($cam->handle())
            );

            $e->xRenderWorld();
            $e->xColor(0, 0, 0);
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
