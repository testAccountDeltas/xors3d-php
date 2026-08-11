<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "glass" sample - a glass/fresnel shader on a teapot and sphere,
 * with arrow-key orbit and adjustable falloff colour.
 */
final class GlassController extends Controller
{
    public const TITLE = 'Glass / fresnel shader';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Glass (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $pivot  = $e->xCreatePivot();
        $camera = $e->xCreateCamera($pivot);
        $e->xCameraRange($camera, 0.9, 3000.0);
        $e->xPositionEntity($camera, 0, 0, -120);

        $teapot = $e->xLoadMesh($this->media('Meshes/teapot.b3d'));
        $e->xPositionEntity($teapot, 30, -15, 0);

        $sphere = $e->xCreateSphere(30);
        $e->xPositionEntity($sphere, -30, 0, 0);
        $e->xScaleEntity($sphere, 20, 20, 20);

        $cubeTex = $e->xLoadTexture($this->media('Textures/Snow.dds'), 128);
        $e->xCreatePostEffectPoly($camera, 1);
        $e->xCreateTexture(256, 256);
        $e->xCreateTexture(256, 256);
        $e->xCreateTexture(800, 600);

        $glassFX = $e->xLoadFXFile($this->media('Shaders/Glass.fx'));

        $sky = $e->xCreateSphere();
        $e->xFlipMesh($sky);
        $e->xScaleEntity($sky, 500, 500, 500);
        $e->xSetEntityEffect($sky, $glassFX);
        $e->xSetEffectTechnique($sky, 'Sky');
        $e->xSetEffectMatrixSemantic($sky, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($sky, 'MatWorld', Constants::WORLD);
        $e->xSetEffectTexture($sky, 'tDiffuse', $cubeTex);

        foreach ([$teapot, $sphere] as $obj) {
            $e->xSetEntityEffect($obj, $glassFX);
            $e->xSetEffectTechnique($obj, 'Diffuse');
            $e->xSetEffectMatrixSemantic($obj, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
            $e->xSetEffectMatrixSemantic($obj, 'MatWorld', Constants::WORLD);
            $e->xSetEffectTexture($obj, 'tDiffuse', $cubeTex);
        }

        $r = 0.0; $g = 0.0; $b = 0.2; $fallOffPow = 3.0;

        while ($this->running()) {
            if ($e->xKeyDown(Constants::KEY_UP))    { $e->xTurnEntity($pivot,  1.0,  0.0, 0.0, 1); }
            if ($e->xKeyDown(Constants::KEY_DOWN))  { $e->xTurnEntity($pivot, -1.0,  0.0, 0.0, 1); }
            if ($e->xKeyDown(Constants::KEY_LEFT))  { $e->xTurnEntity($pivot,  0.0,  1.0, 0.0, 1); }
            if ($e->xKeyDown(Constants::KEY_RIGHT)) { $e->xTurnEntity($pivot,  0.0, -1.0, 0.0, 1); }

            $cl = 0.01;
            if ($e->xKeyDown(Constants::KEY_Q)) { $r += $cl; }
            if ($e->xKeyDown(Constants::KEY_A)) { $r -= $cl; }
            if ($e->xKeyDown(Constants::KEY_W)) { $g += $cl; }
            if ($e->xKeyDown(Constants::KEY_S)) { $g -= $cl; }
            if ($e->xKeyDown(Constants::KEY_E)) { $b += $cl; }
            if ($e->xKeyDown(Constants::KEY_D)) { $b -= $cl; }
            $r = max(0.0, min(1.0, $r));
            $g = max(0.0, min(1.0, $g));
            $b = max(0.0, min(1.0, $b));

            $cl = 0.03;
            if ($e->xKeyDown(Constants::KEY_R)) { $fallOffPow += $cl; }
            if ($e->xKeyDown(Constants::KEY_F)) { $fallOffPow -= $cl; }

            $e->xSetEffectVector($teapot, 'view_position',
                $e->xEntityX($camera, 1), $e->xEntityY($camera, 1), $e->xEntityZ($camera, 1));
            $e->xSetEffectVector($teapot, 'FallOffCol', $r, $g, $b, 1.0);
            $e->xSetEffectFloat($teapot, 'FallOffPow', $fallOffPow);

            $e->xTurnEntity($teapot, 0, 1, 0);

            $e->xRenderWorld();
            $e->xText(10, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 60, sprintf('r (Q/A): %.2f  g (W/S): %.2f  b (E/D): %.2f', $r, $g, $b));
            $e->xText(10, 80, sprintf('FallOffPow (R/F): %.2f', $fallOffPow));
            $e->xText(10, 100, 'Control: arrows');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
