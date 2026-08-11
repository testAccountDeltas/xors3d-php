<?php

declare(strict_types=1);

/**
 * Generates the soft sky textures used by the Craft demo:
 *   assets/sky/puff.png  - soft round cloud puff (white, alpha falloff)
 *   assets/sky/sun.png   - round glowing sun (warm-white core -> orange halo)
 *   assets/sky/moon.png  - round glowing moon (pale core -> cool-blue halo)
 *
 * Requires the GD extension. Run once:
 *   ..\phpx86\php.exe -d extension_dir=..\phpx86\ext -d extension=gd bin\gen_sky.php
 */

$dir = dirname(__DIR__) . '/assets/sky';
@mkdir($dir, 0777, true);

if (!function_exists('imagecreatetruecolor')) {
    fwrite(STDERR, "GD not available - run with -d extension=gd\n");
    exit(1);
}

/** Soft white puff: opaque-ish center fading smoothly to transparent edge. */
function puff(string $path): void
{
    $sz = 128; $im = imagecreatetruecolor($sz, $sz);
    imagealphablending($im, false); imagesavealpha($im, true);
    $c = ($sz - 1) / 2.0;
    for ($y = 0; $y < $sz; $y++) {
        for ($x = 0; $x < $sz; $x++) {
            $dx = ($x - $c) / $c; $dy = ($y - $c) / $c; $d = sqrt($dx * $dx + $dy * $dy);
            $t = 1.0 - $d; if ($t < 0) { $t = 0; } $t = $t * $t * (3 - 2 * $t); // smoothstep
            $a = (int) round(127 * (1.0 - $t));
            imagesetpixel($im, $x, $y, ($a << 24) | (255 << 16) | (255 << 8) | 255);
        }
    }
    imagepng($im, $path);
}

/** Round glowing celestial body: bright core + soft coloured halo. */
function radial(string $path, float $coreR, float $glowPow,
                int $cr, int $cg, int $cb, int $er, int $eg, int $eb): void
{
    $sz = 128; $im = imagecreatetruecolor($sz, $sz);
    imagealphablending($im, false); imagesavealpha($im, true);
    $c = ($sz - 1) / 2.0;
    for ($y = 0; $y < $sz; $y++) {
        for ($x = 0; $x < $sz; $x++) {
            $dx = ($x - $c) / $c; $dy = ($y - $c) / $c; $d = sqrt($dx * $dx + $dy * $dy);
            $core = ($coreR + 0.06 - $d) / 0.12; $core = max(0.0, min(1.0, $core));
            $glow = 1.0 - $d / 1.05; if ($glow < 0) { $glow = 0; } $glow = pow($glow, $glowPow);
            $inten = max($core, $glow);
            if ($inten <= 0) { imagesetpixel($im, $x, $y, 127 << 24); continue; }
            $mix = min(1.0, $d);
            $r = (int) ($cr + ($er - $cr) * $mix);
            $g = (int) ($cg + ($eg - $cg) * $mix);
            $b = (int) ($cb + ($eb - $cb) * $mix);
            $a = (int) (127 * (1.0 - $inten));
            imagesetpixel($im, $x, $y, ($a << 24) | ($r << 16) | ($g << 8) | $b);
        }
    }
    imagepng($im, $path);
}

puff("$dir/puff.png");
// tighter halo so the disc reads as a ball and does not wash out the screen
radial("$dir/sun.png",  0.34, 4.5, 255, 250, 225, 255, 150, 45);
radial("$dir/moon.png", 0.32, 5.0, 235, 240, 255, 130, 155, 220);

echo "Generated sky textures in $dir\n";
foreach (['puff', 'sun', 'moon'] as $f) {
    printf("  %-9s %d bytes\n", "$f.png", filesize("$dir/$f.png"));
}
