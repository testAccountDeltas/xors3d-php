<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "sysinfo" sample - prints CPU / memory / video info on screen.
 */
final class SysinfoController extends Controller
{
    public const TITLE = 'System information (CPU/RAM/GPU)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('SYSInfo sample (PHP)', 600, 500, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;

        $mb = static fn (float $kb): float => $kb / 1024.0;

        while ($this->running()) {
            $e->xCls();

            // CPU
            $e->xText(45, 50,  'Name: '     . $e->xCPUName());
            $e->xText(45, 70,  'Speed: '    . $e->xCPUSpeed() . ' MHz');
            $e->xText(45, 90,  'Vendor: '   . $e->xCPUVendor());
            $e->xText(45, 110, 'Family: '   . $e->xCPUFamily());
            $e->xText(45, 130, 'Model: '    . $e->xCPUModel());
            $e->xText(45, 150, 'Stepping: ' . $e->xCPUStepping());

            // Memory
            $e->xText(45,  200, sprintf('Total Phys: %.1f MB', $mb($e->xGetTotalPhysMem())));
            $e->xText(45,  220, sprintf('Avail Phys: %.1f MB', $mb($e->xGetAvailPhysMem())));
            $e->xText(45,  240, sprintf('Total Page: %.1f MB', $mb($e->xGetTotalPageMem())));
            $e->xText(45,  260, sprintf('Avail Page: %.1f MB', $mb($e->xGetAvailPageMem())));
            $e->xText(245, 200, sprintf('Used Phys: %.1f MB', $mb($e->xGetTotalPhysMem()) - $mb($e->xGetAvailPhysMem())));
            $e->xText(245, 240, sprintf('Used Page: %.1f MB', $mb($e->xGetTotalPageMem()) - $mb($e->xGetAvailPageMem())));

            // Video
            $e->xText(45,  330, 'Video Description: ' . $e->xVideoInfo());
            $e->xText(45,  350, sprintf('Total Vid: %.1f MB', $mb($e->xGetTotalVidMem())));
            $e->xText(45,  370, sprintf('Avail Vid: %.1f MB', $mb($e->xGetAvailVidMem())));

            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
