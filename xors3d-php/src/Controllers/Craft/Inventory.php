<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;

/**
 * Survival inventory + crafting for the Craft voxel game: per-type item counts,
 * block drops when mining, consumption when placing, a starter kit, and a recipe
 * crafting menu (opened with C). Mixed into MinecraftController.
 */
trait Inventory
{
    private function invCount(int $type): int
    {
        return $this->inv[$type] ?? 0;
    }

    private function invAdd(int $type, int $n = 1): void
    {
        if ($type <= 0) { return; }
        $this->inv[$type] = max(0, ($this->inv[$type] ?? 0) + $n);
        if ($this->inv[$type] === 0) { unset($this->inv[$type]); }
    }

    /** What a broken block yields: grass->dirt, stone->cobblestone, leaves->nothing, else itself. */
    private function dropFor(int $type): int
    {
        return match ($type) {
            1  => 2,   // grass -> dirt
            3  => 15,  // stone -> cobblestone
            7  => 0,   // leaves -> nothing
            default => $type,
        };
    }

    /** Give the player a modest set of starter blocks on a new world. */
    private function starterKit(): void
    {
        $this->inv = [
            2 => 32,   // dirt
            17 => 24,  // oak planks
            15 => 24,  // cobblestone
            5 => 16,   // wood
            10 => 8,   // glass
            23 => 3,   // doors
            11 => 6,   // glowstone lamps
        ];
    }

    /** Can the recipe at $i be crafted with the current inventory? */
    private function canCraft(int $i): bool
    {
        foreach (self::RECIPES[$i]['in'] as $t => $c) {
            if ($this->invCount($t) < $c) { return false; }
        }
        return true;
    }

    /** Consume the recipe inputs and add its output to the inventory. */
    private function doCraft(int $i): bool
    {
        if (!$this->canCraft($i)) { return false; }
        foreach (self::RECIPES[$i]['in'] as $t => $c) { $this->invAdd($t, -$c); }
        [$ot, $oc] = self::RECIPES[$i]['out'];
        $this->invAdd($ot, $oc);
        $this->play($this->sndPlace);
        return true;
    }

    /**
     * Crafting menu (C): a list of recipes (inputs -> output) with live counts;
     * craftable rows are highlighted. Up/Down select, Enter crafts, C/Esc closes.
     */
    private function craftMenu(): void
    {
        $e = $this->e;
        $recipes = self::RECIPES;
        $n = count($recipes);
        $sel = 0;
        $rowH = 58; $iconY = 6;

        while (true) {
            if ($this->closeRequested()) { $this->quit = true; return; }
            if ($e->xKeyHit(Constants::KEY_ESCAPE) || $e->xKeyHit(Constants::KEY_C)) { return; }
            if ($e->xKeyHit(Constants::KEY_UP))   { $sel = ($sel + $n - 1) % $n; }
            if ($e->xKeyHit(Constants::KEY_DOWN)) { $sel = ($sel + 1) % $n; }
            if ($e->xKeyHit(Constants::KEY_RETURN)) { $this->doCraft($sel); }

            $w = $e->xGraphicsWidth(); $gh = $e->xGraphicsHeight();
            $panelW = 560; $panelH = $n * $rowH + 40;
            $gx = (int) (($w - $panelW) / 2); $gy = (int) (($gh - $panelH) / 2);

            $mx = $e->xMouseX(); $my = $e->xMouseY();

            $e->xRenderWorld();
            $e->xColor(12, 14, 22); $e->xRect(0, 0, $w, $gh, 1);
            $e->xColor(235, 235, 245);
            $e->xText((int) ($w / 2), $gy - 8, 'C R A F T I N G', 1);
            $e->xColor(165, 170, 185);
            $e->xText((int) ($w / 2), $gy + 12, 'Up/Down: select    Enter: craft    C/Esc: close', 1);

            foreach ($recipes as $i => $r) {
                $ry = $gy + 34 + $i * $rowH;
                if ($mx >= $gx && $mx < $gx + $panelW && $my >= $ry && $my < $ry + $rowH - 4) {
                    $sel = $i;
                    if ($e->xMouseHit(1)) { $this->doCraft($i); }
                }
                $ok = $this->canCraft($i);
                // row background: selected = bright, else dim; green tint if craftable
                if ($i === $sel) { $e->xColor(50, 56, 70); } else { $e->xColor(26, 28, 36); }
                $e->xRect($gx, $ry, $panelW, $rowH - 4, 1);
                if ($i === $sel) { $e->xColor(255, 235, 120); $e->xRect($gx, $ry, $panelW, $rowH - 4, 0); }

                // inputs
                $ix = $gx + 12;
                foreach ($r['in'] as $t => $c) {
                    $e->xDrawImage($this->icon[$t], $ix, $ry + $iconY);
                    $e->xColor($this->invCount($t) >= $c ? 200 : 235, $this->invCount($t) >= $c ? 255 : 90, $this->invCount($t) >= $c ? 200 : 90);
                    $e->xText($ix + 12, $ry + $iconY + 30, $c . ' (' . $this->invCount($t) . ')');
                    $ix += 96;
                }
                // arrow + output
                $e->xColor(210, 210, 220);
                $e->xText($ix, $ry + $iconY + 14, '->');
                $ix += 30;
                [$ot, $oc] = $r['out'];
                $e->xDrawImage($this->icon[$ot], $ix, $ry + $iconY);
                $e->xColor($ok ? 180 : 150, 255, $ok ? 180 : 150);
                $e->xText($ix + 12, $ry + $iconY + 30, 'x' . $oc);
                // output name
                $e->xColor($ok ? 235 : 130, $ok ? 235 : 130, $ok ? 245 : 140);
                $e->xText($ix + 60, $ry + $iconY + 14, self::TYPES[$ot][0]);
            }
            $e->xFlip();
        }
    }
}
