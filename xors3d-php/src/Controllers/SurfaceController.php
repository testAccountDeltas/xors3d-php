<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "surface" sample - builds a textured quad from raw vertices and
 * triangles at runtime.
 */
final class SurfaceController extends Controller
{
    public const TITLE = 'Procedural surface (vertices/triangles)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Surface (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);
        $e->xAntiAlias(1);

        $tex  = $e->xLoadTexture($this->media('Textures/radiation_box.tga'));
        $mesh = $e->xCreateMesh();
        $surf = $e->xCreateSurface($mesh);

        $v0 = $e->xAddVertex($surf, -5, -5, 0, 0, 1);
        $v1 = $e->xAddVertex($surf, -5,  5, 0, 0, 0);
        $v2 = $e->xAddVertex($surf,  5,  5, 0, 1, 0);
        $v3 = $e->xAddVertex($surf,  5, -5, 0, 1, 1);

        $e->xAddTriangle($surf, $v0, $v1, $v2);
        $e->xAddTriangle($surf, $v3, $v0, $v2);

        $e->xUpdateNormals($mesh);
        $e->xEntityTexture($mesh, $tex);

        $light = $e->xCreateLight(Constants::LIGHT_DIRECTIONAL);
        $e->xRotateEntity($light, -45, 0, 0);

        $cam = new MouseLookCamera($e);
        $e->xMoveEntity($cam->handle(), 0, 0, -15);

        while ($this->running()) {
            $cam->update();

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 50, 'Vertices: ' . $e->xCountVertices($surf));
            $e->xText(10, 70, 'Triangles: ' . $e->xCountTriangles($surf));
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
