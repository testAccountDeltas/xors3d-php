<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;
use Xors3D\Ffi\Engine;

/**
 * Visual effects for the Craft voxel game: block-break particles, dynamic
 * point-lights following the nearest torches, and the bloom / god-rays
 * post-processing shaders. Mixed into MinecraftController.
 */
trait Effects
{
    /** Spawn a small burst of textured cube shards when a block is broken. */
    private function spawnBreakParticles(int $x, int $y, int $z, int $type): void
    {
        $e = $this->e; $B = self::BLOCK;
        $tex = $this->tex[$type] ?? 0;
        if ($tex === 0) { return; }
        $cx = $x * $B; $cy = $y * $B; $cz = $z * $B;
        for ($i = 0; $i < 7; $i++) {
            $c = $e->xCreateCube();
            $s = $this->scale * (0.12 + mt_rand(0, 8) / 100.0);
            $e->xScaleEntity($c, $s, $s, $s);
            $e->xEntityTexture($c, $tex);
            $ox = (mt_rand(-40, 40) / 100.0) * $B; $oy = (mt_rand(-30, 40) / 100.0) * $B; $oz = (mt_rand(-40, 40) / 100.0) * $B;
            $e->xPositionEntity($c, $cx + $ox, $cy + $oy, $cz + $oz);
            $this->particles[] = [
                'ent' => $c, 'x' => $cx + $ox, 'y' => $cy + $oy, 'z' => $cz + $oz,
                'vx' => (mt_rand(-15, 15) / 100.0) * $B, 'vy' => (mt_rand(15, 38) / 100.0) * $B,
                'vz' => (mt_rand(-15, 15) / 100.0) * $B, 'life' => mt_rand(18, 30),
            ];
        }
        // cap the pool: drop the oldest bursts if it grows too large
        while (count($this->particles) > 140) {
            $p = array_shift($this->particles);
            $e->xFreeEntity($p['ent']);
        }
    }

    /** Advance and expire block-break particles (gravity + fade to removal). */
    private function updateParticles(): void
    {
        if ($this->particles === []) { return; }
        $e = $this->e; $dt = $this->dt;
        foreach ($this->particles as $i => &$p) {
            $p['vy'] -= self::G * 0.6 * $dt;
            $p['x'] += $p['vx'] * $dt; $p['y'] += $p['vy'] * $dt; $p['z'] += $p['vz'] * $dt;
            $p['life'] -= $dt;
            if ($p['life'] <= 0) { $e->xFreeEntity($p['ent']); unset($this->particles[$i]); continue; }
            $e->xPositionEntity($p['ent'], $p['x'], $p['y'], $p['z']);
        }
        unset($p);
    }

    /**
     * Reassign the point-light pool to the nearest torches/glowstone around the player.
     * Intensity fades smoothly with distance (and the light range grows) instead of
     * cutting off, so lights don't blink out when you walk away.
     */
    private function updatePointLights(): void
    {
        if ($this->pointLights === []) { return; }
        $e = $this->e; $B = self::BLOCK;
        $reach = 60.0 * $B; $reach2 = $reach * $reach;   // wider reach than before
        $px = $this->px; $py = $this->py; $pz = $this->pz;
        $near = [];
        foreach ($this->lightCells as [$x, $y, $z]) {
            $wx = $x * $B; $wy = $y * $B; $wz = $z * $B;
            $dx = $wx - $px; $dy = $wy - $py; $dz = $wz - $pz;
            $d2 = $dx * $dx + $dy * $dy + $dz * $dz;
            if ($d2 < $reach2) { $near[] = [$d2, $wx, $wy, $wz]; }
        }
        sort($near); // nearest first (by squared distance)
        foreach ($this->pointLights as $i => $l) {
            if (isset($near[$i])) {
                [$d2, $wx, $wy, $wz] = $near[$i];
                $f = max(0.0, 1.0 - sqrt($d2) / $reach);   // 1 near -> 0 at the edge
                $f = $f * $f;                              // ease-out for a soft falloff
                $e->xLightColor($l, (int) (255 * $f), (int) (205 * $f), (int) (130 * $f));
                $e->xLightRange($l, (14.0 + 8.0 * (1.0 - $f)) * $B); // reaches a bit farther as it dims
                $e->xPositionEntity($l, $wx, $wy + $B * 0.3, $wz);
                $e->xShowEntity($l);
            } else {
                $e->xHideEntity($l);
            }
        }
    }


    private function setupBloom(Engine $e): void
    {
        $fx = $this->config->media('Shaders/Bloom.fx');
        if (!is_file($fx)) { $this->bloomOK = false; return; }
        $this->bloomFX = $e->xLoadFXFile($fx);
        if (!$e->xValidateEffectTechnique($this->bloomFX, 'Diffuse')) {
            $this->bloomOK = false;   // GPU can't run it -> silently skip
            return;
        }
        $w = (int) $this->settings['width'];
        $h = (int) $this->settings['height'];
        $this->bloomPoly = $e->xCreatePostEffectPoly($this->camH, 1);
        $this->bloomTexS = $e->xCreateTexture(256, 256);
        $this->bloomTexF = $e->xCreateTexture($w, $h);
        $e->xSetEntityEffect($this->bloomPoly, $this->bloomFX);
        $e->xSetEffectTechnique($this->bloomPoly, 'Diffuse');
        $e->xSetEffectMatrixSemantic($this->bloomPoly, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectTexture($this->bloomPoly, 'tDiffuse', $this->bloomTexS);
        $e->xSetEffectTexture($this->bloomPoly, 'tEmissive', $this->bloomTexF);
        $this->bloomOK = true;
    }

    /** Bright-pass + separable blur bloom, run as a post effect over the frame. */
    private function renderBloom(): void
    {
        if (!$this->bloomOK || !(int) $this->settings['bloom']) { return; }
        $e = $this->e;
        $w = (int) $this->settings['width'];
        $h = (int) $this->settings['height'];
        $e->xStretchBackBuffer($this->bloomTexS, 0, 0, 256, 256, 0);
        $e->xStretchBackBuffer($this->bloomTexF, 0, 0, $w, $h, 0);
        $e->xSetEffectTechnique($this->bloomPoly, 'Diffuse');  $e->xRenderPostEffect($this->bloomPoly);
        $e->xStretchBackBuffer($this->bloomTexS, 0, 0, 256, 256, 0);
        $e->xSetEffectTechnique($this->bloomPoly, 'DiffuseH'); $e->xRenderPostEffect($this->bloomPoly);
        $e->xStretchBackBuffer($this->bloomTexS, 0, 0, 256, 256, 0);
        $e->xSetEffectTechnique($this->bloomPoly, 'DiffuseV'); $e->xRenderPostEffect($this->bloomPoly);
    }

    // ================================================================ god rays

    private function setupGodRays(Engine $e): void
    {
        $fx = dirname(__DIR__, 3) . '/assets/shaders/GodRays.fx';
        if (!is_file($fx)) { $this->godOK = false; return; }
        $this->godFX = $e->xLoadFXFile($fx);
        if (!$e->xValidateEffectTechnique($this->godFX, 'Rays')) {
            $this->godOK = false;   // GPU/shader model unsupported -> skip
            return;
        }
        $w = (int) $this->settings['width'];
        $h = (int) $this->settings['height'];
        $this->godPoly = $e->xCreatePostEffectPoly($this->camH, 1);
        $this->godTex  = $e->xCreateTexture($w, $h);
        $e->xSetEntityEffect($this->godPoly, $this->godFX);
        $e->xSetEffectTechnique($this->godPoly, 'Rays');
        $e->xSetEffectMatrixSemantic($this->godPoly, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectTexture($this->godPoly, 'tScene', $this->godTex);
        $e->xSetEffectFloat($this->godPoly, 'Density', 0.88);
        $e->xSetEffectFloat($this->godPoly, 'Decay', 0.965);
        $e->xSetEffectFloat($this->godPoly, 'Weight', 0.45);
        $e->xSetEffectFloat($this->godPoly, 'Threshold', 0.8);
        $this->godOK = true;
    }

    /** Radial light shafts from the sun, when it is on screen. */
    private function renderGodRays(): void
    {
        if (!$this->godOK || !(int) $this->settings['godrays'] || $this->dayF <= 0.05) {
            return;
        }
        $e = $this->e;
        $w = (int) $this->settings['width'];
        $h = (int) $this->settings['height'];

        // is the sun in front of the camera?
        $sx = $e->xEntityX($this->sunDisc, 1);
        $sy = $e->xEntityY($this->sunDisc, 1);
        $sz = $e->xEntityZ($this->sunDisc, 1);
        $e->xTFormVector(0, 0, 1, $this->camH, 0);
        $fwx = $e->xTFormedX(); $fwy = $e->xTFormedY(); $fwz = $e->xTFormedZ();
        $tx = $sx - $e->xEntityX($this->camH, 1);
        $ty = $sy - $e->xEntityY($this->camH, 1);
        $tz = $sz - $e->xEntityZ($this->camH, 1);
        if ($fwx * $tx + $fwy * $ty + $fwz * $tz <= 0.0) { return; } // sun behind camera

        $e->xCameraProject($this->camH, $sx, $sy, $sz);
        $u = $e->xProjectedX() / $w;
        $v = $e->xProjectedY() / $h;
        if ($u < -0.6 || $u > 1.6 || $v < -0.6 || $v > 1.6) { return; } // far off-screen

        $e->xSetEffectVector($this->godPoly, 'SunUV', $u, $v, 0, 0);
        $e->xSetEffectVector($this->godPoly, 'RayColor', 1.0, 0.92, 0.65, 0);

        $e->xStretchBackBuffer($this->godTex, 0, 0, $w, $h, 0);
        $e->xSetEffectTechnique($this->godPoly, 'Rays');
        $e->xRenderPostEffect($this->godPoly);
    }
}
