<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;
use Xors3D\Scene\MouseLookCamera;

/**
 * Port of the "bump" sample - normal-mapped cube lit by an orbiting light.
 */
final class BumpController extends Controller
{
    public const TITLE = 'Normal (bump) mapping';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Bump-mapping sample (PHP)');
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xHidePointer();
        $e->xAntiAlias(1);

        $cam = new MouseLookCamera($e);
        $e->xPositionEntity($cam->handle(), 0, 0, -25);

        $cube = $e->xCreateCube();
        $e->xScaleEntity($cube, 5, 5, 5);
        $e->xEntityShininess($cube, 1.0);
        $e->xUpdateNormals($cube);

        $diffuse = $e->xLoadTexture($this->media('Textures/blue_marble.jpg'));
        $normal  = $e->xLoadTexture($this->media('Textures/blue_marble_norm.jpg'));
        $e->xEntityTexture($cube, $diffuse, 0, 0); // layer 0 - diffuse
        $e->xEntityTexture($cube, $normal,  0, 1); // layer 1 - normal map

        $pivot = $e->xCreatePivot();
        $light = $e->xCreateLight(2);
        $e->xEntityParent($light, $pivot);
        $e->xPositionEntity($light, 0, 0, -10);
        $sphere = $e->xCreateSphere(12, $light);
        $e->xScaleEntity($sphere, 0.1, 0.1, 0.1);

        $bump = $e->xLoadFXFile($this->media('Shaders/bump.fx'));
        $e->xSetEntityEffect($cube, $bump);
        $e->xSetEffectTechnique($cube, 'Bump');

        while ($this->running()) {
            $cam->update();

            $e->xTurnEntity($pivot, 0, 1, 0);
            $e->xSetEffectVector($cube, 'cameraPosition',
                $e->xEntityX($cam->handle()), $e->xEntityY($cam->handle()), $e->xEntityZ($cam->handle()));

            $e->xRenderWorld();
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
