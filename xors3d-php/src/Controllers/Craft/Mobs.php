<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * Passive animals for the Craft voxel game: cube-built species (sheep/pig/cow/
 * chicken/rabbit), spawning/streaming around the player and simple wander AI.
 * Also holds the shared world-query helpers (terrainTopY / isWaterAt / groundTop).
 * Mixed into MinecraftController so it shares $this->mobs, engine handle, etc.
 */
trait Mobs
{
    private function loadMobTextures(Engine $e): void
    {
        $d = dirname(__DIR__, 3) . '/assets/mobs/';
        $this->mobTex['wool'] = $e->xLoadTexture($d . 'wool.png');
        $this->mobTex['leg']  = $e->xLoadTexture($d . 'leg.png');
        $this->mobTex['face'] = $e->xLoadTexture($d . 'face.png');
    }

    private function terrainTopY(float $wx, float $wz): float
    {
        $bx = $this->cellOf($wx); $bz = $this->cellOf($wz);
        $h = $this->heightAt($bx, $bz);
        return $h * self::BLOCK + self::BLOCK / 2;
    }

    private function isWaterAt(float $wx, float $wz): bool
    {
        $bx = $this->cellOf($wx); $bz = $this->cellOf($wz);
        return $this->heightAt($bx, $bz) < self::SEA;
    }

    /** Spawn one animal near the player (on suitable ground), returns success. */
    private function spawnMobNear(): bool
    {
        $B = self::BLOCK;
        $reach = (int) $this->settings['renderDist'] * $B;
        for ($tries = 0; $tries < 12; $tries++) {
            $a = mt_rand(0, 359) * M_PI / 180.0;
            $dist = $reach * (0.45 + mt_rand(0, 40) / 100.0); // 0.45..0.85 of render dist
            $wx = $this->px + cos($a) * $dist;
            $wz = $this->pz + sin($a) * $dist;
            $bx = $this->cellOf($wx); $bz = $this->cellOf($wz);
            $gt = $this->groundTop($bx, $bz);
            if ($this->isWaterAt($wx, $wz) || $this->solidType($bx, $gt + 1, $bz) > 0) { continue; }
            $species = ['sheep', 'pig', 'cow', 'chicken', 'rabbit', 'horse', 'llama'][mt_rand(0, 6)];
            $this->mobs[] = $this->buildMob($species, $wx, $wz);
            return true;
        }
        return false;
    }

    /** Keep ~cap animals alive around the player: despawn far ones, spawn new ahead. */
    private function streamMobs(): void
    {
        $B = self::BLOCK;
        $cap = (int) $this->settings['mobs'];
        $far = (int) $this->settings['renderDist'] * $B + 20 * $B;

        foreach ($this->mobs as $i => $m) {
            if (abs($m['x'] - $this->px) > $far || abs($m['z'] - $this->pz) > $far) {
                foreach ($m['parts'] as $p) { $this->e->xFreeEntity($p); }
                $this->e->xFreeEntity($m['pivot']);
                unset($this->mobs[$i]);
            }
        }
        if (--$this->mobTimer <= 0) {
            $this->mobTimer = mt_rand(50, 130);
            if (count($this->mobs) < $cap) { $this->spawnMobNear(); }
        }
    }

    /**
     * Passive animals, built from tinted cubes (no combat). Each part is
     * [w, h, d, [r,g,b], ox, oy, oz] with sizes in block fractions and offsets in blocks.
     * @return array<string,array{speed:float,parts:array<int,array>}>
     */
    private function mobDefs(): array
    {
        return [
            'sheep' => ['speed' => 0.05, 'parts' => [
                [1.10, 0.85, 0.75, [235, 235, 230], 0.00, 0.85, 0.00],  // wool body
                [0.55, 0.55, 0.55, [235, 235, 230], 0.00, 1.05, 0.62],  // head
                [0.35, 0.35, 0.15, [225, 175, 175], 0.00, 1.00, 0.90],  // muzzle
                [0.20, 0.55, 0.20, [60, 50, 45], -0.35, 0.28, -0.28],
                [0.20, 0.55, 0.20, [60, 50, 45],  0.35, 0.28, -0.28],
                [0.20, 0.55, 0.20, [60, 50, 45], -0.35, 0.28,  0.28],
                [0.20, 0.55, 0.20, [60, 50, 45],  0.35, 0.28,  0.28],
            ]],
            'pig' => ['speed' => 0.06, 'parts' => [
                [1.00, 0.70, 0.72, [240, 150, 160], 0.00, 0.65, 0.00],  // body
                [0.55, 0.55, 0.50, [240, 150, 160], 0.00, 0.75, 0.55],  // head
                [0.30, 0.24, 0.12, [220, 120, 140], 0.00, 0.70, 0.80],  // snout
                [0.20, 0.35, 0.20, [235, 140, 150], -0.30, 0.18, -0.25],
                [0.20, 0.35, 0.20, [235, 140, 150],  0.30, 0.18, -0.25],
                [0.20, 0.35, 0.20, [235, 140, 150], -0.30, 0.18,  0.25],
                [0.20, 0.35, 0.20, [235, 140, 150],  0.30, 0.18,  0.25],
            ]],
            'cow' => ['speed' => 0.04, 'parts' => [
                [1.25, 0.85, 0.80, [110, 75, 50], 0.00, 0.90, 0.00],    // brown body
                [0.60, 0.42, 0.42, [235, 235, 230], 0.20, 1.05, 0.10],  // white patch
                [0.55, 0.55, 0.50, [95, 65, 45], 0.00, 1.05, 0.68],     // head
                [0.42, 0.30, 0.12, [210, 170, 160], 0.00, 1.00, 0.94],  // muzzle
                [0.14, 0.18, 0.14, [225, 220, 210], -0.22, 1.28, 0.68], // horn
                [0.14, 0.18, 0.14, [225, 220, 210],  0.22, 1.28, 0.68], // horn
                [0.22, 0.60, 0.22, [55, 45, 35], -0.38, 0.30, -0.30],
                [0.22, 0.60, 0.22, [55, 45, 35],  0.38, 0.30, -0.30],
                [0.22, 0.60, 0.22, [55, 45, 35], -0.38, 0.30,  0.30],
                [0.22, 0.60, 0.22, [55, 45, 35],  0.38, 0.30,  0.30],
            ]],
            'chicken' => ['speed' => 0.055, 'parts' => [
                [0.50, 0.50, 0.45, [245, 245, 245], 0.00, 0.50, 0.00],  // body
                [0.30, 0.30, 0.30, [245, 245, 245], 0.00, 0.74, 0.26],  // head
                [0.14, 0.12, 0.16, [240, 200, 60], 0.00, 0.72, 0.44],   // beak
                [0.12, 0.16, 0.10, [220, 60, 60], 0.00, 0.90, 0.24],    // comb
                [0.10, 0.30, 0.10, [235, 180, 40], -0.14, 0.15, 0.00],  // legs
                [0.10, 0.30, 0.10, [235, 180, 40],  0.14, 0.15, 0.00],
            ]],
            'rabbit' => ['speed' => 0.07, 'parts' => [
                [0.45, 0.40, 0.55, [180, 150, 120], 0.00, 0.40, 0.00],  // body
                [0.35, 0.35, 0.35, [185, 155, 125], 0.00, 0.55, 0.36],  // head
                [0.10, 0.35, 0.08, [185, 155, 125], -0.10, 0.85, 0.36], // ear
                [0.10, 0.35, 0.08, [185, 155, 125],  0.10, 0.85, 0.36], // ear
                [0.12, 0.20, 0.12, [175, 145, 115], -0.14, 0.12, -0.15],
                [0.12, 0.20, 0.12, [175, 145, 115],  0.14, 0.12, -0.15],
                [0.14, 0.14, 0.24, [175, 145, 115], -0.14, 0.14,  0.18],
                [0.14, 0.14, 0.24, [175, 145, 115],  0.14, 0.14,  0.18],
            ]],
            'horse' => ['speed' => 0.085, 'parts' => [
                [1.45, 1.00, 0.85, [120, 80, 45], 0.00, 1.15, 0.00],    // body
                [0.45, 0.45, 0.85, [120, 80, 45], 0.00, 1.55, 0.72],    // neck
                [0.45, 0.55, 0.40, [110, 72, 40], 0.00, 1.85, 1.05],    // head
                [0.15, 0.55, 0.55, [70, 45, 25], 0.00, 1.75, 0.55],     // mane
                [0.28, 1.10, 0.28, [95, 62, 35], -0.45, 0.55, -0.45],
                [0.28, 1.10, 0.28, [95, 62, 35],  0.45, 0.55, -0.45],
                [0.28, 1.10, 0.28, [95, 62, 35], -0.45, 0.55,  0.45],
                [0.28, 1.10, 0.28, [95, 62, 35],  0.45, 0.55,  0.45],
            ]],
            'llama' => ['speed' => 0.06, 'parts' => [
                [0.95, 1.00, 0.80, [225, 215, 190], 0.00, 1.05, 0.00],  // woolly body
                [0.42, 1.05, 0.42, [225, 215, 190], 0.00, 1.75, 0.55],  // tall neck
                [0.45, 0.50, 0.55, [215, 205, 180], 0.00, 2.20, 0.70],  // head
                [0.10, 0.28, 0.08, [215, 205, 180], -0.14, 2.55, 0.70], // ear
                [0.10, 0.28, 0.08, [215, 205, 180],  0.14, 2.55, 0.70], // ear
                [0.24, 1.05, 0.24, [205, 195, 170], -0.35, 0.55, -0.30],
                [0.24, 1.05, 0.24, [205, 195, 170],  0.35, 0.55, -0.30],
                [0.24, 1.05, 0.24, [205, 195, 170], -0.35, 0.55,  0.30],
                [0.24, 1.05, 0.24, [205, 195, 170],  0.35, 0.55,  0.30],
            ]],
        ];
    }

    /** Build a passive animal of the given species from tinted cubes. */
    private function buildMob(string $species, float $wx, float $wz): array
    {
        $e = $this->e; $B = self::BLOCK;
        $defs = $this->mobDefs();
        $def = $defs[$species] ?? $defs['sheep'];
        $tex = $this->mobTex['wool']; // neutral fuzzy base, tinted per part
        $baby = (mt_rand(0, 4) === 0) ? 0.55 : 1.0;   // ~20% are babies (scaled down)
        $pivot = $e->xCreatePivot();
        $parts = [];
        foreach ($def['parts'] as [$w, $h, $d, $col, $ox, $oy, $oz]) {
            $c = $e->xCreateCube();
            $e->xScaleEntity($c, $this->scale * $w * $baby, $this->scale * $h * $baby, $this->scale * $d * $baby);
            $e->xEntityTexture($c, $tex);
            $e->xEntityColor($c, $col[0], $col[1], $col[2]);
            $e->xEntityParent($c, $pivot);
            $e->xPositionEntity($c, $ox * $B * $baby, $oy * $B * $baby, $oz * $B * $baby, 0);
            $parts[] = $c;
        }
        $e->xPositionEntity($pivot, $wx, $this->terrainTopY($wx, $wz), $wz);
        return ['pivot' => $pivot, 'parts' => $parts, 'x' => $wx, 'z' => $wz,
                'dx' => 0.0, 'dz' => 0.0, 'yaw' => 0.0, 'timer' => 0,
                'species' => $species, 'speed' => $def['speed']];
    }

    /** Topmost solid block cell in a column (from the data model). */
    private function groundTop(int $bx, int $bz): int
    {
        $start = $this->heightAt($bx, $bz) + 6; // account for trees / built towers
        for ($y = $start; $y >= 0; $y--) {
            if ($this->solidType($bx, $y, $bz) > 0) { return $y; }
        }
        return $this->heightAt($bx, $bz);
    }

    /**
     * Can an animal step into this column from a ground of height $curG?
     * Blocks on: void, cliffs higher than one block, or anything occupying the
     * body space just above the surface (trees, placed blocks).
     */
    private function mobBlocked(int $bx, int $bz, int $curG): bool
    {
        $gt = $this->groundTop($bx, $bz);
        if ($gt < 0) { return true; }
        if ($gt - $curG > 1) { return true; }
        if ($this->solidType($bx, $gt + 1, $bz) > 0) { return true; }
        if ($this->solidType($bx, $gt + 2, $bz) > 0) { return true; }
        return false;
    }

    private function mobPickDir(array &$m): void
    {
        if (mt_rand(0, 3) === 0) {
            $m['dx'] = 0.0; $m['dz'] = 0.0;            // idle graze
        } else {
            $a = mt_rand(0, 359) * M_PI / 180.0;
            $m['dx'] = sin($a); $m['dz'] = cos($a);
            $m['yaw'] = $a * 180.0 / M_PI;
        }
    }

    private function mobWalkable(float $nx, float $nz, int $curG): bool
    {
        $B = self::BLOCK;
        $leash = 70 * $B; // keep animals roaming near home
        if (abs($nx - $this->px) > $leash || abs($nz - $this->pz) > $leash) { return false; }
        if ($this->isWaterAt($nx, $nz)) { return false; }
        return !$this->mobBlocked($this->cellOf($nx), $this->cellOf($nz), $curG);
    }

    /** Try to advance, sliding around obstacles by testing nearby headings. */
    private function mobTryStep(array &$m, int $curG, float $spd): bool
    {
        $B = self::BLOCK;
        $base = atan2($m['dx'], $m['dz']);
        foreach ([0, 40, -40, 80, -80, 130, -130, 180] as $deg) {
            $a = $base + $deg * M_PI / 180.0;
            $cdx = sin($a); $cdz = cos($a);
            $nx = $m['x'] + $cdx * $spd * $B;
            $nz = $m['z'] + $cdz * $spd * $B;
            if ($this->mobWalkable($nx, $nz, $curG)) {
                $m['x'] = $nx; $m['z'] = $nz;
                $m['dx'] = $cdx; $m['dz'] = $cdz;
                $m['yaw'] = $a * 180.0 / M_PI;
                return true;
            }
        }
        return false;
    }

    private function updateMobs(): void
    {
        $e = $this->e; $B = self::BLOCK;

        foreach ($this->mobs as &$m) {
            $spd = $m['speed'] ?? 0.05;
            $curG = $this->groundTop($this->cellOf($m['x']), $this->cellOf($m['z']));

            if (--$m['timer'] <= 0) {
                $this->mobPickDir($m);
                $m['timer'] = mt_rand(80, 220);
            }

            if ($m['dx'] !== 0.0 || $m['dz'] !== 0.0) {
                if (!$this->mobTryStep($m, $curG, $spd * $this->dt)) {
                    // boxed in on all sides: pick a new goal shortly
                    $this->mobPickDir($m);
                    $m['timer'] = mt_rand(20, 50);
                }
            }

            $gy = $this->groundTop($this->cellOf($m['x']), $this->cellOf($m['z']));
            $y = (($gy >= 0) ? $gy : self::SEA) * $B + $B / 2;
            $e->xPositionEntity($m['pivot'], $m['x'], $y, $m['z']);
            $e->xRotateEntity($m['pivot'], 0, $m['yaw'], 0);
        }
        unset($m);
    }
}
