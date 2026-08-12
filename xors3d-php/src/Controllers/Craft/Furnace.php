<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;

/**
 * Furnace smelting for the Craft voxel game: open a furnace with E to smelt
 * ores/materials (sand->glass, cobble->stone, log->coal, dirt->brick). Each
 * smelt burns one fuel (coal/wood/planks). Mixed into MinecraftController.
 */
trait Furnace
{
    /** Total fuel units the player is carrying. */
    private function fuelCount(): int
    {
        $n = 0;
        foreach (self::FUELS as $f) { $n += $this->invCount($f); }
        return $n;
    }

    /** Consume one fuel unit (prefers coal); returns false if none. */
    private function burnOneFuel(): bool
    {
        foreach (self::FUELS as $f) {
            if ($this->invCount($f) > 0) { $this->invAdd($f, -1); return true; }
        }
        return false;
    }

    /** Furnace menu: pick a material to smelt; consumes 1 input + 1 fuel -> 1 output. */
    private function openFurnace(): void
    {
        $e = $this->e;
        $ins = array_keys(self::SMELT);
        $n = count($ins);
        $sel = 0; $rowH = 58; $iconY = 6;

        while (true) {
            if ($this->closeRequested()) { $this->quit = true; return; }
            if ($e->xKeyHit(Constants::KEY_ESCAPE) || $e->xKeyHit(Constants::KEY_E)) { return; }
            if ($e->xKeyHit(Constants::KEY_UP))   { $sel = ($sel + $n - 1) % $n; }
            if ($e->xKeyHit(Constants::KEY_DOWN)) { $sel = ($sel + 1) % $n; }

            $doSmelt = $e->xKeyHit(Constants::KEY_RETURN);

            $w = $e->xGraphicsWidth(); $gh = $e->xGraphicsHeight();
            $panelW = 560; $panelH = $n * $rowH + 40;
            $gx = (int) (($w - $panelW) / 2); $gy = (int) (($gh - $panelH) / 2);
            $mx = $e->xMouseX(); $my = $e->xMouseY();
            $fuel = $this->fuelCount();

            $e->xRenderWorld();
            $e->xColor(12, 14, 22); $e->xRect(0, 0, $w, $gh, 1);
            $e->xColor(235, 235, 245);
            $e->xText((int) ($w / 2), $gy - 8, 'F U R N A C E', 1);
            $e->xColor(165, 170, 185);
            $e->xText((int) ($w / 2), $gy + 12, 'Up/Down: select   Enter/Click: smelt (1 fuel)   E/Esc: close   Fuel: ' . $fuel, 1);

            foreach ($ins as $i => $in) {
                $out = self::SMELT[$in];
                $ry = $gy + 34 + $i * $rowH;
                if ($mx >= $gx && $mx < $gx + $panelW && $my >= $ry && $my < $ry + $rowH - 4) {
                    $sel = $i;
                    if ($e->xMouseHit(1)) { $doSmelt = true; }
                }
                $have = $this->invCount($in);
                $ok = $have > 0 && $fuel > 0;
                if ($i === $sel) { $e->xColor(50, 56, 70); } else { $e->xColor(26, 28, 36); }
                $e->xRect($gx, $ry, $panelW, $rowH - 4, 1);
                if ($i === $sel) { $e->xColor(255, 235, 120); $e->xRect($gx, $ry, $panelW, $rowH - 4, 0); }

                $e->xDrawImage($this->icon[$in], $gx + 12, $ry + $iconY);
                $e->xColor($have > 0 ? 200 : 235, $have > 0 ? 255 : 90, $have > 0 ? 200 : 90);
                $e->xText($gx + 24, $ry + $iconY + 30, '(' . $have . ')');
                $e->xColor(210, 210, 220);
                $e->xText($gx + 108, $ry + $iconY + 14, '->');
                $e->xDrawImage($this->icon[$out], $gx + 138, $ry + $iconY);
                $e->xColor($ok ? 235 : 130, $ok ? 235 : 130, $ok ? 245 : 140);
                $e->xText($gx + 200, $ry + $iconY + 14, self::TYPES[$out][0]);
            }

            if ($doSmelt) {
                $in = $ins[$sel];
                if ($this->invCount($in) > 0) {
                    $this->invAdd($in, -1);            // take the input first...
                    if ($this->burnOneFuel()) {        // ...then a separate fuel unit
                        $this->invAdd(self::SMELT[$in], 1);
                        $this->play($this->sndPlace);
                    } else {
                        $this->invAdd($in, 1);         // no fuel: refund the input
                    }
                }
            }
            $e->xFlip();
        }
    }
}
