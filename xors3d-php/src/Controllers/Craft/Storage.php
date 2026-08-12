<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;

/**
 * Chest storage for the Craft voxel game: per-chest inventories and a two-panel
 * transfer menu (chest <-> player). Opened with E on a chest block. Mixed into
 * MinecraftController.
 */
trait Storage
{
    /** Open the chest at (x,y,z): move whole stacks between chest and player. */
    private function openChest(int $x, int $y, int $z): void
    {
        $e = $this->e;
        $key = "$x,$y,$z";
        $this->chests[$key] ??= [];
        $sel = 0; $panel = 0; // 0 = chest, 1 = player

        while (true) {
            if ($this->closeRequested()) { $this->quit = true; return; }
            if ($e->xKeyHit(Constants::KEY_ESCAPE) || $e->xKeyHit(Constants::KEY_E)) { return; }

            $chest = &$this->chests[$key];
            $chestIds = array_values(array_filter(array_keys(self::TYPES), fn($t) => ($chest[$t] ?? 0) > 0));
            $invIds   = array_values(array_filter(array_keys(self::TYPES), fn($t) => ($this->inv[$t] ?? 0) > 0));

            if ($e->xKeyHit(Constants::KEY_TAB)) { $panel ^= 1; $sel = 0; }
            $list = $panel === 0 ? $chestIds : $invIds;
            $n = count($list);
            if ($n > 0) {
                if ($e->xKeyHit(Constants::KEY_LEFT))  { $sel = ($sel + $n - 1) % $n; }
                if ($e->xKeyHit(Constants::KEY_RIGHT)) { $sel = ($sel + 1) % $n; }
                if ($sel >= $n) { $sel = $n - 1; }
                if ($e->xKeyHit(Constants::KEY_RETURN) || $e->xMouseHit(1)) {
                    $t = $list[$sel];
                    if ($panel === 0) { // chest -> player
                        $this->invAdd($t, $chest[$t]); unset($chest[$t]);
                    } else {            // player -> chest
                        $chest[$t] = ($chest[$t] ?? 0) + $this->inv[$t]; unset($this->inv[$t]);
                    }
                    $this->play($this->sndPlace);
                }
            }
            unset($chest);

            $w = $e->xGraphicsWidth(); $gh = $e->xGraphicsHeight();
            $e->xRenderWorld();
            $e->xColor(12, 14, 22); $e->xRect(0, 0, $w, $gh, 1);
            $e->xColor(235, 235, 245);
            $e->xText((int) ($w / 2), 60, 'C H E S T', 1);
            $e->xColor(165, 170, 185);
            $e->xText((int) ($w / 2), 82, 'Tab: switch    Left/Right: select    Enter/Click: move stack    E/Esc: close', 1);

            $this->drawChestGrid($e, 'Chest', $chestIds, $this->chests[$key], (int) ($w / 2), 140, $panel === 0 ? $sel : -1);
            $this->drawChestGrid($e, 'Inventory', $invIds, $this->inv, (int) ($w / 2), (int) ($gh / 2) + 40, $panel === 1 ? $sel : -1);

            $e->xFlip();
        }
    }

    /** Draw one labelled grid of block icons with counts; highlight $sel (or -1). */
    private function drawChestGrid($e, string $title, array $ids, array $counts, int $cx, int $top, int $sel): void
    {
        $cols = 9; $cell = 52; $pad = 4;
        $rows = max(1, (int) ceil(max(1, count($ids)) / $cols));
        $gw = $cols * $cell;
        $gx = $cx - (int) ($gw / 2);
        $e->xColor(200, 205, 220);
        $e->xText($gx, $top - 20, $title . '  (' . count($ids) . ')');
        // grid background
        $e->xColor(24, 26, 34); $e->xRect($gx - 4, $top - 4, $gw + 8, $rows * $cell + 8, 1);
        foreach ($ids as $i => $id) {
            $r = intdiv($i, $cols); $c = $i % $cols;
            $sx = $gx + $c * $cell; $sy = $top + $r * $cell;
            $e->xColor(30, 32, 40); $e->xRect($sx, $sy, $cell - 3, $cell - 3, 1);
            $e->xDrawImage($this->icon[$id], $sx + $pad, $sy + $pad);
            if ($i === $sel) { $e->xColor(255, 235, 120); $e->xRect($sx - 1, $sy - 1, $cell, $cell, 0); }
            $e->xColor(255, 255, 255);
            $e->xText($sx + $cell - 22, $sy + $cell - 20, (string) ($counts[$id] ?? 0));
        }
    }
}
