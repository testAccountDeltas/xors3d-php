<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * Top-right minimap for the Craft voxel game: samples the surface block type in a
 * grid around the player and paints coloured cells, with a player marker + north tick.
 *
 * NOTE: this engine can't reliably render 2D into an off-screen image (both
 * xImageBuffer and xGrabImage come back blank via FFI), so the map is drawn directly
 * each frame - which costs many 2D draw calls. It is therefore OFF by default and
 * toggled with M; when shown it trades some FPS for the map. Mixed into
 * MinecraftController.
 */
trait Minimap
{
    private const MM_GRID = 32;   // cells per side
    private const MM_STEP = 2;    // blocks per cell (covers 64 blocks)
    private const MM_CELL = 2;    // pixels per cell (64px map)

    /** Approximate top-down colour for a block type (0 = air/water). */
    private function minimapColor(int $t, bool $water): array
    {
        if ($t === 0) { return $water ? [60, 110, 180] : [150, 190, 235]; }
        return match ($t) {
            1  => [90, 150, 60],   2  => [120, 85, 55],   3  => [130, 130, 130],
            4  => [150, 80, 70],   5  => [150, 120, 70],  6  => [235, 235, 245],
            7  => [50, 110, 45],   8  => [100, 75, 45],   9  => [220, 210, 160],
            10 => [180, 210, 230], 11 => [235, 205, 120], 12 => [120, 200, 210],
            13 => [60, 60, 60],    14 => [200, 180, 150], 15 => [110, 110, 110],
            16 => [122, 122, 122], 17 => [170, 140, 90],  18 => [90, 65, 40],
            19 => [140, 100, 60],  20 => [190, 60, 60],   21 => [230, 230, 230],
            22 => [125, 125, 125], 23 => [120, 90, 55],   24 => [150, 110, 60],
            25 => [100, 100, 100],
            default => [120, 120, 120],
        };
    }

    /** Draw the minimap directly in the top-right corner (map up = north / -Z). */
    private function drawMinimap(Engine $e): void
    {
        if (!(int) ($this->settings['minimap'] ?? 0)) { return; } // off by default (M to toggle)
        $grid = self::MM_GRID; $step = self::MM_STEP; $cell = self::MM_CELL;
        $size = $grid * $cell;
        $x0 = $e->xGraphicsWidth() - $size - 12; $y0 = 12;
        $pbx = $this->cellOf($this->px); $pbz = $this->cellOf($this->pz);
        $half = intdiv($grid, 2);

        for ($gz = 0; $gz < $grid; $gz++) {
            $bz = $pbz + ($gz - $half) * $step;
            for ($gx = 0; $gx < $grid; $gx++) {
                $bx = $pbx + ($gx - $half) * $step;
                $top = $this->groundTop($bx, $bz);
                $water = $this->heightAt($bx, $bz) < self::SEA;
                $t = $water ? 0 : $this->solidType($bx, $top, $bz);
                [$r, $g, $b] = $this->minimapColor($t, $water);
                $sh = max(0.7, min(1.25, 0.7 + $top / 30.0));
                $e->xColor((int) min(255, $r * $sh), (int) min(255, $g * $sh), (int) min(255, $b * $sh));
                $e->xRect($x0 + $gx * $cell, $y0 + $gz * $cell, $cell, $cell, 1);
            }
        }
        $e->xColor(255, 255, 255); $e->xRect($x0 + $half * $cell - 2, $y0 + $half * $cell - 2, 4, 4, 1);
        $e->xColor(255, 60, 60);   $e->xRect($x0 + $half * $cell - 1, $y0, 2, 6, 1);
        $e->xColor(10, 12, 18);    $e->xRect($x0 - 2, $y0 - 2, $size + 4, $size + 4, 0);
        $e->xColor(200, 205, 220); $e->xText($x0, $y0 + $size + 2, 'N up (M)');
    }
}
