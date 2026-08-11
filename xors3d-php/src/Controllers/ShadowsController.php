<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "shadows" sample - shadow-mapped scene with an animated warrior,
 * a fire with an additive sprite particle system, and two shadow-casting lights.
 */
final class ShadowsController extends Controller
{
    public const TITLE = 'Shadow mapping + fire particles';

    /** @var array<int,array{entity:int,speed:float,alpha:float}> */
    private array $particles = [];

    public function index(int|string $maxFrames = 0): int
    {
        $e = $this->engine;
        $e->xKey($this->config->firstKey());
        $e->xSetAntiAliasType(0);
        $e->xAppTitle('Shadows sample (PHP)');
        $e->xGraphics3D(800, 600, 32, 0, 1);
        $e->xCreateDSS(1024, 1024);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPICX16);
        $e->xHidePointer();
        $max = (int) $maxFrames;
        $frame = 0;

        $cam = new MouseLookCamera($e);
        $e->xCameraRange($cam->handle(), 0.1, 1000.0);
        $e->xPositionEntity($cam->handle(), -50, 10, -50);
        $e->xCameraEnableShadows($cam->handle());

        $terrain = $e->xCreateCube();
        $e->xScaleEntity($terrain, 200, 0.1, 200);
        $grass = $e->xLoadTexture($this->media('Textures/gras_diffuse_1a.jpg'));
        $e->xScaleTexture($grass, 0.1, 0.1);
        $e->xEntityTexture($terrain, $grass, 0, 0);

        $bereza = $e->xLoadMesh($this->media('Meshes/bereza.b3d'));
        $e->xScaleEntity($bereza, 7, 7, 7);

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, 45, 0, 0);
        $e->xLightColor($light, 25, 25, 25);

        $skybox = $e->xLoadMesh($this->media('Meshes/skydome.b3d'));
        $e->xEntityFX($skybox, 1);
        $e->xScaleEntity($skybox, 0.5, 0.5, 0.5);
        $e->xEntityColor($skybox, 15, 15, 15);
        $e->xEntityOrder($skybox, 1);

        $warrior = $e->xLoadAnimMesh($this->media('Meshes/kuznec.b3d'));
        $e->xEntityColor($warrior, 255, 255, 255);
        $e->xPositionEntity($warrior, 10, 0, -5);
        $e->xScaleEntity($warrior, 5, 5, 5);
        $e->xExtractAnimSeq($warrior, 20, 59);
        $e->xAnimate($warrior, 1, 1.2, 1);

        $light2 = $e->xCreateLight(2);
        $e->xLightRange($light2, 50);
        $e->xLightColor($light2, 255, 0, 0);
        $fire = $e->xLoadMesh($this->media('Meshes/koster.b3d'));
        $e->xPositionEntity($fire, -10, 0, -10);
        $e->xPositionEntity($light2, -10, 10, -10);
        $e->xScaleEntity($fire, 0.07, 0.07, 0.07);
        $flame = $e->xLoadTexture($this->media('Textures/fire.jpg'), 1 + 2);
        $e->xTextureBlend($flame, 5);
        $lastCreated = 0;

        $e->xInitShadows(1024, 0, 512);
        $e->xLightEnableShadows($light, 1);
        $e->xSetShadowParams(4, 0.85, 1, 300);
        $e->xLightShadowEpsilons($light, 0.0001, 0.16);
        $e->xLightEnableShadows($light2, 1);
        $e->xLightShadowEpsilons($light2, 0.01, 0.0);

        while ($this->running()) {
            $cam->update();

            $now = $this->millis();
            if ($now > $lastCreated) {
                $this->createParticle(
                    $e->xEntityX($fire, 1) + $this->rnd(-0.1, 0.1),
                    $e->xEntityY($fire, 1),
                    $e->xEntityZ($fire, 1) + $this->rnd(-0.1, 0.1),
                    $flame
                );
                $lastCreated = $now + 25;
            }
            $this->updateParticles();

            $e->xMoveEntity($warrior, 0, 0, 0.3);
            $e->xTurnEntity($warrior, 0, 1, 0);

            $e->xPositionEntity($skybox,
                $e->xEntityX($cam->handle()), $e->xEntityY($cam->handle()) - 1, $e->xEntityZ($cam->handle()));

            $e->xUpdateWorld();
            $e->xRenderWorld(1.0, 1); // render shadows

            $e->xColor(200, 0, 0);
            $e->xText(10, 10, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 50, 'DIP calls: ' . $e->xDIPCounter());
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }

    private function rnd(float $min, float $max): float
    {
        return $min + ($max - $min) * (mt_rand() / mt_getrandmax());
    }

    private function createParticle(float $x, float $y, float $z, int $texture): void
    {
        $e = $this->engine;
        $sprite = $e->xCreateSprite();
        $e->xEntityTexture($sprite, $texture);
        $e->xEntityFX($sprite, 1);
        $e->xEntityBlend($sprite, 3);
        $e->xPositionEntity($sprite, $x, $y, $z);
        $e->xScaleSprite($sprite, $this->rnd(2.0, 5.0), $this->rnd(2.0, 5.0));
        $this->particles[] = ['entity' => $sprite, 'speed' => $this->rnd(0.2, 0.5), 'alpha' => 1.0];
    }

    private function updateParticles(): void
    {
        $e = $this->engine;
        foreach ($this->particles as $i => &$p) {
            $e->xTranslateEntity($p['entity'], 0.0, $p['speed'], 0.0);
            $p['alpha'] -= 0.05;
            $e->xEntityAlpha($p['entity'], $p['alpha']);
            if ($p['alpha'] < 0.001) {
                $e->xFreeEntity($p['entity']);
                unset($this->particles[$i]);
            }
        }
        unset($p);
    }
}
