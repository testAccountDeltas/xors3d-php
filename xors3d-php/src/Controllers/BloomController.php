<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;
use Xors3D\Scene\Skybox;

/**
 * Port of the "bloom" sample - HDR-style bloom post effect (toggle with SPACE).
 */
final class BloomController extends Controller
{
    public const TITLE = 'Bloom post effect (SPACE toggles)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Bloom sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $e->xCameraRange($cam->handle(), 0.9, 3000);
        $e->xPositionEntity($cam->handle(), 10, 0, -20);
        $e->xRotateEntity($cam->handle(), -10, 20, 0);

        $teapot = $e->xLoadMesh($this->media('Meshes/teapot.b3d'));
        $e->xPositionEntity($teapot, 0, 0, 5);
        $e->xScaleMesh($teapot, 0.3, 0.3, 0.3);
        $e->xEntityTexture($teapot, $e->xLoadTexture($this->media('Textures/tex_bloom.jpg')));

        $e->xCreateLight();

        $poly     = $e->xCreatePostEffectPoly($cam->handle(), 1);
        $texture  = $e->xCreateTexture(256, 256);
        $texture2 = $e->xCreateTexture(800, 600);

        $shader = $e->xLoadFXFile($this->media('Shaders/Bloom.fx'));
        $e->xSetEntityEffect($poly, $shader);
        $e->xSetEffectTechnique($poly, 'Diffuse');
        $e->xSetEffectMatrixSemantic($poly, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectTexture($poly, 'tDiffuse', $texture);
        $e->xSetEffectTexture($poly, 'tEmissive', $texture2);

        $sky = Skybox::create($e, $this->media('Textures/skybox'));
        $e->xScaleEntity($sky, 1000, 500, 1000);
        $e->xPositionEntity($sky, 0, 200, 0);

        $cube2 = $e->xCreateCube();
        $e->xPositionEntity($cube2, 0, 0, 30);
        $e->xScaleEntity($cube2, 5, 5, 5);

        $enable = true;

        while ($this->running()) {
            $cam->update();
            $e->xTurnEntity($teapot, 0, 1, 0);
            if ($e->xKeyHit(Constants::KEY_SPACE)) { $enable = !$enable; }

            $e->xRenderWorld();

            if ($enable) {
                $e->xStretchBackBuffer($texture, 0, 0, 256, 256, 0);
                $e->xStretchBackBuffer($texture2, 0, 0, 800, 600, 0);
                $e->xSetEffectTechnique($poly, 'Diffuse');
                $e->xRenderPostEffect($poly);
                $e->xStretchBackBuffer($texture, 0, 0, 256, 256, 0);
                $e->xSetEffectTechnique($poly, 'DiffuseH');
                $e->xRenderPostEffect($poly);
                $e->xStretchBackBuffer($texture, 0, 0, 256, 256, 0);
                $e->xSetEffectTechnique($poly, 'DiffuseV');
                $e->xRenderPostEffect($poly);
            }

            $e->xText(40, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(40, 50, 'Space - enable/disable bloom');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
