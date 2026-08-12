<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

/**
 * Procedural terrain sampling for the Craft voxel game: value noise, biome value,
 * surface height, caves and ore/ground types. Pure functions of world position
 * (plus the per-column height/biome caches). Mixed into MinecraftController so it
 * shares $this->seed, the caches and the world constants (SEA/SNOW/MAX_H).
 */
trait TerrainGen
{
    // ------------------------------------------------------------- 2D value noise

    private function hash2(float $x, float $z): float
    {
        $h = sin($x * 127.1 + $z * 311.7 + $this->seed) * 43758.5453;
        return $h - floor($h);
    }

    private function vnoise(float $x, float $z): float
    {
        $x0 = floor($x); $z0 = floor($z);
        $fx = $x - $x0;  $fz = $z - $z0;
        $u = $fx * $fx * (3 - 2 * $fx);
        $v = $fz * $fz * (3 - 2 * $fz);
        $a = $this->hash2($x0, $z0);       $b = $this->hash2($x0 + 1, $z0);
        $c = $this->hash2($x0, $z0 + 1);   $d = $this->hash2($x0 + 1, $z0 + 1);
        return ($a * (1 - $u) + $b * $u) * (1 - $v) + ($c * (1 - $u) + $d * $u) * $v;
    }

    private function fbm(float $x, float $z): float
    {
        $sum = 0.0; $amp = 0.5; $freq = 1.0;
        for ($o = 0; $o < 4; $o++) {
            $sum += $amp * $this->vnoise($x * $freq, $z * $freq);
            $amp *= 0.5; $freq *= 2.0;
        }
        return $sum; // 0 .. 0.9375
    }

    // ------------------------------------------------------------- terrain sampling

    /** Low-frequency biome value (0..1) for a column, cached. */
    private function biomeVal(int $x, int $z): float
    {
        if (isset($this->biome[$x][$z])) { return $this->biome[$x][$z]; }
        $b = $this->fbm($x * 0.012 + 500.0, $z * 0.012 + 500.0) / 0.9375; // 0..1
        return $this->biome[$x][$z] = $b;
    }

    /**
     * Procedural surface height (cached). Mostly flat plains/desert for easy
     * building; amplitude grows only in mountain biomes (high biome value).
     */
    private function heightAt(int $x, int $z): int
    {
        if (isset($this->height[$x][$z])) { return $this->height[$x][$z]; }
        $b = $this->biomeVal($x, $z);
        $mount = max(0.0, ($b - 0.72) / 0.28);      // 0 in lowlands, 1 in mountains
        $mount = $mount * $mount;
        // wide, gentle rolling hills everywhere (low frequency -> walkable slopes),
        // plus fine detail; mountains rise much taller in the mountain biome.
        $hills  = $this->fbm($x * 0.02, $z * 0.02) / 0.9375 - 0.5;        // -0.5..0.5 broad
        $detail = $this->fbm($x * 0.06 + 100.0, $z * 0.06 + 100.0) / 0.9375 - 0.5;
        $amp = 8.0 + $mount * 26.0;
        $h = (int) round((self::SEA + 4) + $hills * $amp + $detail * 2.5);
        $h = max(0, min(self::MAX_H, $h));
        return $this->height[$x][$z] = $h;
    }

    private function hash3(int $x, int $y, int $z): float
    {
        $h = sin($x * 127.1 + $y * 311.7 + $z * 74.7 + $this->seed) * 43758.5453;
        return $h - floor($h);
    }

    /** Smooth 3D value noise (0..1) via trilinear interpolation of hash3 lattice. */
    private function vnoise3(float $x, float $y, float $z): float
    {
        $x0 = (int) floor($x); $y0 = (int) floor($y); $z0 = (int) floor($z);
        $fx = $x - $x0; $fy = $y - $y0; $fz = $z - $z0;
        $u = $fx * $fx * (3 - 2 * $fx); $v = $fy * $fy * (3 - 2 * $fy); $w = $fz * $fz * (3 - 2 * $fz);
        $c000 = $this->hash3($x0,     $y0,     $z0);     $c100 = $this->hash3($x0 + 1, $y0,     $z0);
        $c010 = $this->hash3($x0,     $y0 + 1, $z0);     $c110 = $this->hash3($x0 + 1, $y0 + 1, $z0);
        $c001 = $this->hash3($x0,     $y0,     $z0 + 1); $c101 = $this->hash3($x0 + 1, $y0,     $z0 + 1);
        $c011 = $this->hash3($x0,     $y0 + 1, $z0 + 1); $c111 = $this->hash3($x0 + 1, $y0 + 1, $z0 + 1);
        $x00 = $c000 + ($c100 - $c000) * $u; $x10 = $c010 + ($c110 - $c010) * $u;
        $x01 = $c001 + ($c101 - $c001) * $u; $x11 = $c011 + ($c111 - $c011) * $u;
        $y0i = $x00 + ($x10 - $x00) * $v;    $y1i = $x01 + ($x11 - $x01) * $v;
        return $y0i + ($y1i - $y0i) * $w;
    }

    /** True where a cave hollows out underground rock (leaves a solid surface crust). */
    private function caveAt(int $x, int $y, int $z): bool
    {
        if ($y < 2) { return false; } // keep a floor above bedrock
        // smoothed 3D sample -> stringy tunnels + occasional pockets
        $n = $this->vnoise3($x * 0.06, $y * 0.09, $z * 0.06);
        return $n > 0.72;
    }

    /** Ore distribution inside stone (deterministic from position). */
    private function oreAt(int $x, int $y, int $z): int
    {
        $r = $this->hash3($x, $y, $z);
        $h = $this->heightAt($x, $z);
        if ($y < $h - 6 && $r > 0.985) { return 12; } // diamond (deep, rare)
        if ($r > 0.972) { return 14; }                // iron
        if ($r > 0.945) { return 13; }                // coal
        return 3;                                     // stone
    }

    /** Natural block type at a cell (before edits), by biome. 0 = air. */
    private function groundType(int $x, int $y, int $z): int
    {
        $h = $this->heightAt($x, $z);
        if ($y > $h || $y < 0) { return 0; }
        $b = $this->biomeVal($x, $z);
        $desert = $b < 0.30;
        if ($y === $h) {
            if ($h <= self::SEA)  { return 9; }              // beach
            if ($desert)          { return 9; }              // desert sand
            if ($h >= self::SNOW) { return 6; }              // snow cap
            if ($b >= 0.85 && $h > self::SEA + 7) { return 3; } // bare mountain rock
            return 1;                                        // grass
        }
        if ($y >= $h - 2) { return $desert ? 9 : 2; }        // sand / dirt
        return $this->oreAt($x, $y, $z);                     // stone / ore
    }
}
