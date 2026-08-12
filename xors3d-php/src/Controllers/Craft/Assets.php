<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * Asset setup for the Craft voxel game: synthesized sounds, textured block
 * templates + per-type brushes, and the held "hand" block. Mixed into
 * MinecraftController.
 */
trait Assets
{
    // =================================================================== sound

    private function loadSounds(Engine $e): void
    {
        $dir = dirname(__DIR__, 3) . '/assets/sounds/';
        if (is_file($dir . 'break.wav'))   { $this->sndBreak   = $e->xLoadSound($dir . 'break.wav'); }
        if (is_file($dir . 'place.wav'))   { $this->sndPlace   = $e->xLoadSound($dir . 'place.wav'); }
        if (is_file($dir . 'step.wav'))    { $this->sndStep    = $e->xLoadSound($dir . 'step.wav'); }
        if (is_file($dir . 'ambient.wav')) {
            $this->sndAmbient = $e->xLoadSound($dir . 'ambient.wav');
            if ($this->sndAmbient !== 0) {
                $e->xLoopSound($this->sndAmbient);
                $this->ambCh = $e->xPlaySound($this->sndAmbient);
            }
        }
    }

    private function play(int $sound): void
    {
        $vol = (float) $this->settings['volume'];
        if ($sound === 0 || $vol <= 0.0) {
            return;
        }
        $this->e->xSoundVolume($sound, $vol);
        $this->e->xPlaySound($sound);
    }

    // =================================================================== setup

    private function buildTemplates(Engine $e): void
    {
        $base = dirname(__DIR__, 3) . '/assets/blocks/';
        foreach (self::TYPES as $id => [$name, $file]) {
            $cube = $e->xCreateCube();
            if ($id === 1) {
                $w = $e->xMeshWidth($cube);
                $this->scale = $w > 0.0 ? self::BLOCK / $w : 1.0;
            }
            $e->xScaleEntity($cube, $this->scale, $this->scale, $this->scale);
            // glass loads as a MASKED texture: fully-transparent texels are discarded so
            // you see straight through the pane, the frame stays solid (crisp windows).
            $texture = ($id === 10 || $id === self::DOOR)
                ? $e->xLoadTexture($base . $file, 1 + 4 + 8)   // color + masked + mipmap (glass/door)
                : $e->xLoadTexture($base . $file);
            $this->tex[$id] = $texture;
            $e->xEntityTexture($cube, $texture);
            if ($id === 11) { $e->xEntityFX($cube, 1); } // glowstone: fullbright
            $e->xHideEntity($cube);
            $this->template[$id] = $cube;

            // brush per type for the merged chunk-mesh surfaces
            $b = $e->xCreateBrush();
            $e->xBrushTexture($b, $texture);
            $this->brush[$id] = $b;
        }

        // animated translucent water
        $this->waterTex = $e->xLoadAnimTexture($base . 'water.png', 1, 16, 16, 0, 32);
        $this->waterTpl = $e->xCreateCube();
        $e->xScaleEntity($this->waterTpl, $this->scale, $this->scale, $this->scale);
        $e->xEntityColor($this->waterTpl, 120, 160, 255);
        $e->xEntityAlpha($this->waterTpl, 0.7);
        $e->xEntityTexture($this->waterTpl, $this->waterTex);
        $e->xHideEntity($this->waterTpl);
    }

    private function createHand(Engine $e, int $camera): void
    {
        $this->hand = $e->xCreateCube();
        $s = $this->scale * 0.22;
        $e->xScaleEntity($this->hand, $s, $s, $s);
        $e->xEntityParent($this->hand, $camera);
        $e->xEntityFX($this->hand, 1);
        $e->xPositionEntity($this->hand, 0.95, -0.75, 2.6, 0);
        $e->xRotateEntity($this->hand, 15, 35, 0, 0);
        $this->refreshHand($e);
    }

    private function refreshHand(Engine $e): void
    {
        if ($this->hand !== 0) {
            $e->xEntityTexture($this->hand, $this->tex[$this->selectedType()]);
        }
    }

}
