<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Port of the "rw_pixel" sample - locks the back buffer, reads every pixel and
 * writes it back vertically flipped.
 *
 * Note: this does per-pixel FFI calls (width*height per frame), so in PHP it is
 * inherently slow - it faithfully mirrors the original algorithm.
 */
final class RwPixelController extends Controller
{
    public const TITLE = 'Read/write back-buffer pixels (slow)';

    public function index(int|string $maxFrames = 0): int
    {
        $e   = $this->boot('Read/Write Pixel (PHP)', 640, 480, 32, 0);
        $max = (int) $maxFrames;
        $frame = 0;

        $e->xAntiAlias(1);
        $e->xSetTextureFiltering(Constants::TF_ANISOTROPIC);

        $image = $e->xLoadImage($this->media('Textures/stones_normal.tga'));

        $w = $e->xGraphicsWidth();
        $h = $e->xGraphicsHeight();

        while ($this->running()) {
            $e->xRenderWorld();
            $e->xCls();
            $e->xDrawImage($image, 0, 0);
            $e->xText(10, 10, 'Some text here...');

            $back = $e->xBackBuffer();
            $e->xLockBuffer($back);

            // read all pixels into a flat array (column-major, as the original)
            $pixels = [];
            for ($y = 0; $y < $h; $y++) {
                for ($x = 0; $x < $w; $x++) {
                    $pixels[$x][$y] = $e->xReadPixelFast($x, $y);
                }
            }

            $e->xCls();

            // write them back vertically flipped
            for ($y = 0; $y < $h; $y++) {
                for ($x = 0; $x < $w; $x++) {
                    $e->xWritePixelFast($x, $y, $pixels[$x][$h - $y - 1]);
                }
            }

            $e->xUnlockBuffer($back);
            $e->xFlip();
            if ($max > 0 && ++$frame >= $max) {
                break;
            }
        }
        $e->xReleaseGraphics();
        return 0;
    }
}
