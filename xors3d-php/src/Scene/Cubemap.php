<?php

declare(strict_types=1);

namespace Xors3D\Scene;

use Xors3D\Ffi\Engine;

/**
 * Dynamic cube-map rendering helper, shared by the "cubemap" and "fx" samples.
 * Renders the scene into the six faces of a cube texture from the entity's
 * position (with the entity itself hidden).
 */
final class Cubemap
{
    /** Yaw/pitch for each of the six cube faces: left, front, right, back, top, bottom. */
    private const FACES = [
        [0, 90, 0],
        [0, 0, 0],
        [0, -90, 0],
        [0, 180, 0],
        [-90, 0, 0],
        [90, 0, 0],
    ];

    public static function update(Engine $e, int $texture, int $camera, int $entity): void
    {
        $size = $e->xTextureWidth($texture);

        $e->xShowEntity($camera);
        $e->xHideEntity($entity);

        $e->xPositionEntity(
            $camera,
            $e->xEntityX($entity, 1),
            $e->xEntityY($entity, 1),
            $e->xEntityZ($entity, 1)
        );

        $e->xCameraClsMode($camera, 0, 1);
        $e->xCameraViewport($camera, 0, 0, $size, $size);

        foreach (self::FACES as $face => [$pitch, $yaw, $roll]) {
            $e->xSetCubeFace($texture, $face);
            $e->xSetBuffer($e->xTextureBuffer($texture));
            $e->xRotateEntity($camera, $pitch, $yaw, $roll);
            $e->xRenderWorld();
        }

        $e->xShowEntity($entity);
        $e->xHideEntity($camera);
        $e->xSetBuffer($e->xBackBuffer());
    }
}
