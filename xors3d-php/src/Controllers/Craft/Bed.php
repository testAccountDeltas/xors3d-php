<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

/**
 * Sleeping for the Craft voxel game: press B at night next to a bed (red wool)
 * to skip to morning by advancing the day-cycle offset. Mixed into
 * MinecraftController.
 */
trait Bed
{
    /** True if a bed block (red wool) is within ~2 blocks of the player. */
    private function bedNearby(): bool
    {
        $bx = $this->cellOf($this->px); $bz = $this->cellOf($this->pz); $by = $this->cellOf($this->py);
        for ($dx = -2; $dx <= 2; $dx++) {
            for ($dz = -2; $dz <= 2; $dz++) {
                for ($dy = -1; $dy <= 1; $dy++) {
                    if ($this->solidType($bx + $dx, $by + $dy, $bz + $dz) === 20) { return true; }
                }
            }
        }
        return false;
    }

    /** Sleep: only at night and only near a bed. Jumps the day cycle to early morning. */
    private function trySleep(): void
    {
        if (!(int) ($this->settings['daynight'] ?? 1)) { $this->status = 'No day/night cycle.'; return; }
        if ($this->dayF > 0.15) { $this->status = 'You can only sleep at night.'; return; }
        if (!$this->bedNearby()) { $this->status = 'No bed nearby (place red wool).'; return; }

        $now = fmod($this->e->xMillisecs() / 120000.0 + $this->timeShift, 1.0);
        $target = 0.05; // just after sunrise
        $this->timeShift += fmod($target - $now + 1.0, 1.0); // always advance forward
        $this->status = 'Good morning!';
    }
}
