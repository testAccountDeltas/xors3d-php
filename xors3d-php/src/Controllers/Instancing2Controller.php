<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "instancing2" sample - 8000 instanced cylinders animated in a wave.
 */
final class Instancing2Controller extends Controller
{
    public const TITLE = '8000 instances with wave animation';

    private const MAX = 20;

    /** @var int[][][] */
    private array $clones = [];

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Instancing sample 2 (PHP)', 800, 600, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;
        $m = self::MAX;

        $e->xHidePointer();
        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xCameraClsColor($cam->handle(), 192, 168, 132);
        $e->xPositionEntity($cam->handle(), -90, 90, -40);

        $obj = $e->xCreateCylinder(32);
        $e->xEntityColor($obj, 0, 0, 0);

        $tex0 = $e->xLoadTexture($this->media('Textures/tex0.png'));
        $e->xLoadTexture($this->media('Textures/tex1.png'));
        $e->xEntityTexture($obj, $tex0);

        $shader = 0;
        $instancingType = 'Software emulation';
        if ($e->xHWInstancingAvailable()) {
            $shader = $e->xLoadFXFile($this->media('Shaders/hwinstancing2.fx'));
            $instancingType = 'Hardware';
        } elseif ($e->xShaderInstancingAvailable()) {
            $shader = $e->xLoadFXFile($this->media('Shaders/shaderinstancing.fx'));
            $instancingType = 'Shaders emulation';
        }
        $e->xSetEntityEffect($obj, $shader);
        $e->xSetEffectTechnique($obj, 'Instancing');

        for ($x = 0; $x < $m; $x++) {
            for ($y = 0; $y < $m; $y++) {
                for ($z = 0; $z < $m; $z++) {
                    $clone = $e->xCreateInstance($obj);
                    $e->xPositionEntity($clone, $x * 3.0, $y * 3.0, $z * 3.0);
                    $e->xRotateEntity($clone, 90.0 / $m * $x, 90.0 / $m * $y, 90.0 / $m * $z);
                    $e->xEntityColor($clone, intdiv(255, $m) * $x, intdiv(255, $m) * $y, intdiv(255, $m) * $z);
                    $this->clones[$x][$y][$z] = $clone;
                }
            }
        }
        $e->xHideEntity($obj);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, 45, 0, 0);

        $waving = true;

        while ($this->running()) {
            if ($waving) {
                $this->wave();
            }
            if ($e->xKeyHit(Constants::KEY_SPACE)) {
                $waving = !$waving;
            }

            $cam->update();

            $e->xRenderWorld();
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 50, 'DIP calls: ' . $e->xDIPCounter());
            $e->xText(10, 70, 'Entities: ' . ($m ** 3));
            $e->xText(10, 90, 'Instancing type: ' . $instancingType);
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }

    private function wave(): void
    {
        $e = $this->engine;
        $m = self::MAX;
        $time = $this->millis();
        for ($x = 0; $x < $m; $x++) {
            for ($y = 0; $y < $m; $y++) {
                for ($z = 0; $z < $m; $z++) {
                    $shift = ($x + $y + $z) / ($m * 3) * 360.0;
                    $scale = 1.0 + (sin($time / 700.0 + $shift) ** 4) / 2.0;
                    $e->xScaleEntity($this->clones[$x][$y][$z], $scale, $scale, $scale);
                }
            }
        }
    }
}
