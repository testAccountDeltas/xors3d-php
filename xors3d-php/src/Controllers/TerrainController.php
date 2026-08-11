<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "terrain" sample - heightmap terrain with fog and a walking camera.
 */
final class TerrainController extends Controller
{
    public const TITLE = 'Heightmap terrain + fog';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Terrain (PHP)', 1024, 768, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPICX16);

        $cam = new MouseLookCamera($e);
        $h = $cam->handle();
        $e->xPositionEntity($h, 2048, 0, 2048);
        $e->xCameraClsColor($h, 192, 192, 192);
        $e->xCameraRange($h, 0.1, 1000.0);
        $e->xCameraFogMode($h, 1);
        $e->xCameraFogColor($h, 130, 130, 150);
        $e->xCameraFogRange($h, 500, 1000);

        $e->xLoadFont('Arial', 12);

        $light = $e->xCreateLight(Constants::LIGHT_DIRECTIONAL);
        $e->xRotateEntity($light, 45, 0, 0);

        $terrain = $e->xLoadTerrain($this->media('Textures/terrain.png'));
        $e->xScaleEntity($terrain, 1, 200, 1);
        $grass = $e->xLoadTexture($this->media('Textures/IceTerrain.jpg'));
        $e->xEntityTexture($terrain, $grass, 0, 0);
        $e->xEntityFX($terrain, 1);

        while ($this->running()) {
            $cam->update();

            $x = $e->xEntityX($h);
            $y = $e->xEntityY($h);
            $z = $e->xEntityZ($h);
            $e->xPositionEntity($h, $x, $e->xTerrainY($terrain, $x, $y, $z) + 5, $z);

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
