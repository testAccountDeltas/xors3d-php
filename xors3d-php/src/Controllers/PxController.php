<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "px" sample - a physics wall of cubes you can knock down by
 * shooting spheres (left mouse), torque a random cube (right mouse), reset (SPACE).
 * Uses the bundled xPhysics.dll.
 */
final class PxController extends Controller
{
    public const TITLE = 'Physics: shoot the cube wall';

    private const IMPULSE  = 50.0;
    private const WALL     = 5;

    /** @var int[][][] */
    private array $wall = [];

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Physics sample (PHP)', 800, 600, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;
        $n = self::WALL;

        mt_srand($this->millis());
        $e->xHidePointer();
        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 20, -100);

        $ground = $e->xCreateCube();
        $e->xPointEntity($cam->handle(), $ground);
        $e->xScaleEntity($ground, 100, 1, 100);
        $e->xEntityAddBoxShape($ground, 0.0);

        $logo = $e->xLoadTexture($this->media('Textures/logo.jpg'));
        $e->xEntityTexture($ground, $logo);

        for ($x = 0; $x < $n; $x++) {
            for ($y = 0; $y < $n; $y++) {
                for ($z = 0; $z < $n; $z++) {
                    $block = ($x === 0 && $y === 0 && $z === 0)
                        ? $e->xCreateCube()
                        : $e->xCopyEntity($this->wall[0][0][0]);
                    $e->xPositionEntity($block, ($x - intdiv($n, 2)) * 2.0, 2 + $y * 2.0, ($z - intdiv($n, 2)) * 2.0);
                    $e->xEntityAddBoxShape($block, 1.0);
                    $e->xEntityTexture($block, $logo);
                    $this->wall[$x][$y][$z] = $block;
                }
            }
        }

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, 45, 0, 0);

        while ($this->running()) {
            $cam->update();

            if ($e->xMouseHit(1)) {
                $this->shootSphere($cam->handle());
            }
            if ($e->xMouseHit(2)) {
                $e->xEntityApplyTorqueImpulse(
                    $this->wall[mt_rand(0, $n - 1)][mt_rand(0, $n - 1)][mt_rand(0, $n - 1)],
                    0.0, 100.0, 0.0
                );
            }
            if ($e->xKeyHit(Constants::KEY_SPACE)) {
                $this->resetWall();
            }

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 50, 'LMB shoot, RMB torque a random cube, SPACE reset');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }

    private function shootSphere(int $camera): void
    {
        $e = $this->engine;
        $sphere = $e->xCreateSphere();
        $e->xPositionEntity($sphere, $e->xEntityX($camera, 1), $e->xEntityY($camera, 1), $e->xEntityZ($camera, 1));
        $e->xEntityColor($sphere, 255, 0, 0);
        $e->xEntityAddSphereShape($sphere, 1.0, 1.0);
        $e->xTFormNormal(0.0, 0.0, 1.0, $camera, 0);
        $e->xEntityApplyCentralImpulse(
            $sphere,
            $e->xTFormedX() * self::IMPULSE,
            $e->xTFormedY() * self::IMPULSE,
            $e->xTFormedZ() * self::IMPULSE
        );
    }

    private function resetWall(): void
    {
        $e = $this->engine;
        $n = self::WALL;
        for ($x = 0; $x < $n; $x++) {
            for ($y = 0; $y < $n; $y++) {
                for ($z = 0; $z < $n; $z++) {
                    $b = $this->wall[$x][$y][$z];
                    $e->xPositionEntity($b, ($x - intdiv($n, 2)) * 2.0, 2 + $y * 2.0, ($z - intdiv($n, 2)) * 2.0);
                    $e->xRotateEntity($b, 0.0, 0.0, 0.0);
                    $e->xEntityReleaseForces($b);
                }
            }
        }
    }
}
