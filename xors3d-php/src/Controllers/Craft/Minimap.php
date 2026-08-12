<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * Top-right minimap for the Craft voxel game: samples the surface block type in a
 * grid around the player and paints it as coloured cells, with a player marker and
 * a north tick. The grid is rendered into an off-screen image and only rebuilt when
 * the player moves (or every ~0.5 s), then blitted with a single draw call per frame
 * - so it costs one xDrawImage/frame instead of thousands of xRect calls.
 * Toggle with the 'minimap' setting. Mixed into MinecraftController.
 */
trait Minimap
{
    private const MM_GRID = 48;
    private const MM_STEP = 2;
    private const MM_CELL = 2;

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

    /** Draw the full minimap grid + markers to the backbuffer at (x0,y0). */
    private function paintMinimap(Engine $e, int $x0, int $y0): void
    {
        $grid = self::MM_GRID; $step = self::MM_STEP; $cell = self::MM_CELL;
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
                $sh = max(0.7, min(1.25, 0.7 + $top / 30.0)); // light height relief
                $e->xColor((int) min(255, $r * $sh), (int) min(255, $g * $sh), (int) min(255, $b * $sh));
                $e->xRect($x0 + $gx * $cell, $y0 + $gz * $cell, $cell, $cell, 1);
            }
        }
        $e->xColor(255, 255, 255); $e->xRect($x0 + $half * $cell - 2, $y0 + $half * $cell - 2, 4, 4, 1);
        $e->xColor(255, 60, 60);   $e->xRect($x0 + $half * $cell - 1, $y0, 2, 6, 1);
    }

    /**
     * Draw the minimap. It is fully painted (thousands of cells) only when the player
     * moves a cell or every ~0.5 s; that frame the result is grabbed into an image, and
     * every other frame the image is blitted with a single draw call - keeping the cost
     * to ~one xDrawImage/frame instead of thousands of xRect calls.
     */
    private function drawMinimap(Engine $e): void
    {
        if (!(int) ($this->settings['minimap'] ?? 1)) { return; }
        $size = self::MM_GRID * self::MM_CELL;
        $x0 = $e->xGraphicsWidth() - $size - 12; $y0 = 12;
        if ($this->mmImg === 0) { $this->mmImg = $e->xCreateImage($size, $size); }

        $pbx = $this->cellOf($this->px); $pbz = $this->cellOf($this->pz);
        $now = $e->xMillisecs();
        $rebuild = ($this->mmBx === PHP_INT_MIN) || $pbx !== $this->mmBx || $pbz !== $this->mmBz
                   || ($now - $this->mmMs) > 500 || ($now - $this->mmMs) < 0;

        if ($rebuild) {
            $this->paintMinimap($e, $x0, $y0);              // draw grid to backbuffer...
            $e->xGrabImage($this->mmImg, $x0, $y0);         // ...and capture it for reuse
            $this->mmBx = $pbx; $this->mmBz = $pbz; $this->mmMs = $now;
        } else {
            $e->xDrawImage($this->mmImg, $x0, $y0);         // cheap: one blit
        }
        $e->xColor(10, 12, 18); $e->xRect($x0 - 2, $y0 - 2, $size + 4, $size + 4, 0); // frame
        $e->xColor(200, 205, 220); $e->xText($x0, $y0 + $size + 2, 'N up');
    }
}
