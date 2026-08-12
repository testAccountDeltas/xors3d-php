<?php

declare(strict_types=1);

/**
 * Assemble an animated GIF from a folder of BMP frames (produced by the game's
 * CRAFT_SHOTSEQ capture). Pure PHP + GD - no ffmpeg/ImageMagick needed.
 *
 * Usage:
 *   php -d extension_dir=phpx86/ext -d extension=gd \
 *       xors3d-php/bin/make_gif.php <framesDir> <out.gif> [width] [delayCs]
 *
 * width   - output width in px (height keeps aspect), default 640
 * delayCs - frame delay in centiseconds (1/100 s), default 7 (~14 fps)
 */

[$self, $dir, $out] = [$argv[0] ?? '', $argv[1] ?? '', $argv[2] ?? ''];
$width   = (int) ($argv[3] ?? 640);
$delayCs = (int) ($argv[4] ?? 7);
if ($dir === '' || $out === '') {
    fwrite(STDERR, "usage: make_gif.php <framesDir> <out.gif> [width] [delayCs]\n");
    exit(1);
}

$files = glob(rtrim($dir, '/\\') . '/*.bmp');
sort($files);
if ($files === []) { fwrite(STDERR, "no .bmp frames in $dir\n"); exit(1); }

$frames = [];
foreach ($files as $f) {
    $src = imagecreatefrombmp($f);
    if ($src === false) { continue; }
    $w = imagesx($src); $h = imagesy($src);
    $nh = (int) round($h * $width / $w);
    $dst = imagescale($src, $width, $nh, IMG_BILINEAR_FIXED);
    ob_start();
    imagegif($dst);              // GD emits a 256-colour single-frame GIF
    $frames[] = ob_get_clean();
}
fwrite(STDERR, 'frames: ' . count($frames) . "\n");

file_put_contents($out, gif_animate($frames, $delayCs, 0));
fwrite(STDERR, "wrote $out (" . filesize($out) . " bytes)\n");

/**
 * Merge single-frame GIF binaries into one animated GIF (loop = 0 => forever).
 * Based on the classic GIFEncoder approach: global palette from the first frame,
 * a Graphic Control Extension (delay) before every frame, local palette per frame
 * when it differs from the global one.
 */
function gif_animate(array $frames, int $delayCs, int $loop): string
{
    $first = $frames[0];
    $globalFlag = ord($first[10]) & 0x80;
    $globalLen  = $globalFlag ? 3 * (1 << ((ord($first[10]) & 0x07) + 1)) : 0;

    $out  = 'GIF89a';
    $out .= substr($first, 6, 7);                 // logical screen descriptor
    $out .= substr($first, 13, $globalLen);       // global colour table
    // NETSCAPE2.0 looping extension
    $out .= "\x21\xFF\x0BNETSCAPE2.0\x03\x01" . chr($loop & 0xFF) . chr(($loop >> 8) & 0xFF) . "\x00";

    foreach ($frames as $bin) {
        $localFlag = ord($bin[10]) & 0x80;
        $localLen  = $localFlag ? 3 * (1 << ((ord($bin[10]) & 0x07) + 1)) : 0;
        $localPal  = substr($bin, 13, $localLen);

        // find the image separator 0x2C after the (local) colour table
        $p = 13 + $localLen;
        // skip any extensions GD may have emitted before the image descriptor
        while ($p < strlen($bin) && $bin[$p] === "\x21") {
            $p += 2;                               // 0x21 + label
            while ($p < strlen($bin) && ($sz = ord($bin[$p])) !== 0) { $p += $sz + 1; }
            $p += 1;                               // terminating 0x00 block
        }
        if ($bin[$p] !== "\x2C") { continue; }     // not an image block; skip frame

        // graphic control extension with our delay (disposal = 1: leave in place)
        $out .= "\x21\xF9\x04\x04" . chr($delayCs & 0xFF) . chr(($delayCs >> 8) & 0xFF) . "\x00\x00";

        // image descriptor (10 bytes). Force the local-colour-table flag AND copy the
        // colour-table size bits from this frame's screen descriptor so the table length
        // in the descriptor matches the palette we append (otherwise the GIF is corrupt).
        $desc = substr($bin, $p, 10);
        $sizeBits = ord($bin[10]) & 0x07;
        $desc[9] = chr(0x80 | $sizeBits); // local table present, given size; no interlace/sort
        $out .= $desc;
        $out .= $localPal;

        // the rest of the frame up to (not including) the trailer 0x3B
        $end = strrpos($bin, "\x3B");
        $out .= substr($bin, $p + 10, $end - ($p + 10));
    }

    $out .= "\x3B";
    return $out;
}
