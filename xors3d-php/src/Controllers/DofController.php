<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;
use Xors3D\Scene\Skybox;

/**
 * Port of the "dof" sample - depth-of-field post effect (toggle with SPACE).
 */
final class DofController extends Controller
{
    public const TITLE = 'Depth of field (SPACE toggles)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('DOF sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $e->xCameraRange($cam->handle(), 0.9, 3000.0);
        $e->xPositionEntity($cam->handle(), 30, 100, -480);
        $e->xRotateEntity($cam->handle(), 10, 0, 0);

        $teapot = $e->xLoadMesh($this->media('Meshes/teapot.b3d'));
        $e->xPositionEntity($teapot, 0, 0, 5);
        $e->xScaleEntity($teapot, 2, 2, 2);
        $tex1 = $e->xLoadTexture($this->media('Textures/tex_bloom.jpg'));
        $e->xEntityTexture($teapot, $tex1);

        $e->xCreateLight();

        $poly      = $e->xCreatePostEffectPoly($cam->handle(), 1);
        $lowresTex = $e->xCreateTexture(256, 256);
        $e->xCreateTexture(256, 256);
        $bbTex     = $e->xCreateTexture(800, 600);

        $dof = $e->xLoadFXFile($this->media('Shaders/DOF.fx'));
        $e->xSetEntityEffect($teapot, $dof);
        $e->xSetEffectTechnique($teapot, 'Diffuse');
        $e->xSetEffectMatrixSemantic($teapot, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($teapot, 'MatView', Constants::WORLDVIEWPROJ);
        $e->xSetEffectTexture($teapot, 'tDiffuse', $tex1);

        $teapot1 = $e->xCopyEntity($teapot);
        $e->xPositionEntity($teapot1, 0, 0, 300);
        $e->xScaleEntity($teapot1, 2, 2, 2);
        $teapot2 = $e->xCopyEntity($teapot);
        $e->xPositionEntity($teapot2, 0, 0, -300);
        $e->xScaleEntity($teapot2, 2, 2, 2);

        $e->xSetEntityEffect($poly, $dof);
        $e->xSetEffectTechnique($poly, 'DownPass');
        $e->xSetEffectMatrixSemantic($poly, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($poly, 'MatView', Constants::WORLDVIEWPROJ);
        $e->xSetEffectTexture($poly, 'tDiffuse', $tex1);
        $e->xSetEffectTexture($poly, 'tEmissive', $lowresTex);
        $e->xSetEffectTexture($teapot, 'tBB', $bbTex);

        // this SDK ships "skybox" (not "skybox1"); fall back gracefully
        $skyDir = is_dir($this->media('Textures/skybox1')) ? 'Textures/skybox1' : 'Textures/skybox';
        $sky = Skybox::create($e, $this->media($skyDir));
        $e->xScaleEntity($sky, 1000, 500, 1000);
        $e->xPositionEntity($sky, 0, 200, 0);
        $e->xSetEntityEffect($sky, $dof);
        $e->xSetEffectTechnique($sky, 'Diffuse');
        $e->xSetEffectMatrixSemantic($sky, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($sky, 'MatView', Constants::WORLDVIEWPROJ);

        $enable = true;

        while ($this->running()) {
            $cam->update();
            $e->xTurnEntity($teapot, 0, 1, 0);
            if ($e->xKeyHit(Constants::KEY_SPACE)) { $enable = !$enable; }

            $e->xSetBuffer($e->xTextureBuffer($bbTex));
            $e->xRenderWorld();
            $e->xSetBuffer($e->xBackBuffer());

            $e->xStretchRect($bbTex, 0, 0, 800, 600, $lowresTex, 0, 0, 256, 256, 0);

            if ($enable) {
                $e->xSetEffectTechnique($poly, 'DownPass');
                $e->xRenderPostEffect($poly);
                $e->xStretchBackBuffer($lowresTex, 0, 0, 256, 256, 0);
                $e->xSetEffectTechnique($poly, 'Gaus1');
                $e->xRenderPostEffect($poly);
                $e->xStretchBackBuffer($lowresTex, 0, 0, 256, 256, 0);
                $e->xSetEffectTechnique($poly, 'Gaus2');
                $e->xRenderPostEffect($poly);
                $e->xStretchBackBuffer($lowresTex, 0, 0, 256, 256, 0);
                $e->xSetEffectTechnique($poly, 'DOF1');
                $e->xRenderPostEffect($poly);
            } else {
                $e->xRenderWorld();
            }

            $e->xText(10, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 50, 'Space - enable/disable DOF');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
