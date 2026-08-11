<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "pointing" sample - a skinned character whose head tracks a
 * mouse-controlled target (hardware skinning shader when available).
 */
final class PointingController extends Controller
{
    public const TITLE = 'Skinned mesh head-tracking';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Pointing sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xHidePointer();
        $e->xAntiAlias(1);

        $camera = $e->xCreateCamera();
        $e->xPositionEntity($camera, 0, 2, -10);

        $forceSoftware = false;
        $hardware = $e->xGetMaxVertexShaderVersion() > -1 && !$forceSoftware;
        $e->xSetSkinningMethod($hardware ? Constants::SKIN_HARDWARE : Constants::SKIN_SOFTWARE);

        $kuznec = $e->xLoadAnimMesh($this->media('Meshes/kuznec.b3d'));
        $head   = $e->xFindChild($kuznec, 'Bone10');
        $e->xRotateEntity($kuznec, 0, 180, 0);

        if ($hardware) {
            $shader = $e->xLoadFXFile($this->media('Shaders/skinning.fx'));
            $e->xSetEntityEffect($kuznec, $shader);
            $e->xSetBonesArrayName($kuznec, 'bonesMatrixArray');
            $e->xSetEffectTechnique($kuznec, 'Skinned');
        }

        $e->xExtractAnimSeq($kuznec, 99, 129);
        $e->xAnimate($kuznec, 1, 1.0, 1);
        $e->xAnimate($kuznec, 0, 1.0, 0, 0, 'Bone10'); // freeze head animation

        $target = $e->xCreateSphere();
        $e->xScaleEntity($target, 0.1, 0.1, 0.1);
        $e->xPositionEntity($target, 3, 2, -2);
        $e->xMoveMouse((int) ($e->xGraphicsWidth() / 2), (int) ($e->xGraphicsHeight() / 2));

        while ($this->running()) {
            $e->xMoveEntity($target, $e->xMouseXSpeed() * 0.05, -($e->xMouseYSpeed() * 0.05), 0.0);
            $e->xMoveMouse((int) ($e->xGraphicsWidth() / 2), (int) ($e->xGraphicsHeight() / 2));

            if ($e->xEntityX($target) >  5.0) { $e->xPositionEntity($target,  5, $e->xEntityY($target), 0); }
            if ($e->xEntityX($target) < -5.0) { $e->xPositionEntity($target, -5, $e->xEntityY($target), 0); }
            if ($e->xEntityY($target) >  6.0) { $e->xPositionEntity($target, $e->xEntityX($target),  6, 0); }
            if ($e->xEntityY($target) < -2.0) { $e->xPositionEntity($target, $e->xEntityX($target), -2, 0); }

            $e->xPointEntity($head, $target);
            $e->xTurnEntity($head, 0, -90, 90); // fix axis

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'Move the mouse');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
