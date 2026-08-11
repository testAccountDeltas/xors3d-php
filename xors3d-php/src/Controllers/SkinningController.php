<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "skinning" sample - a skinned character with switchable
 * animations (1..4), hardware skinning when supported.
 */
final class SkinningController extends Controller
{
    public const TITLE = 'Skinned animation (keys 1-4)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Skinning sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xSetEngineSetting('LoadMesh::RelativePaths', 'false');
        $e->xHidePointer();
        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 2, -5);

        $forceSoftware = false;
        $hardware = $e->xGetMaxVertexShaderVersion() > -1 && !$forceSoftware;
        $e->xSetSkinningMethod($hardware ? Constants::SKIN_HARDWARE : Constants::SKIN_SOFTWARE);

        $hazar = $e->xLoadAnimMesh($this->media('Meshes/hazar.b3d'));
        $e->xRotateEntity($hazar, 0, 180, 0);

        if ($hardware) {
            $shader = $e->xLoadFXFile($this->media('Shaders/skinning.fx'));
            $e->xSetEntityEffect($hazar, $shader);
            $e->xSetBonesArrayName($hazar, 'bonesMatrixArray');
            $e->xSetEffectTechnique($hazar, 'Skinned');
        }

        // extract sequences (indices increment per extraction)
        $e->xExtractAnimSeq($hazar, 2, 4);    $animIdle   = 1;
        $e->xExtractAnimSeq($hazar, 20, 59);  $animRun    = 2;
        $e->xExtractAnimSeq($hazar, 99, 129); $animAttack = 3;
        $e->xExtractAnimSeq($hazar, 70, 87);  $animDeath  = 4;

        $e->xAnimate($hazar, 2, 0.1, $animIdle);
        $current = $animIdle;

        $labels = [
            $animIdle   => 'Idle',
            $animRun    => 'Run',
            $animAttack => 'Attack',
            $animDeath  => 'Death',
        ];

        while ($this->running()) {
            $cam->update();

            if ($e->xKeyHit(Constants::KEY_1)) { $e->xAnimate($hazar, 2, 0.1, $animIdle);   $current = $animIdle; }
            if ($e->xKeyHit(Constants::KEY_2)) { $e->xAnimate($hazar, 1, 1.0, $animRun);    $current = $animRun; }
            if ($e->xKeyHit(Constants::KEY_3)) { $e->xAnimate($hazar, 1, 1.0, $animAttack); $current = $animAttack; }
            if ($e->xKeyHit(Constants::KEY_4)) { $e->xAnimate($hazar, 3, 1.0, $animDeath);  $current = $animDeath; }

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'Key 1 - Idle animation');
            $e->xText(10, 30, 'Key 2 - Run animation');
            $e->xText(10, 50, 'Key 3 - Attack animation');
            $e->xText(10, 70, 'Key 4 - Death animation');
            $e->xText(10, 90, 'Now played - ' . $labels[$current] . ' animation');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
