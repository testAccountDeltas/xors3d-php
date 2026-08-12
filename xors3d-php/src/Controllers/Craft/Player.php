<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;

/**
 * Player controller for the Craft voxel game: WASD/fly movement, voxel collision,
 * auto step-up, gravity/jump, and the shared cell/solid queries. Mixed into
 * MinecraftController (drives $this->px/py/pz each frame from gameLoop).
 */
trait Player
{
    /** True if a solid (non-water) block occupies this voxel cell. */
    private function solidCell(int $bx, int $by, int $bz): bool
    {
        return $this->solidType($bx, $by, $bz) > 0;
    }

    private function cellOf(float $w): int
    {
        return (int) floor(($w + self::BLOCK / 2) / self::BLOCK);
    }

    private function move(): void
    {
        $e = $this->e;
        $fly = $this->fly;

        // direction from camera transform (so it follows where you look)
        $e->xTFormVector(0, 0, 1, $this->camH, 0);
        $fwx = $e->xTFormedX(); $fwy = $e->xTFormedY(); $fwz = $e->xTFormedZ();
        $e->xTFormVector(1, 0, 0, $this->camH, 0);
        $rgx = $e->xTFormedX(); $rgy = $e->xTFormedY(); $rgz = $e->xTFormedZ();

        if (!$fly) { // project onto XZ for walking
            $fl = hypot($fwx, $fwz) ?: 1.0; $fwx /= $fl; $fwz /= $fl; $fwy = 0.0;
            $rl = hypot($rgx, $rgz) ?: 1.0; $rgx /= $rl; $rgz /= $rl; $rgy = 0.0;
        }

        $spd = $fly ? self::SPD_FLY : self::SPD_WALK;
        $mx = $my = $mz = 0.0;
        if ($e->xKeyDown(Constants::KEY_W)) { $mx += $fwx; $my += $fwy; $mz += $fwz; }
        if ($e->xKeyDown(Constants::KEY_S)) { $mx -= $fwx; $my -= $fwy; $mz -= $fwz; }
        if ($e->xKeyDown(Constants::KEY_D)) { $mx += $rgx; $my += $rgy; $mz += $rgz; }
        if ($e->xKeyDown(Constants::KEY_A)) { $mx -= $rgx; $my -= $rgy; $mz -= $rgz; }
        $ml = hypot(hypot($mx, $my), $mz);
        if ($ml > 0.0) { $mx = $mx / $ml * $spd; $my = $my / $ml * $spd; $mz = $mz / $ml * $spd; }

        $moving = $ml > 0.0;

        $dt = $this->dt;
        if ($fly) {
            $this->px += $mx * $dt; $this->py += $my * $dt; $this->pz += $mz * $dt;
            if ($e->xKeyDown(Constants::KEY_SPACE))  { $this->py += $spd * $dt; }
            if ($e->xKeyDown(Constants::KEY_LSHIFT)) { $this->py -= $spd * $dt; }
        } else {
            $this->moveAxisX($mx * $dt);
            $this->moveAxisZ($mz * $dt);
            $this->applyGravity();
            if ($this->onGround && $e->xKeyHit(Constants::KEY_SPACE)) { $this->vy = self::JUMP; }
            // footsteps
            if ($moving && $this->onGround) {
                $now = $e->xMillisecs();
                if ($now - $this->lastStep > 340) { $this->play($this->sndStep); $this->lastStep = $now; }
            }
            if ($this->py < -30.0) { $this->spawnPlayer(); } // fell out of the world
        }

        $e->xPositionEntity($this->camH, $this->px, $this->py + self::EYE, $this->pz);
    }

    private function blockedAt(float $x, float $z): bool
    {
        $bx = $this->cellOf($x); $bz = $this->cellOf($z);
        $c1 = $this->cellOf($this->py + 0.2);
        $c2 = $this->cellOf($this->py + self::PH - 0.2);
        return $this->solidCell($bx, $c1, $bz) || $this->solidCell($bx, $c2, $bz);
    }

    private function moveAxisX(float $mx): void
    {
        if ($mx === 0.0) { return; }
        $tx = $this->px + $mx + ($mx > 0 ? self::HW : -self::HW);
        if (!$this->blockedAt($tx, $this->pz)) { $this->px += $mx; return; }
        // auto step-up: climb a 1-block rise (hills, stairs) if there is headroom
        if ($this->onGround && $this->canStepUp($tx, $this->pz)) {
            $this->py += self::BLOCK; $this->px += $mx;
        }
    }

    private function moveAxisZ(float $mz): void
    {
        if ($mz === 0.0) { return; }
        $tz = $this->pz + $mz + ($mz > 0 ? self::HW : -self::HW);
        if (!$this->blockedAt($this->px, $tz)) { $this->pz += $mz; return; }
        if ($this->onGround && $this->canStepUp($this->px, $tz)) {
            $this->py += self::BLOCK; $this->pz += $mz;
        }
    }

    /** True if a single block rise here can be climbed (block at feet, clear above). */
    private function canStepUp(float $x, float $z): bool
    {
        $bx = $this->cellOf($x); $bz = $this->cellOf($z);
        $feet = $this->cellOf($this->py + 0.2);
        if (!$this->solidCell($bx, $feet, $bz)) { return false; } // nothing to step onto
        // body must be clear one block higher
        $c1 = $this->cellOf($this->py + self::BLOCK + 0.2);
        $c2 = $this->cellOf($this->py + self::BLOCK + self::PH - 0.2);
        return !$this->solidCell($bx, $c1, $bz) && !$this->solidCell($bx, $c2, $bz);
    }

    private function applyGravity(): void
    {
        $dt = $this->dt;
        $this->vy -= self::G * $dt;
        $ny = $this->py + $this->vy * $dt;
        $bx = $this->cellOf($this->px); $bz = $this->cellOf($this->pz);

        if ($this->vy <= 0.0) {
            $fc = $this->cellOf($ny);
            if ($this->solidCell($bx, $fc, $bz)) {
                $this->py = $fc * self::BLOCK + self::BLOCK / 2 + 0.02;
                $this->vy = 0.0;
                $this->onGround = true;
                return;
            }
            $this->onGround = false;
        } else {
            $hc = $this->cellOf($this->py + self::PH + $this->vy * $dt);
            if ($this->solidCell($bx, $hc, $bz)) { $this->vy = 0.0; return; }
        }
        $this->py = $ny;
    }
}
