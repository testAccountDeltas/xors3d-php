<?php

declare(strict_types=1);

/**
 * Generates the game's sound effects as small 16-bit PCM WAV files.
 * Run once:  ..\phpx86\php.exe bin\gen_sounds.php
 * Output:    assets/sounds/{break,place,step,ambient}.wav
 *
 * Everything is synthesized (no external assets / licensing).
 */

$dir = dirname(__DIR__) . '/assets/sounds';
@mkdir($dir, 0777, true);

const SR = 22050;

function writeWav(string $path, array $samples): void
{
    $data = '';
    foreach ($samples as $s) {
        $v = (int) max(-32768, min(32767, (int) round($s * 32767)));
        $data .= pack('v', $v & 0xFFFF);
    }
    $n = strlen($data);
    $hdr = 'RIFF' . pack('V', 36 + $n) . 'WAVE'
         . 'fmt ' . pack('V', 16) . pack('v', 1) . pack('v', 1)
         . pack('V', SR) . pack('V', SR * 2) . pack('v', 2) . pack('v', 16)
         . 'data' . pack('V', $n);
    file_put_contents($path, $hdr . $data);
}

/** one-pole low-pass smoothing */
function lowpass(array $x, float $a): array
{
    $y = []; $p = 0.0;
    foreach ($x as $v) { $p += $a * ($v - $p); $y[] = $p; }
    return $y;
}

mt_srand(1234);

// --- break: filtered noise burst with fast decay ---
$len = (int) (SR * 0.18); $b = [];
for ($i = 0; $i < $len; $i++) {
    $env = exp(-$i / ($len * 0.25));
    $b[] = (mt_rand() / mt_getrandmax() * 2 - 1) * $env;
}
$b = lowpass($b, 0.35);
writeWav("$dir/break.wav", $b);

// --- place: short high tick ---
$len = (int) (SR * 0.06); $p = [];
for ($i = 0; $i < $len; $i++) {
    $env = exp(-$i / ($len * 0.2));
    $p[] = 0.5 * sin(2 * M_PI * 1400 * $i / SR) * $env
         + 0.2 * (mt_rand() / mt_getrandmax() * 2 - 1) * $env;
}
writeWav("$dir/place.wav", $p);

// --- step: low thud ---
$len = (int) (SR * 0.12); $s = [];
for ($i = 0; $i < $len; $i++) {
    $env = exp(-$i / ($len * 0.3));
    $s[] = 0.6 * sin(2 * M_PI * 90 * $i / SR) * $env
         + 0.25 * (mt_rand() / mt_getrandmax() * 2 - 1) * $env;
}
$s = lowpass($s, 0.5);
writeWav("$dir/step.wav", $s);

// --- ambient: gentle looping wind (heavily filtered noise + slow gusts) ---
$len = (int) (SR * 6.0); $raw = [];
for ($i = 0; $i < $len; $i++) {
    $raw[] = mt_rand() / mt_getrandmax() * 2 - 1;
}
$w = lowpass(lowpass($raw, 0.02), 0.02);
// normalize
$max = 0.0001;
foreach ($w as $v) { $max = max($max, abs($v)); }
$amb = [];
for ($i = 0; $i < $len; $i++) {
    $gust = 0.55 + 0.45 * sin(2 * M_PI * $i / $len)              // one gust per loop (seamless)
          + 0.15 * sin(2 * M_PI * 3 * $i / $len);
    $amb[] = ($w[$i] / $max) * 0.5 * $gust;
}
writeWav("$dir/ambient.wav", $amb);

echo "Generated 4 WAV files in $dir\n";
foreach (['break', 'place', 'step', 'ambient'] as $f) {
    printf("  %-12s %d bytes\n", "$f.wav", filesize("$dir/$f.wav"));
}
