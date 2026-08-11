<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "splatting" sample - multi-texture terrain splatting with a mask.
 */
final class SplattingController extends Controller
{
    public const TITLE = 'Terrain texture splatting';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Terrain splatting (PHP)', 1024, 768, 32, 1);
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPICX16);

        $cam = new MouseLookCamera($e);
        $h = $cam->handle();
        $e->xPositionEntity($h, 2048, 100, 2048);
        $e->xCameraClsColor($h, 92, 152, 192);
        $e->xCameraRange($h, 0.25, 1000);
        $e->xCameraFogColor($h, 92, 152, 192);
        $e->xCameraFogRange($h, 300, 1000);
        $e->xCameraFogMode($h, 1);

        $e->xLoadFont('Arial', 12);

        $terrain = $e->xLoadTerrain($this->media('Textures/terrain2.png'));
        $e->xScaleEntity($terrain, 4, 350, 4);

        $grass1 = $e->xLoadTexture($this->media('Textures/grass1_diff.dds'));
        $grass2 = $e->xLoadTexture($this->media('Textures/grass3_diff.dds'));
        $rock   = $e->xLoadTexture($this->media('Textures/rock_diff.dds'));
        $mask   = $e->xLoadTexture($this->media('Textures/mask.png'));

        $scale1 = 64.0;
        $scale2 = 128.0;
        $e->xScaleTexture($grass1, 1.0 / $scale2, 1.0 / $scale2);
        $e->xScaleTexture($grass2, 1.0 / $scale1, 1.0 / $scale1);
        $e->xScaleTexture($rock,   1.0 / $scale2, 1.0 / $scale2);

        $e->xEntityTexture($terrain, $rock,   0, 0);
        $e->xEntityTexture($terrain, $grass2, 0, 1);
        $e->xEntityTexture($terrain, $grass1, 0, 2);
        $e->xEntityTexture($terrain, $mask,   0, 3);
        $e->xTerrainSplatting($terrain, 1);

        while ($this->running()) {
            $cam->update();

            $x = $e->xEntityX($h);
            $y = $e->xEntityY($h);
            $z = $e->xEntityZ($h);
            $terraY = $e->xTerrainY($terrain, $x, $y, $z) + 5;
            if ($e->xEntityY($h, 1) < $terraY) {
                $e->xPositionEntity($h, $x, $terraY, $z);
            }

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'Polygons on terrain: ' . ($e->xTerrainSize($terrain) ** 2 * 2));
            $e->xText(10, 50, 'Polygons rendered: ' . $e->xTrisRendered());
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
