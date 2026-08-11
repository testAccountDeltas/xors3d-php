<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "water" sample - animated reflective/refractive water using a
 * dynamic cube map updated over two frames.
 */
final class WaterController extends Controller
{
    public const TITLE = 'Animated reflective water';

    private int $cubeFrame = 0;

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Water (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xCreateDSS(1024, 1024);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 10, -50);
        $e->xRotateEntity($cam->handle(), 0, 180, 0);
        $e->xCameraClsColor($cam->handle(), 192, 192, 192);

        $cubeMapCamera = $e->xCreateCamera();
        $e->xHideEntity($cubeMapCamera);
        $e->xCameraClsMode($cubeMapCamera, 0, 1);
        $e->xCameraZoom($cubeMapCamera, 0);

        $e->xAntiAlias(1);

        $water = $e->xLoadMesh($this->media('Meshes/water.b3d'));
        $e->xPositionEntity($water, 0, -5, -200);
        $e->xLoadMesh($this->media('Meshes/level.b3d'));

        $light = $e->xCreateLight();
        $e->xRotateEntity($light, -45, 0, 0);

        $waterFX = $e->xLoadFXFile($this->media('Shaders/water.fx'));
        $texEnv = $e->xCreateTexture(512, 512, 128 + 48);
        $noise  = $e->xLoadTexture($this->media('Textures/noise.dds'), 1 + 512);

        $e->xSetEntityEffect($water, $waterFX);
        $e->xSetEffectTechnique($water, 'Water');
        $e->xSetEffectMatrixSemantic($water, 'world_matrix', Constants::WORLD);
        $e->xSetEffectMatrixSemantic($water, 'view_proj_matrix', Constants::VIEWPROJ);
        $e->xSetEffectTexture($water, 'Noise_Tex', $noise);
        $e->xSetEffectTexture($water, 'envBox_Tex', $texEnv);

        $startTime = $this->millis();
        $e->xAmbientLight(150, 150, 150);
        $e->xEntityAlpha($water, 0.9);

        while ($this->running()) {
            $cam->update();

            if ($e->xEntityInView($water, $cam->handle())) {
                $this->updateCubemap($texEnv, $cubeMapCamera, $water, $cam->handle());
            }

            $e->xSetEffectFloat($water, 'time_0_X', ($this->millis() - $startTime) / 10000.0);
            $e->xSetEffectFloat($water, 'freq', $this->millis() / 1000.0);
            $e->xSetEffectVector($water, 'view_position',
                $e->xEntityX($cam->handle(), 1), 2, $e->xEntityZ($cam->handle(), 1));

            $e->xRenderWorld();
            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'TrisRendered: ' . $e->xTrisRendered());
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }

    /** Renders three cube faces per call, alternating sets each frame. */
    private function updateCubemap(int $texture, int $camera, int $entity, int $viewCamera): void
    {
        $e = $this->engine;
        $e->xHideEntity($viewCamera);
        $size = $e->xTextureWidth($texture);
        $e->xShowEntity($camera);
        $e->xHideEntity($entity);
        $e->xPositionEntity($camera,
            $e->xEntityX($viewCamera, 1), $e->xEntityY($entity, 1) + 2, $e->xEntityZ($viewCamera, 1));

        $this->cubeFrame = 1 - $this->cubeFrame;
        $faces = $this->cubeFrame
            ? [[0, [0, 90, 0]], [1, [0, 0, 0]], [2, [0, -90, 0]]]
            : [[3, [0, 180, 0]], [4, [-90, 0, 0]], [5, [90, 0, 0]]];

        foreach ($faces as [$face, [$pitch, $yaw, $roll]]) {
            $e->xSetCubeFace($texture, $face);
            $e->xSetBuffer($e->xTextureBuffer($texture));
            $e->xCameraViewport($camera, 0, 0, $size, $size);
            $e->xRotateEntity($camera, $pitch, $yaw, $roll);
            $e->xRenderWorld();
        }

        $e->xShowEntity($entity);
        $e->xHideEntity($camera);
        $e->xSetBuffer($e->xBackBuffer());
        $e->xShowEntity($viewCamera);
    }
}
