<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "army" sample - a crowd of skinned units (copied entities),
 * add more with SPACE.
 */
final class ArmyController extends Controller
{
    public const TITLE = 'Skinned crowd (SPACE adds units)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Army sample (PHP)', 800, 600, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xSetEngineSetting('LoadMesh::RelativePaths', 'false');
        mt_srand($this->millis());
        $e->xHidePointer();
        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 2, -5);

        $forceSoftware = false;
        $hardware = $e->xGetMaxVertexShaderVersion() > -1 && !$forceSoftware;
        $e->xSetSkinningMethod($hardware ? Constants::SKIN_HARDWARE : Constants::SKIN_SOFTWARE);

        $shader = 0;
        if ($hardware) {
            $shader = $e->xLoadFXFile($this->media('Shaders/skinning.fx'));
        }

        $units = [];
        $unitCnt = 0;
        $lastx = 0;
        $lasty = 0;

        $spawn = function (int $index, int $x, int $y) use ($e, &$units, $shader, $hardware): void {
            if ($index === 0) {
                $unit = $e->xLoadAnimMesh($this->media('Meshes/hazar.b3d'));
                $e->xExtractAnimSeq($unit, 2, 4);
                $e->xExtractAnimSeq($unit, 20, 59);
                $e->xExtractAnimSeq($unit, 99, 129);
            } elseif ($index === 1) {
                $unit = $e->xLoadAnimMesh($this->media('Meshes/kuznec.b3d'));
                $e->xExtractAnimSeq($unit, 2, 4);
                $e->xExtractAnimSeq($unit, 20, 59);
                $e->xExtractAnimSeq($unit, 99, 129);
            } else {
                $unit = $e->xCopyEntity($units[mt_rand(0, 1)]);
            }
            $e->xRotateEntity($unit, 0, 180, 0);
            $e->xPositionEntity($unit, $x * 2 - 9, 0, $y * 2);
            $seq = mt_rand(0, 2) + 1;
            $e->xAnimate($unit, 1, $seq === 1 ? 0.1 : 1.0, $seq);
            if ($hardware) {
                $e->xSetEntityEffect($unit, $shader);
                $e->xSetBonesArrayName($unit, 'bonesMatrixArray');
                $e->xSetEffectTechnique($unit, 'Skinned');
            }
            $units[$y * 10 + $x] = $unit;
        };

        for ($x = 0; $x < 10; $x++) {
            $spawn($x, $x, 0);
            $unitCnt++;
            $lastx = $x;
        }

        while ($this->running()) {
            $cam->update();

            if ($e->xKeyHit(Constants::KEY_SPACE)) {
                $lastx++;
                if ($lastx > 9) { $lastx = 0; $lasty++; }
                $spawn($lasty * 10 + $lastx, $lastx, $lasty);
                $unitCnt++;
            }

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 50, 'Units: ' . $unitCnt);
            $e->xText(10, 70, 'SPACE - Add new unit');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
