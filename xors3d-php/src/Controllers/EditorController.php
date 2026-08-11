<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "editor" sample - move/rotate/scale gizmos (keys 1/2/3) acting on
 * a cube, driven by the mouse.
 */
final class EditorController extends Controller
{
    public const TITLE = 'Transform gizmos (keys 1/2/3)';

    private float $ctrlX = 0.0;
    private float $ctrlY = 0.0;
    private float $ctrlZ = 0.0;
    private int $mouseSpeedX = 0;
    private int $mouseSpeedY = 0;

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Editor sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);

        $camera = $e->xCreateCamera();
        $e->xCameraClsColor($camera, 192, 192, 192);
        $e->xPositionEntity($camera, 10, 10, 10);

        $e->xCreateLight();

        $cube = $e->xCreateCube();
        $e->xPointEntity($camera, $cube);
        $e->xEntityTexture($cube, $e->xLoadTexture($this->media('Textures/logo.jpg')));

        $controlType = 0; // 0 move, 1 rotate, 2 scale
        $selectMask = 0;
        $deltaX = 1.0; $deltaY = 1.0; $deltaZ = 1.0;
        $scaleX = 1.0; $scaleY = 1.0; $scaleZ = 1.0;
        $used = '';

        while ($this->running()) {
            $e->xColor(100, 0, 0);
            $this->mouseSpeedX = $e->xMouseXSpeed();
            $this->mouseSpeedY = $e->xMouseYSpeed();

            if ($e->xKeyDown(Constants::KEY_W)) { $e->xMoveEntity($camera, 0, 0,  1); }
            if ($e->xKeyDown(Constants::KEY_S)) { $e->xMoveEntity($camera, 0, 0, -1); }
            if ($e->xKeyDown(Constants::KEY_A)) { $e->xMoveEntity($camera, -1, 0, 0); }
            if ($e->xKeyDown(Constants::KEY_D)) { $e->xMoveEntity($camera,  1, 0, 0); }
            if ($e->xKeyHit(Constants::KEY_1)) { $controlType = 0; }
            if ($e->xKeyHit(Constants::KEY_2)) { $controlType = 1; }
            if ($e->xKeyHit(Constants::KEY_3)) { $controlType = 2; }

            $e->xRenderWorld();
            $e->xDrawGrid(0, 0, 5, 100);

            $x = $e->xEntityX($cube);
            $y = $e->xEntityY($cube);
            $z = $e->xEntityZ($cube);

            if ($controlType === 0) {
                $mask = $e->xCheckMovementGizmo($x, $y, $z, $camera, $e->xMouseX(), $e->xMouseY());
                if (!$e->xMouseDown(1)) {
                    $selectMask = $mask;
                    $this->ctrlX = $x; $this->ctrlY = $y; $this->ctrlZ = $z;
                }
                $e->xDrawMovementGizmo($x, $y, $z, $selectMask);
                $used = 'Used move controller';
            } elseif ($controlType === 1) {
                $mask = $e->xCheckRotationGizmo($x, $y, $z, $camera, $e->xMouseX(), $e->xMouseY());
                if (!$e->xMouseDown(1)) {
                    $selectMask = $mask;
                    $this->ctrlX = $x; $this->ctrlY = $y; $this->ctrlZ = $z;
                    $deltaX = 0.0; $deltaY = 0.0; $deltaZ = 0.0;
                }
                $e->xDrawRotationGizmo($x, $y, $z, $selectMask, $deltaX, $deltaY, $deltaZ);
                $used = 'Used rotate controller';
            } else {
                $mask = $e->xCheckScaleGizmo($x, $y, $z, $camera, $e->xMouseX(), $e->xMouseY());
                if (!$e->xMouseDown(1)) {
                    $selectMask = $mask;
                    $this->ctrlX = $x; $this->ctrlY = $y; $this->ctrlZ = $z;
                    $deltaX = 1.0; $deltaY = 1.0; $deltaZ = 1.0;
                    $scaleX = $e->xEntityScaleX($cube);
                    $scaleY = $e->xEntityScaleY($cube);
                    $scaleZ = $e->xEntityScaleZ($cube);
                }
                $e->xDrawScaleGizmo($x, $y, $z, $selectMask, $deltaX, $deltaY, $deltaZ);
                $used = 'Used scale controller';
            }

            if ($e->xMouseDown(1) && $selectMask !== 0) {
                $useX = ($selectMask & 1) > 0;
                $useY = ($selectMask & 2) > 0;
                $useZ = ($selectMask & 4) > 0;
                $factorX = 0.7 / $e->xGraphicsWidth();
                $factorY = 0.7 / $e->xGraphicsHeight();

                $dx = $this->ctrlX - $e->xEntityX($camera, 1);
                $dy = $this->ctrlY - $e->xEntityY($camera, 1);
                $dz = $this->ctrlZ - $e->xEntityZ($camera, 1);
                $dist = sqrt($dx * $dx + $dy * $dy + $dz * $dz);

                if ($controlType === 0) {
                    if ($useX) { $e->xTranslateEntity($cube, $this->computeMove($camera, 10, 0, 0) * $factorX * $dist, 0, 0, 0); }
                    if ($useY) { $e->xTranslateEntity($cube, 0, $this->computeMove($camera, 0, 10, 0) * $factorY * $dist, 0, 0); }
                    if ($useZ) { $e->xTranslateEntity($cube, 0, 0, $this->computeMove($camera, 0, 0, 10) * $factorX * $dist, 0); }
                } elseif ($controlType === 2) {
                    if ($useX) { $scaleX += $this->computeMove($camera, 10, 0, 0) * $factorX * $dist; $e->xScaleEntity($cube, $scaleX, $scaleY, $scaleZ); }
                    if ($useY) { $scaleY += $this->computeMove($camera, 0, 10, 0) * $factorY * $dist; $e->xScaleEntity($cube, $scaleX, $scaleY, $scaleZ); }
                    if ($useZ) { $scaleZ += $this->computeMove($camera, 0, 0, 10) * $factorX * $dist; $e->xScaleEntity($cube, $scaleX, $scaleY, $scaleZ); }
                } else {
                    if ($useX) { $e->xTurnEntity($cube, $this->computeMove($camera, 0, -10, 0), 0, 0, 1); }
                    if ($useY) { $e->xTurnEntity($cube, 0, $this->computeMove($camera, -10, -10, 0), 0, 1); }
                    if ($useZ) { $e->xTurnEntity($cube, 0, 0, $this->computeMove($camera, -10, 0, 0), 1); }
                }
            }

            $e->xText(10, 10, 'Use WSAD to move camera around scene');
            $e->xText(10, 30, 'Use 1, 2, 3 to change object controller');
            $e->xText(10, 50, $used);
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }

    /** Projects an axis to screen space and measures mouse motion along it. */
    private function computeMove(int $camera, float $x, float $y, float $z): float
    {
        if ($this->mouseSpeedX === 0 && $this->mouseSpeedY === 0) {
            return 0.0;
        }
        $e = $this->engine;
        $e->xCameraProject($camera, $this->ctrlX, $this->ctrlY, $this->ctrlZ);
        $x1 = $e->xProjectedX(); $y1 = $e->xProjectedY();
        $e->xCameraProject($camera, $this->ctrlX + $x, $this->ctrlY + $y, $this->ctrlZ + $z);
        $x2 = $e->xProjectedX(); $y2 = $e->xProjectedY();

        $dx1 = $x2 - $x1; $dy1 = $y2 - $y1;
        $dx2 = (float) $this->mouseSpeedX; $dy2 = (float) $this->mouseSpeedY;
        $len1 = sqrt($dx1 * $dx1 + $dy1 * $dy1);
        $len2 = sqrt($dx2 * $dx2 + $dy2 * $dy2);
        if ($len1 == 0.0 || $len2 == 0.0) {
            return 0.0;
        }
        $angle = acos(max(-1.0, min(1.0, ($dx1 * $dx2 + $dy1 * $dy2) / ($len1 * $len2))));
        return $len2 * cos($angle);
    }
}
