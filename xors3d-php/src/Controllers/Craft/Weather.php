<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * Dynamic weather for the Craft voxel game: a billboard precipitation pool
 * (rain streaks / snow flakes) that follows the player, an overcast/wetness
 * state machine, snow settling and rain puddles. Mixed into MinecraftController.
 */
trait Weather
{
    /** Build the reusable precipitation particle pool (rain streaks / snow flakes). */
    private function createWeather(Engine $e, string $sky, int $fxSky): void
    {
        $this->rainTex = $e->xLoadTexture($sky . 'rain.png', 1 + 2 + 8);
        $this->snowTex = $e->xLoadTexture($sky . 'snow.png', 1 + 2 + 8);

        for ($i = 0; $i < 320; $i++) {
            $sp = $e->xCreateSprite();
            $e->xEntityTexture($sp, $this->rainTex);
            $e->xEntityFX($sp, $fxSky); // fullbright + fog-immune so it reads at any distance
            $e->xHideEntity($sp);
            $this->drops[] = ['sp' => $sp, 'x' => 0.0, 'y' => 0.0, 'z' => 0.0, 'vy' => 0.0, 'sway' => 0.0];
        }

        // rain puddles: thin, near-flat water slabs that collect on flat ground
        $this->puddleTpl = $e->xCreateCube();
        $e->xScaleEntity($this->puddleTpl, $this->scale * 0.5, $this->scale * 0.04, $this->scale * 0.5);
        $e->xEntityColor($this->puddleTpl, 90, 130, 200);
        $e->xEntityAlpha($this->puddleTpl, 0.0);
        $e->xEntityTexture($this->puddleTpl, $this->waterTex);
        $e->xHideEntity($this->puddleTpl);
        for ($i = 0; $i < 48; $i++) {
            $pd = $e->xCopyEntity($this->puddleTpl);
            $e->xHideEntity($pd);
            $this->puddles[] = ['ent' => $pd, 'x' => 0.0, 'z' => 0.0, 'placed' => 0];
        }

        $this->weatherTimer = 600.0; // first roll after ~10 s
    }

    /**
     * Weather state machine + particle update. Rolls clear/rain/snow every ~30-70 s;
     * snow only where it is cold (snow biome / high ground), rain elsewhere. Particles
     * fall in a box that follows the player and respawn at the top when they land.
     */
    private function updateWeather(): void
    {
        $e = $this->e; $B = self::BLOCK; $dt = $this->dt;

        if (!(int) ($this->settings['weather'] ?? 1)) {
            if ($this->weather !== 0) { $this->setWeather(0); }
            return;
        }

        // debug/testing: CRAFT_WEATHER=0|1|2 forces clear/rain/snow (skips the roll)
        $force = getenv('CRAFT_WEATHER');
        if ($force !== false) {
            $fw = (int) $force;
            if ($this->weather !== $fw) { $this->setWeather($fw); }
            $this->weatherTimer = 1e9;
            if ($fw === 2) { $this->snowBuild = 420.0; } // settle snow immediately for testing
        }

        // roll new weather periodically
        $this->weatherTimer -= $dt;
        if ($this->weatherTimer <= 0.0) {
            $this->weatherTimer = mt_rand(1800, 4200); // ~30-70 s at 60 FPS
            $roll = mt_rand(0, 99);
            if ($roll < 55) {
                $this->setWeather(0);                    // mostly clear
            } else {
                $cold = $this->coldAt($this->px, $this->pz);
                $this->setWeather($cold ? 2 : 1);
            }
        }

        // ease overcast darkening in/out
        $target = $this->weather === 0 ? 0.0 : ($this->weather === 1 ? 0.55 : 0.35);
        $this->wetness += ($target - $this->wetness) * min(1.0, 0.03 * $dt);

        // snow settles on the ground after a while of snowfall, then melts once it stops
        if ($this->weather === 2) {
            $this->snowBuild = min(420.0, $this->snowBuild + $dt);
            if (!$this->snowOn && $this->snowBuild >= 300.0) { $this->snowOn = true; $this->remeshLoaded(); }
        } else {
            $this->snowBuild = max(0.0, $this->snowBuild - $dt * 0.5); // melt slower than it falls
            if ($this->snowOn && $this->snowBuild <= 0.0) { $this->snowOn = false; $this->remeshLoaded(); }
        }

        if ($this->weather === 0) { return; }

        $snow  = $this->weather === 2;
        $range = 26.0 * $B;                 // half-box around the player
        $top   = $this->py + 22.0 * $B;
        $floor = $this->py - 6.0 * $B;
        $fall  = ($snow ? 0.35 : 1.5) * $B; // world units per 60-FPS frame

        foreach ($this->drops as &$p) {
            $p['y'] -= $fall * $dt * (0.85 + $p['sway'] * 0.3);
            if ($snow) { $p['x'] += sin(($p['y'] + $p['sway'] * 50) * 0.05) * 0.12 * $B * $dt; }
            // respawn when it lands: below the box floor OR on hitting a solid block, so
            // rain/snow settles on roofs & ground instead of passing through into buildings.
            $hit = $p['y'] < $floor
                || $this->solidType($this->cellOf($p['x']), $this->cellOf($p['y']), $this->cellOf($p['z'])) > 0;
            if ($hit) { // respawn at the top over a fresh column
                $p['x'] = $this->px + (mt_rand(-1000, 1000) / 1000.0) * $range;
                $p['z'] = $this->pz + (mt_rand(-1000, 1000) / 1000.0) * $range;
                $p['y'] = $top - (mt_rand(0, 1000) / 1000.0) * 4.0 * $B;
                $p['sway'] = mt_rand(0, 100) / 100.0;
                $e->xHideEntity($p['sp']);      // avoid a 1-frame streak inside the block
                continue;
            }
            $e->xShowEntity($p['sp']);
            $e->xPositionEntity($p['sp'], $p['x'], $p['y'], $p['z']);
        }
        unset($p);
    }

    /**
     * Rain puddles: keep a pool of thin water slabs on flat exposed ground around the
     * player, fading their alpha with how wet it is. Water only collects while raining.
     */
    private function updatePuddles(): void
    {
        $e = $this->e; $B = self::BLOCK;
        $raining = ($this->weather === 1) && (int) ($this->settings['weather'] ?? 1);
        $alpha = $raining ? min(0.5, $this->wetness * 0.9) : 0.0;

        // don't place/draw puddles when flying below the surface (under the map)
        $surfaceY = $this->groundTop($this->cellOf($this->px), $this->cellOf($this->pz)) * $B + $B / 2;
        $underMap = $this->py < $surfaceY - 4.0 * $B;

        if (!$raining || $underMap) {
            foreach ($this->puddles as &$p) {
                if ($p['placed']) { $e->xHideEntity($p['ent']); $p['placed'] = 0; }
            }
            unset($p);
            return;
        }

        $radius = 22.0 * $B;
        foreach ($this->puddles as &$p) {
            if (!$p['placed']
                || abs($p['x'] - $this->px) > $radius || abs($p['z'] - $this->pz) > $radius) {
                for ($t = 0; $t < 6; $t++) {
                    $bx = $this->cellOf($this->px + (mt_rand(-1000, 1000) / 1000.0) * $radius);
                    $bz = $this->cellOf($this->pz + (mt_rand(-1000, 1000) / 1000.0) * $radius);
                    if ($this->heightAt($bx, $bz) < self::SEA) { continue; } // not in the sea
                    $top = $this->groundTop($bx, $bz);
                    // settle on a roughly-flat patch (allow one differing neighbour)
                    $flat = 0;
                    $flat += (int) ($this->groundTop($bx + 1, $bz) === $top);
                    $flat += (int) ($this->groundTop($bx - 1, $bz) === $top);
                    $flat += (int) ($this->groundTop($bx, $bz + 1) === $top);
                    $flat += (int) ($this->groundTop($bx, $bz - 1) === $top);
                    if ($flat < 3) { continue; }
                    $p['x'] = $bx * $B; $p['z'] = $bz * $B; $p['placed'] = 1;
                    $e->xPositionEntity($p['ent'], $p['x'], $top * $B + $B * 0.5 + 0.04, $p['z']);
                    $e->xShowEntity($p['ent']);
                    break;
                }
            }
            if ($p['placed']) { $e->xEntityAlpha($p['ent'], $alpha); }
        }
        unset($p);
    }

    /** True where precipitation should fall as snow (cold biome / snowy heights). */
    private function coldAt(float $wx, float $wz): bool
    {
        $bx = $this->cellOf($wx); $bz = $this->cellOf($wz);
        return $this->heightAt($bx, $bz) >= self::SNOW || $this->biomeVal($bx, $bz) >= 0.80;
    }

    /** Switch the active weather: swap the particle texture, size and (dis)appear. */
    private function setWeather(int $w): void
    {
        $e = $this->e; $B = self::BLOCK;
        $this->weather = $w;
        if ($w === 0) {
            foreach ($this->drops as $p) { $e->xHideEntity($p['sp']); }
            return;
        }
        $snow = $w === 2;
        $tex  = $snow ? $this->snowTex : $this->rainTex;
        foreach ($this->drops as &$p) {
            $e->xEntityTexture($p['sp'], $tex);
            if ($snow) {
                $e->xScaleSprite($p['sp'], 0.22 * $B, 0.22 * $B);
                $e->xEntityAlpha($p['sp'], 0.85);
                $e->xEntityColor($p['sp'], 255, 255, 255);
            } else {
                $e->xScaleSprite($p['sp'], 0.06 * $B, 1.1 * $B); // tall thin streak
                $e->xEntityAlpha($p['sp'], 0.5);
                $e->xEntityColor($p['sp'], 190, 210, 245);
            }
            // seed a starting position so the first frame isn't a clump at origin
            $p['x'] = $this->px + (mt_rand(-1000, 1000) / 1000.0) * 26.0 * $B;
            $p['z'] = $this->pz + (mt_rand(-1000, 1000) / 1000.0) * 26.0 * $B;
            $p['y'] = $this->py + (mt_rand(-600, 2200) / 100.0) * $B;
            $p['sway'] = mt_rand(0, 100) / 100.0;
            $e->xShowEntity($p['sp']);
        }
        unset($p);
    }
}
