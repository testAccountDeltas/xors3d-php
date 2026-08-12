<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * Survival mechanics for the Craft voxel game (no combat): health with fall
 * damage and drowning, slow regeneration, death/respawn and a heart + air-bubble
 * HUD. Disabled while flying and via the 'survival' setting. Mixed into
 * MinecraftController.
 */
trait Survival
{
    private const MAX_HP = 20.0;

    /** Reset vitals (new spawn / respawn). */
    private function resetVitals(): void
    {
        $this->hp = self::MAX_HP;
        $this->breath = 10.0;
        $this->airMaxY = $this->py;
        $this->wasGround = true;
        $this->fallGrace = true; // the drop from the spawn point above ground is free
    }

    /** Per-frame health update: fall damage on landing, drowning, slow regen. */
    private function updateSurvival(): void
    {
        $dt = $this->dt;
        $B = self::BLOCK;

        // creative-ish: no damage while flying or when survival is off
        if ($this->fly || !(int) ($this->settings['survival'] ?? 1)) {
            $this->airMaxY = $this->py;
            $this->wasGround = $this->onGround;
            if ($this->hp < self::MAX_HP) { $this->hp = min(self::MAX_HP, $this->hp + 0.02 * $dt); }
            $this->breath = 10.0;
            return;
        }

        // fall damage: measure the drop from the highest airborne point to the landing
        if ($this->onGround) {
            if (!$this->wasGround) {
                if ($this->fallGrace) {
                    $this->fallGrace = false;                // first spawn landing: no damage
                } else {
                    $fell = ($this->airMaxY - $this->py) / $B;   // blocks fallen
                    if ($fell > 3.5) { $this->hp -= ($fell - 3.5) * 1.15; $this->play($this->sndBreak); }
                }
            }
            $this->airMaxY = $this->py;
        } else {
            $this->airMaxY = max($this->airMaxY, $this->py);
        }
        $this->wasGround = $this->onGround;

        // drowning: head submerged in water (water sits at SEA level in sea columns)
        $eyeY = $this->py + self::EYE;
        $head = $eyeY < (self::SEA * $B + $B * 0.5) && $this->isWaterAt($this->px, $this->pz);
        if ($head) {
            $this->breath -= 0.06 * $dt;
            if ($this->breath <= 0.0) { $this->breath = 0.0; $this->hp -= 0.06 * $dt; }
        } else {
            $this->breath = min(10.0, $this->breath + 0.15 * $dt);
            if ($this->hp < self::MAX_HP) { $this->hp = min(self::MAX_HP, $this->hp + 0.012 * $dt); } // slow regen
        }

        if ($this->hp <= 0.0) {
            $this->status = 'You died - respawned.';
            $this->spawnPlayer();   // spawnPlayer() calls resetVitals()
        }
    }

    /** Draw the heart bar (and air bubbles when submerged) above the hotbar. */
    private function drawVitals(Engine $e): void
    {
        if (!(int) ($this->settings['survival'] ?? 1)) { return; }
        $w = $e->xGraphicsWidth();
        $cx = (int) ($w / 2);
        $barW = count($this->hotbar) * 52;
        $x0 = $cx - (int) ($barW / 2);
        $y = $e->xGraphicsHeight() - 52 - 8 - 26;

        // 10 hearts, each = 2 hp; filled red, half = orange, empty = dark
        for ($i = 0; $i < 10; $i++) {
            $hx = $x0 + $i * 16;
            $lvl = $this->hp - $i * 2.0; // >=2 full, ==1 half, <=0 empty
            if ($lvl >= 2.0)      { $e->xColor(220, 40, 40); }
            elseif ($lvl >= 1.0)  { $e->xColor(230, 130, 40); }
            else                  { $e->xColor(60, 30, 30); }
            $e->xRect($hx, $y, 12, 12, 1);
            $e->xColor(20, 10, 10);
            $e->xRect($hx, $y, 12, 12, 0);
        }

        // air bubbles while breath is being used
        if ($this->breath < 10.0) {
            for ($i = 0; $i < 10; $i++) {
                if ($this->breath <= $i) { break; }
                $bx = $x0 + $barW - 12 - $i * 16;
                $e->xColor(120, 190, 255);
                $e->xRect($bx, $y - 16, 12, 12, 1);
            }
        }
    }
}
