<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "forest" sample - instanced forest on a shaded terrain with a
 * third-person animated warrior, fire particles and toggleable shadows (Q).
 */
final class ForestController extends Controller
{
    public const TITLE = 'Instanced forest + third-person camera';

    /** @var array<int,array{entity:int,speed:float,alpha:float}> */
    private array $particles = [];

    public function index(int|string $maxFrames = 0): int
    {
        $e = $this->engine;
        $e->xKey($this->config->firstKey());
        $e->xSetAntiAliasType(0);
        $e->xAppTitle('Forest sample (PHP)');
        $e->xGraphics3D(800, 600, 32, 0, 1);
        $e->xSetEngineSetting('LoadMesh::RelativePaths', 'false');
        $e->xCreateDSS(1024, 1024);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPICX16);
        $e->xHidePointer();
        $e->xAntiAlias(1);
        $max = (int) $maxFrames;
        $frame = 0;

        $camera = $e->xCreateCamera();
        $e->xCameraRange($camera, 0.1, 1000.0);
        $e->xCameraEnableShadows($camera);
        $cameraDist = 50.0;

        $terrain = $e->xLoadTerrain($this->media('Textures/height_map.bmp'));
        $e->xTerrainShading($terrain, 1);
        $e->xScaleEntity($terrain, 10, 70, 10);
        $grass = $e->xLoadTexture($this->media('Textures/gras_diffuse_1a.jpg'));
        $e->xScaleTexture($grass, 0.01, 0.01);
        $e->xEntityTexture($terrain, $grass, 0, 0);

        $bereza = $e->xLoadMesh($this->media('Meshes/bereza2.b3d'));
        $shader = $e->xLoadFXFile($this->media('Shaders/shaderinstancing.fx'));
        $e->xSetEntityEffect($bereza, $shader);
        $e->xSetEffectTechnique($bereza, 'Instancing');
        for ($i = 0; $i < 300; $i++) {
            $copy = $e->xCreateInstance($bereza);
            $x = $this->rnd(0.0, 2000.0);
            $z = $this->rnd(0.0, 2000.0);
            $y = $e->xTerrainY($terrain, $x, 0.0, $z) - 1.0;
            $e->xPositionEntity($copy, $x, $y, $z);
            $e->xRotateEntity($copy, $this->rnd(-3.0, 3.0), $this->rnd(0.0, 90.0), $this->rnd(-3.0, 3.0));
            $e->xScaleEntity($copy, 20, 20, 20);
        }

        $mouseSpeed = 0.5;
        $smoothness = 4.5;
        $mxs = 0.0; $mys = 0.0; $camxa = 0.0; $camya = 0.0;
        $center = fn () => $e->xMoveMouse((int) ($e->xGraphicsWidth() / 2), (int) ($e->xGraphicsHeight() / 2));
        $center();

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, 45, 0, 0);

        $skybox = $e->xLoadMesh($this->media('Meshes/skydome.b3d'));
        $e->xEntityFX($skybox, 1);
        $e->xScaleEntity($skybox, 0.5, 0.5, 0.5);
        $e->xEntityColor($skybox, 255, 255, 255);
        $e->xEntityOrder($skybox, 1);

        $warrior = $e->xLoadAnimMesh($this->media('Meshes/kuznec.b3d'));
        $e->xEntityColor($warrior, 255, 255, 255);
        $wx = 1000.0; $wz = 1000.0;
        $e->xPositionEntity($warrior, $wx, $e->xTerrainY($terrain, $wx, 0.0, $wz), $wz);
        $e->xScaleEntity($warrior, 5, 5, 5);
        $e->xExtractAnimSeq($warrior, 14, 18); $animIdle = 1;
        $e->xExtractAnimSeq($warrior, 20, 59); $animRun  = 2;
        $currAnim = $animIdle; $lastAnim = 0;
        $e->xAnimate($warrior, 2, 0.1, $currAnim);
        $lastMoveZ = 0; $movez = 0;

        $e->xInitShadows(1024, 0, 0);
        $enableShadows = true;
        $e->xEntityCastShadows($terrain, $light, 0);
        $e->xLightEnableShadows($light, 1);
        $e->xSetShadowParams(2, 0.6, 1, 300);
        $e->xLightShadowEpsilons($light, 0.0001, 0.20);

        $koster = $e->xLoadAnimMesh($this->media('Meshes/koster.b3d'));
        $e->xEntityColor($koster, 255, 255, 255);
        $e->xScaleEntity($koster, 0.07, 0.07, 0.07);
        $kx = 1010.0; $kz = 1000.0;
        $e->xPositionEntity($koster, $kx, $e->xTerrainY($terrain, $kx, 0.0, $kz), $kz);
        $flame = $e->xLoadTexture($this->media('Textures/fire.jpg'), 1 + 2);
        $e->xTextureBlend($flame, 5);
        $lastCreated = 0;

        while ($this->running()) {
            $lastAnim = $currAnim;
            $currAnim = $animIdle;
            $lastMoveZ = $movez;
            $movez = 0; $movex = 0;
            if ($e->xKeyDown(Constants::KEY_W)) { $e->xMoveEntity($warrior, 0, 0, 1); $currAnim = $animRun; $movez = 1; }
            if ($e->xKeyDown(Constants::KEY_S)) {
                $movex = ($lastMoveZ === -1) ? 1 : -1;
                $e->xMoveEntity($warrior, 0, 0, 1); $currAnim = $animRun; $movez = -1;
            }

            $e->xTurnEntity($skybox, 0, 0.03, 0);

            if ($e->xMouseDown(2)) {
                $cameraDist = max(10.0, min(100.0, $cameraDist + $e->xMouseYSpeed() * $mouseSpeed));
                $center();
            } else {
                $mxs = $this->curve($e->xMouseXSpeed() * $mouseSpeed, $mxs, $smoothness);
                $mys = $this->curve($e->xMouseYSpeed() * $mouseSpeed, $mys, $smoothness);
                $camxa = fmod($camxa - $mxs, 360.0);
                $camya = max(0.0, min(45.0, $camya + $mys));
                $center();
                $e->xRotateEntity($camera, $camya, $camxa, 0.0);
                $cameraDist = max(10.0, min(100.0, $cameraDist + $e->xMouseZSpeed() * 3));
            }

            $x = $e->xEntityX($warrior);
            $y = $e->xEntityY($warrior);
            $z = $e->xEntityZ($warrior);
            $e->xPositionEntity($warrior, $x, $e->xTerrainY($terrain, $x, $y, $z), $z);
            $e->xPositionEntity($camera, $e->xEntityX($warrior), $e->xEntityY($warrior) + 10, $e->xEntityZ($warrior));
            if ($movez !== 0 || $movex !== 0) {
                $yaw = $e->xEntityYaw($camera) + ($movez === -1 ? 180 : 0);
                $e->xRotateEntity($warrior, 0, $yaw, 0);
            }
            $e->xMoveEntity($camera, 0, 0, -$cameraDist);

            $e->xPositionEntity($skybox, $e->xEntityX($camera), $e->xEntityY($camera), $e->xEntityZ($camera));

            if ($currAnim !== $lastAnim) {
                if ($currAnim === $animRun) {
                    $e->xAnimate($warrior, 1, 1.7, $currAnim, 10);
                } else {
                    $e->xAnimate($warrior, 2, 0.1, $currAnim, 1);
                }
            }

            $now = $this->millis();
            if ($now > $lastCreated) {
                $this->createParticle(
                    $e->xEntityX($koster, 1) + $this->rnd(-0.1, 0.1),
                    $e->xEntityY($koster, 1),
                    $e->xEntityZ($koster, 1) + $this->rnd(-0.1, 0.1),
                    $flame
                );
                $lastCreated = $now + 25;
            }
            $this->updateParticles();

            if ($e->xKeyHit(Constants::KEY_Q)) { $enableShadows = !$enableShadows; }

            $e->xUpdateWorld();
            $e->xRenderWorld(1.0, $enableShadows ? 1 : 0);

            $e->xColor(200, 0, 0);
            $e->xText(10, 10, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xText(10, 30, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 50, 'DIP calls: ' . $e->xDIPCounter());
            $e->xText(10, 70, 'Q - toggle shadows (' . ($enableShadows ? 'enabled' : 'disabled') . ' now)');
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }

    private function curve(float $new, float $old, float $inc): float
    {
        return $inc > 1.0 ? $old - ($old - $new) / $inc : $new;
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
