<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "psystem" sample - a rotating particle emitter.
 */
final class PsystemController extends Controller
{
    public const TITLE = 'Particle system';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Particle System (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $texture = $e->xLoadTexture($this->media('Textures/particle.bmp'), 1 + 2 + 8);

        $psystem = $e->xCreatePSystem(1);
        $e->xPSystemSetTexture($psystem, $texture, 1, 0);
        $e->xPSystemSetParticleLifetime($psystem, 10000);
        $e->xPSystemSetMaxParticles($psystem, 3000);
        $e->xPSystemSetCreationInterval($psystem, 30);
        $e->xPSystemSetCreationFrequency($psystem, 5);
        $e->xPSystemSetVelocity($psystem, -3, -3, -3, 3, 3, 3);
        $e->xPSystemSetParticleSize($psystem, 1, 1, 5, 5);
        $e->xPSystemSetScaleSpeed($psystem, -0.1, -0.1, 1, 1);
        $e->xPSystemSetColors($psystem, 0, 255, 0, 255, 0, 0);
        $e->xPSystemSetColorMode($psystem, 1);

        $emitter = $e->xCreateEmitter($psystem);

        $camera = $e->xCreateCamera();
        $e->xMoveEntity($camera, 0, 0, -50);

        while ($this->running()) {
            $e->xTurnEntity($emitter, 1, 1, 1);

            $e->xUpdateWorld();
            $e->xRenderWorld();

            $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
            $e->xText(10, 30, 'Particles: ' . $e->xEmitterCountParticles($emitter));

            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
