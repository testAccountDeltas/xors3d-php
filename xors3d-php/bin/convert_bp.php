<?php
/**
 * Offline converter: Axiom .bp blueprint -> compact JSON structure for Craft.
 * Run with 64-bit long support via GMP:
 *   phpx86\php.exe -d extension_dir=phpx86\ext -d extension=gmp convert_bp.php <in.bp> <out.json> <name>
 *
 * Output JSON: {"name":..,"w":..,"h":..,"d":..,"blocks":[[dx,dy,dz,typeId],...]}
 * where typeId maps to Craft's TYPES; coordinates are normalized to min corner (0,0,0).
 */
declare(strict_types=1);

// ---- NBT reader returning nested arrays -------------------------------------
class Nbt {
    private string $d; private int $p = 0;
    public function __construct(string $d) { $this->d = $d; }
    private function u1(): int { $v = ord($this->d[$this->p]); $this->p++; return $v; }
    private function i2(): int { $v = unpack('n', substr($this->d, $this->p, 2))[1]; $this->p += 2; return $v >= 0x8000 ? $v - 0x10000 : $v; }
    private function i4(): int { $v = unpack('N', substr($this->d, $this->p, 4))[1]; $this->p += 4; return $v >= 0x80000000 ? $v - 0x100000000 : $v; }
    private function f4(): float { $v = unpack('G', substr($this->d, $this->p, 4))[1]; $this->p += 4; return $v; }
    private function f8(): float { $v = unpack('E', substr($this->d, $this->p, 8))[1]; $this->p += 8; return $v; }
    private function str(): string { $n = $this->i2(); $s = substr($this->d, $this->p, $n); $this->p += $n; return $s; }
    /** raw 8-byte long as GMP */
    private function long(): \GMP { $hi = unpack('N', substr($this->d, $this->p, 4))[1]; $lo = unpack('N', substr($this->d, $this->p + 4, 4))[1]; $this->p += 8; return gmp_add(gmp_mul(gmp_init($hi), gmp_pow(2, 32)), gmp_init($lo)); }
    public function root(): array { $t = $this->u1(); $this->str(); return $this->payload($t); }
    private function payload(int $t) {
        switch ($t) {
            case 1: return $this->u1();
            case 2: return $this->i2();
            case 3: return $this->i4();
            case 4: return $this->long();
            case 5: return $this->f4();
            case 6: return $this->f8();
            case 7: $n = $this->i4(); $a = []; for ($i = 0; $i < $n; $i++) $a[] = $this->u1(); return $a;
            case 8: return $this->str();
            case 9: $it = $this->u1(); $n = $this->i4(); $a = []; for ($i = 0; $i < $n; $i++) $a[] = $this->payload($it); return $a;
            case 10: $a = []; while (true) { $tt = $this->u1(); if ($tt === 0) break; $nm = $this->str(); $a[$nm] = $this->payload($tt); } return $a;
            case 11: $n = $this->i4(); $a = []; for ($i = 0; $i < $n; $i++) $a[] = $this->i4(); return $a;
            case 12: $n = $this->i4(); $a = []; for ($i = 0; $i < $n; $i++) $a[] = $this->long(); return $a;
            default: throw new RuntimeException("bad tag $t at {$this->p}");
        }
    }
}

// ---- minecraft block name -> Craft type id ---------------------------------
function mapBlock(string $name): int {
    $n = preg_replace('/^minecraft:/', '', $name);
    // empty / non-solid cells -> skip ('air' but NOT 'stairs'!)
    if ($n === 'air' || str_ends_with($n, '_air') || $n === 'water' || $n === 'lava'
        || $n === 'barrier' || $n === 'light' || $n === 'structure_void' || $n === 'moving_piston') return 0;
    // lights first
    if (in_array($n, ['glowstone', 'sea_lantern', 'shroomlight', 'ochre_froglight', 'verdant_froglight', 'pearlescent_froglight', 'jack_o_lantern', 'redstone_lamp'], true)
        || str_contains($n, 'lantern') || str_contains($n, 'torch') || str_contains($n, 'campfire') || str_contains($n, 'candle') || str_contains($n, 'lamp')) return 11;
    if (str_contains($n, 'bookshelf')) return 19;
    if (str_contains($n, '_door') && !str_contains($n, 'trapdoor')) return 23; // openable door
    if (str_contains($n, 'chiseled_stone_brick')) return 22;
    if (str_contains($n, 'stone_brick') || str_contains($n, 'polished_blackstone_brick') || str_contains($n, 'deepslate_brick') || str_contains($n, 'deepslate_tile') || str_contains($n, 'nether_brick') || str_contains($n, 'quartz_brick') || str_contains($n, 'end_stone_brick') || str_contains($n, 'tuff_brick')) return 16;
    if ($n === 'bricks' || str_contains($n, 'brick_')) return 4;
    if (str_contains($n, 'cobble')) return 15;
    if (str_contains($n, 'bookshelf')) return 19;
    if (str_contains($n, 'glass')) return 10;
    if (str_contains($n, 'leaves')) return 7;
    if (str_contains($n, 'log') || str_contains($n, '_wood') || str_contains($n, 'stem') || str_contains($n, 'hyphae') || str_contains($n, 'bamboo_block')) return 8;
    // wools/carpets/beds -> red vs white-ish
    if (str_contains($n, 'wool') || str_contains($n, 'carpet') || str_contains($n, 'bed') || str_contains($n, 'terracotta') || str_contains($n, 'concrete')) {
        if (str_contains($n, 'red') || str_contains($n, 'pink') || str_contains($n, 'orange') || str_contains($n, 'magenta') || str_contains($n, 'crimson')) return 20;
        return 21;
    }
    // planks / wooden things -> oak vs dark
    if (str_contains($n, 'dark_oak') || str_contains($n, 'spruce') || str_contains($n, 'warped') || str_contains($n, 'crimson')) {
        if (str_contains($n, 'plank') || str_contains($n, 'stair') || str_contains($n, 'slab') || str_contains($n, 'fence') || str_contains($n, 'door') || str_contains($n, 'trapdoor') || str_contains($n, 'log') || str_contains($n, 'wood')) return 18;
    }
    if (str_contains($n, 'plank') || str_contains($n, '_stairs') || str_contains($n, '_slab') || str_contains($n, 'fence') || str_contains($n, '_door') || str_contains($n, 'trapdoor') || str_contains($n, 'sign') || str_contains($n, 'barrel') || str_contains($n, 'chest') || str_contains($n, 'crafting') || str_contains($n, 'ladder') || str_contains($n, 'scaffolding') || str_contains($n, 'lectern') || str_contains($n, 'loom') || str_contains($n, 'table')) {
        // wooden stairs/slabs of light woods and generic -> oak planks
        if (str_contains($n, 'stone') || str_contains($n, 'cobble') || str_contains($n, 'brick')) return 16;
        return 17;
    }
    if (str_contains($n, 'sand') && !str_contains($n, 'sandstone')) return 9;
    if (str_contains($n, 'sandstone')) return 9;
    if (str_contains($n, 'snow') || str_contains($n, 'ice')) return 6;
    if (str_contains($n, 'grass_block') || $n === 'moss_block' || str_contains($n, 'grass_path') || str_contains($n, 'dirt_path')) return 1;
    if (str_contains($n, 'dirt') || str_contains($n, 'mud') || str_contains($n, 'clay') || str_contains($n, 'gravel') || str_contains($n, 'podzol') || str_contains($n, 'farmland')) return 2;
    if (str_contains($n, 'diamond_ore')) return 12;
    if (str_contains($n, 'coal_ore')) return 13;
    if (str_contains($n, 'iron_ore')) return 14;
    // stones and everything solid unknown -> stone
    if (str_contains($n, 'stone') || str_contains($n, 'andesite') || str_contains($n, 'granite') || str_contains($n, 'diorite') || str_contains($n, 'deepslate') || str_contains($n, 'blackstone') || str_contains($n, 'basalt') || str_contains($n, 'tuff') || str_contains($n, 'quartz') || str_contains($n, 'prismarine') || str_contains($n, 'copper')) return 3;
    // decorative plants, rails, buttons, pressure plates, redstone, flowers -> skip
    if (str_contains($n, 'flower') || str_contains($n, 'sapling') || str_contains($n, 'grass') || str_contains($n, 'fern') || str_contains($n, 'rail') || str_contains($n, 'button') || str_contains($n, 'pressure') || str_contains($n, 'redstone') || str_contains($n, 'vine') || str_contains($n, 'lily') || str_contains($n, 'mushroom') || str_contains($n, 'pane') || str_contains($n, 'wall_torch') || str_contains($n, 'pot') || str_contains($n, 'banner') || str_contains($n, 'painting') || str_contains($n, 'item_frame') || str_contains($n, 'cobweb') || str_contains($n, 'string')) return 0;
    // fallback: treat unknown solids as stone bricks (buildings)
    return 16;
}

// ---- decode -----------------------------------------------------------------
[$in, $out, $niceName] = [$argv[1], $argv[2], $argv[3] ?? 'structure'];
$d = file_get_contents($in);
$metaLen = unpack('N', substr($d, 4, 4))[1];
$start = 8 + $metaLen;
$thumbLen = unpack('N', substr($d, $start, 4))[1];
$after = $start + 4 + $thumbLen;
$blockLen = unpack('N', substr($d, $after, 4))[1];
$nbt = gzdecode(substr($d, $after + 4, $blockLen));
$root = (new Nbt($nbt))->root();

$blocks = [];   // "x,y,z" => typeId
$skipped = [];
foreach ($root['BlockRegion'] as $sec) {
    $sx = $sec['X'] * 16; $sy = $sec['Y'] * 16; $sz = $sec['Z'] * 16;
    $pal = $sec['BlockStates']['palette'];
    $names = array_map(fn($e) => $e['Name'], $pal);
    $count = count($names);
    $data = $sec['BlockStates']['data'] ?? [];
    $bits = max(4, (int) ceil(log($count, 2)));
    if ($count <= 1) { // whole section is palette[0]; if it's air skip
        $t = mapBlock($names[0]);
        if ($t === 0) continue;
        for ($i = 0; $i < 4096; $i++) { $x = $i & 15; $z = ($i >> 4) & 15; $y = ($i >> 8) & 15; $blocks[($sx+$x).','.($sy+$y).','.($sz+$z)] = $t; }
        continue;
    }
    $perLong = intdiv(64, $bits);
    $mask = gmp_sub(gmp_pow(2, $bits), 1);
    for ($i = 0; $i < 4096; $i++) {
        $li = intdiv($i, $perLong); $within = $i % $perLong;
        if (!isset($data[$li])) { continue; }
        $idx = gmp_intval(gmp_and(gmp_div_q($data[$li], gmp_pow(2, $within * $bits)), $mask));
        if ($idx < 0 || $idx >= $count) { continue; }
        $t = mapBlock($names[$idx]);
        if ($t === 0) { $skipped[$names[$idx]] = ($skipped[$names[$idx]] ?? 0) + 1; continue; }
        $x = $i & 15; $z = ($i >> 4) & 15; $y = ($i >> 8) & 15;
        $blocks[($sx+$x).','.($sy+$y).','.($sz+$z)] = $t;
    }
}

// normalize to min corner
$minx = $miny = $minz = PHP_INT_MAX; $maxx = $maxy = $maxz = PHP_INT_MIN;
foreach ($blocks as $k => $t) { [$x,$y,$z] = array_map('intval', explode(',', $k)); $minx=min($minx,$x);$miny=min($miny,$y);$minz=min($minz,$z);$maxx=max($maxx,$x);$maxy=max($maxy,$y);$maxz=max($maxz,$z); }
$out_blocks = [];
foreach ($blocks as $k => $t) { [$x,$y,$z] = array_map('intval', explode(',', $k)); $out_blocks[] = [$x-$minx, $y-$miny, $z-$minz, $t]; }

$json = [ 'name' => $niceName, 'w' => $maxx-$minx+1, 'h' => $maxy-$miny+1, 'd' => $maxz-$minz+1, 'blocks' => $out_blocks ];
file_put_contents($out, json_encode($json));
printf("%s: %d blocks, size %dx%dx%d -> %s (%d bytes)\n", $niceName, count($out_blocks), $json['w'], $json['h'], $json['d'], $out, filesize($out));
if ($skipped) { arsort($skipped); printf("  skipped(top): %s\n", implode(', ', array_slice(array_map(fn($k,$v)=>"$k=$v", array_keys($skipped), $skipped), 0, 8))); }
