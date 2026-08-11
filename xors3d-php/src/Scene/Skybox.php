<?php

declare(strict_types=1);

namespace Xors3D\Scene;

use Xors3D\Ffi\Engine;

/**
 * Builds a sky-box mesh from six directional textures in a folder
 * (left/front/right/back/top .jpg), as used by the "bloom" and "dof" samples.
 */
final class Skybox
{
    /** Each face: [textureName, [v0..v3 as [x,y,z,u,v]]]. */
    private const FACES = [
        ['left.jpg',  [[-1, 1, -1, 0, 0], [-1, 1, 1, 1, 0], [-1, -1, -1, 0, 1], [-1, -1, 1, 1, 1]]],
        ['front.jpg', [[-1, 1, 1, 0, 0], [1, 1, 1, 1, 0], [-1, -1, 1, 0, 1], [1, -1, 1, 1, 1]]],
        ['right.jpg', [[1, 1, 1, 0, 0], [1, 1, -1, 1, 0], [1, -1, 1, 0, 1], [1, -1, -1, 1, 1]]],
        ['back.jpg',  [[1, 1, -1, 0, 0], [-1, 1, -1, 1, 0], [1, -1, -1, 0, 1], [-1, -1, -1, 1, 1]]],
        ['top.jpg',   [[-1, 1, 1, 0, 0], [-1, 1, -1, 1, 0], [1, 1, 1, 0, 1], [1, 1, -1, 1, 1]]],
    ];

    public static function create(Engine $e, string $dir): int
    {
        $dir = rtrim($dir, '\\/') . '\\';
        $skybox = $e->xCreateMesh();

        foreach (self::FACES as [$texName, $verts]) {
            $texture = $e->xLoadTexture($dir . $texName, 49);
            $brush   = $e->xCreateBrush();
            $e->xBrushTexture($brush, $texture);
            $surface = $e->xCreateSurface($skybox, $brush);

            $handles = [];
            foreach ($verts as [$x, $y, $z, $u, $v]) {
                $handles[] = $e->xAddVertex($surface, $x, $y, $z, $u, $v);
            }
            [$v0, $v1, $v2, $v3] = $handles;
            $e->xAddTriangle($surface, $v2, $v1, $v0);
            $e->xAddTriangle($surface, $v1, $v2, $v3);
        }

        $e->xEntityFX($skybox, 1);
        $e->xFlipMesh($skybox);
        $e->xUpdateNormals($skybox);
        return $skybox;
    }
}
