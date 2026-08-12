<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;

/**
 * Chunk meshing + streaming for the Craft voxel game: the greedy mesher (with
 * baked skylight vertex colours), per-chunk build, the budgeted load/rebuild
 * queue (no hitches) and fog/render-distance. Mixed into MinecraftController.
 */
trait Chunks
{
    private function spawnWater(int $ck0x, int $x, int $z, array &$list): void
    {
        $e = $this->e;
        $w = $e->xCopyEntity($this->waterTpl);
        $e->xPositionEntity($w, $x * self::BLOCK, self::SEA * self::BLOCK, $z * self::BLOCK);
        $this->water[$w] = true;
        $list[] = $w;
    }

    // ------------------------------------------------ greedy chunk meshing

    /**
     * Greedy mesher: merges coplanar, same-type exposed faces into large quads,
     * dramatically cutting vertex/triangle count vs one quad per block face.
     */
    private function greedyMesh(int $mesh, int $x0, int $z0, int $yMax): void
    {
        $e = $this->e; $B = self::BLOCK;
        $dims = [self::CH, $yMax + 1, self::CH];
        $off  = [$x0, 0, $z0];
        $surf = [];
        $snowTop = $this->snowOn; // render upward ground faces as snow while it lies
        $aoOn = (int) ($this->settings['aoshade'] ?? 1); // bake ambient occlusion into vertex colours

        // Sample the whole chunk volume (with a 1-cell border) ONCE into a flat array,
        // then read from it below. solidType() is comparatively expensive (edits lookup +
        // per-cell cave 3D-noise = 8 sin calls); the mesher would otherwise query each
        // cell up to 6x (as a neighbour from every face direction), re-running that noise
        // each time. Sampling once removes those redundant calls - the big win against
        // the micro-freeze when a chunk builds mid-flight.
        $xmin = $x0 - 1; $ymin = -1; $zmin = $z0 - 1;
        $nyv = ($yMax + 1) - $ymin + 1; $nzv = ($z0 + self::CH) - $zmin + 1;
        $vol = [];
        $vi = 0;
        for ($vx = $xmin; $vx <= $x0 + self::CH; $vx++) {
            for ($vy = $ymin; $vy <= $yMax + 1; $vy++) {
                for ($vz = $zmin; $vz <= $z0 + self::CH; $vz++) {
                    $vol[$vi++] = $this->solidType($vx, $vy, $vz);
                }
            }
        }
        $st = static function (int $x, int $y, int $z) use ($vol, $xmin, $ymin, $zmin, $nyv, $nzv): int {
            return $vol[(($x - $xmin) * $nyv + ($y - $ymin)) * $nzv + ($z - $zmin)];
        };

        // Baked light is split into two parts so the block shader can treat them
        // differently: SKYLIGHT (open sky vs shadow) modulates the day/night lit surface,
        // while TORCH glow is EMISSIVE - it must add regardless of time of day, otherwise
        // building lights vanish at night when the ambient term is low. Skylight goes in the
        // vertex RGB; torch emission goes in the vertex ALPHA (read as emissive by the shader).
        $colTop = [];
        $topOf = function (int $ax, int $az) use (&$colTop): int {
            $k = "$ax,$az";
            return $colTop[$k] ??= $this->groundTop($ax, $az);
        };
        $lightOf = function (int $ax, int $ay, int $az) use ($topOf): int {
            return ($ay > $topOf($ax, $az)) ? 255 : 77;      // skylight: open sky vs shadowed
        };
        $emitOf = function (int $ax, int $ay, int $az, int $ftype): int {
            if ($ftype === 11) { return 255; }               // glowstone block face glows fully
            $bl = $this->blockLite["$ax,$ay,$az"] ?? 0.0;    // baked torch/glowstone glow field
            return $bl > 0.0 ? (int) ($bl * 255) : 0;
        };

        for ($d = 0; $d < 3; $d++) {
            $u = ($d + 1) % 3; $v = ($d + 2) % 3;
            $dd = $dims[$d]; $du = $dims[$u]; $dv = $dims[$v];
            $mask = array_fill(0, $du * $dv, 0);
            $lite = array_fill(0, $du * $dv, 255); // skylight visibility per face
            $emsk = array_fill(0, $du * $dv, 0);   // torch emissive per face (0..255)
            $aomk = array_fill(0, $du * $dv, 0xFF); // packed 4-corner AO (2 bits each), 0xFF = no occlusion

            // ambient-occlusion of one vertex from its two edge neighbours + diagonal corner
            // (Minecraft's classic 0..3 term: darker where blocks meet in a concave corner).
            $vAO = static fn (bool $s1, bool $s2, bool $co): int => ($s1 && $s2) ? 0 : 3 - ((int) $s1 + (int) $s2 + (int) $co);

            for ($xd = -1; $xd < $dd; $xd++) {
                // build the face mask for this slice
                $n = 0;
                for ($xv = 0; $xv < $dv; $xv++) {
                    for ($xu = 0; $xu < $du; $xu++) {
                        $pa = [0, 0, 0]; $pa[$d] = $xd; $pa[$u] = $xu; $pa[$v] = $xv;
                        $ax = $off[0] + $pa[0]; $ay = $off[1] + $pa[1]; $az = $off[2] + $pa[2];
                        $a = $st($ax, $ay, $az);
                        $pb = $pa; $pb[$d] = $xd + 1;
                        $bx = $off[0] + $pb[0]; $by = $off[1] + $pb[1]; $bz = $off[2] + $pb[2];
                        $b = $st($bx, $by, $bz);
                        // glass (10) is transparent: it never hides the block behind it, so
                        // its neighbours still draw their faces and you can see through windows.
                        $oa = ($a > 0 && $a !== 10);   // a is opaque
                        $ob = ($b > 0 && $b !== 10);   // b is opaque
                        $mv = 0; $lv = 255; $ev = 0;
                        if ($oa && $ob) { $mv = 0; }                        // both opaque: hidden
                        elseif ($oa)    { $mv = ($snowTop && $d === 1 && $this->coverable($a)) ? 6 : $a; $lv = $lightOf($bx, $by, $bz); $ev = $emitOf($bx, $by, $bz, $a); }
                        elseif ($ob)    { $mv = -$b; $lv = $lightOf($ax, $ay, $az); $ev = $emitOf($ax, $ay, $az, $b); }
                        elseif ($a === 10 && $b !== 10) { $mv = $a;  $lv = $lightOf($bx, $by, $bz); $ev = $emitOf($bx, $by, $bz, 10); }
                        elseif ($b === 10 && $a !== 10) { $mv = -$b; $lv = $lightOf($ax, $ay, $az); $ev = $emitOf($ax, $ay, $az, 10); }
                        $mask[$n] = $mv; $lite[$n] = $lv; $emsk[$n] = $ev;

                        // per-corner AO from the neighbours on the exposed (air) side of the face
                        if ($mv !== 0 && $aoOn) {
                            $air = ($mv > 0) ? $pb : $pa; // air-side cell (the face is exposed to it)
                            $oc = function (int $do, int $vo) use ($st, $off, $u, $v, $air): bool {
                                $p = $air; $p[$u] += $do; $p[$v] += $vo;
                                $t = $st($off[0] + $p[0], $off[1] + $p[1], $off[2] + $p[2]);
                                return $t > 0 && $t !== 10;
                            };
                            $um = $oc(-1, 0); $up = $oc(1, 0); $vm = $oc(0, -1); $vp = $oc(0, 1);
                            $ao0 = $vAO($um, $vm, $oc(-1, -1)); // (-u,-v)
                            $ao1 = $vAO($up, $vm, $oc(1, -1));  // (+u,-v)
                            $ao2 = $vAO($up, $vp, $oc(1, 1));   // (+u,+v)
                            $ao3 = $vAO($um, $vp, $oc(-1, 1));  // (-u,+v)
                            $aomk[$n] = $ao0 | ($ao1 << 2) | ($ao2 << 4) | ($ao3 << 6);
                        }
                        $n++;
                    }
                }
                // greedy-merge the mask into quads
                $n = 0;
                for ($j = 0; $j < $dv; $j++) {
                    $i = 0;
                    while ($i < $du) {
                        $c = $mask[$n + $i];
                        if ($c === 0) { $i++; continue; }
                        $lc = $lite[$n + $i];   // merge only faces with the same light, emit AND AO,
                        $ec = $emsk[$n + $i];   // so a merged quad's corner shading stays uniform
                        $ac = $aomk[$n + $i];
                        $w = 1;
                        while ($i + $w < $du && $mask[$n + $i + $w] === $c && $lite[$n + $i + $w] === $lc && $emsk[$n + $i + $w] === $ec && $aomk[$n + $i + $w] === $ac) { $w++; }
                        $hgt = 1; $stop = false;
                        while ($j + $hgt < $dv) {
                            for ($k = 0; $k < $w; $k++) {
                                $m = $n + $i + $k + $hgt * $du;
                                if ($mask[$m] !== $c || $lite[$m] !== $lc || $emsk[$m] !== $ec || $aomk[$m] !== $ac) { $stop = true; break; }
                            }
                            if ($stop) { break; }
                            $hgt++;
                        }

                        $type = abs($c);
                        if (!isset($surf[$type])) { $surf[$type] = $e->xCreateSurface($mesh, $this->brush[$type]); }
                        $s = $surf[$type];

                        $plane = ($off[$d] + $xd + 0.5) * $B;      // face boundary plane
                        $u0 = ($off[$u] + $i - 0.5) * $B;  $u1 = ($off[$u] + $i + $w - 0.5) * $B;
                        $v0 = ($off[$v] + $j - 0.5) * $B;  $v1 = ($off[$v] + $j + $hgt - 0.5) * $B;

                        $corner = static function (float $uc, float $vc) use ($d, $u, $v, $plane): array {
                            $p = [0.0, 0.0, 0.0]; $p[$d] = $plane; $p[$u] = $uc; $p[$v] = $vc; return $p;
                        };
                        $c0 = $corner($u0, $v0); $c1 = $corner($u1, $v0);
                        $c2 = $corner($u1, $v1); $c3 = $corner($u0, $v1);
                        $a0 = $e->xAddVertex($s, $c0[0], $c0[1], $c0[2], 0, 0);
                        $a1 = $e->xAddVertex($s, $c1[0], $c1[1], $c1[2], $w, 0);
                        $a2 = $e->xAddVertex($s, $c2[0], $c2[1], $c2[2], $w, $hgt);
                        $a3 = $e->xAddVertex($s, $c3[0], $c3[1], $c3[2], 0, $hgt);
                        // explicit outward normal (avoids winding-dependent dark faces)
                        $nrm = [0.0, 0.0, 0.0]; $nrm[$d] = ($c > 0) ? 1.0 : -1.0;
                        // Directional face shading (top brightest, sides dimmer, bottom darkest):
                        // this is what makes plain cubes read as 3D under vertex-colour lighting.
                        // With the per-pixel block shader on, the shader does smooth directional
                        // lighting instead, so we bake a flat 1.0 here (AO/skylight/torch stay).
                        if ($this->blockShade) { $dir = 1.0; }
                        elseif ($d === 1)  { $dir = ($c > 0) ? 1.0 : 0.5; } // +Y top / -Y bottom
                        elseif ($d === 2)  { $dir = 0.8; }                  // Z sides
                        else               { $dir = 0.62; }                 // X sides
                        // per-corner colour = baked skylight * face direction * ambient occlusion
                        $aoF = [
                            0.55 + 0.15 * ($ac & 3),
                            0.55 + 0.15 * (($ac >> 2) & 3),
                            0.55 + 0.15 * (($ac >> 4) & 3),
                            0.55 + 0.15 * (($ac >> 6) & 3),
                        ];
                        // Shader mode: RGB carries skylight only, torch emission goes in a
                        // second uv set (NOT vertex alpha - the chunk mesh's alpha would make
                        // the block see-through). Fallback mode: fold torch glow into RGB.
                        $shade = $this->blockShade;
                        $base = $shade ? $lc : max($lc, $ec);
                        $emitF = $ec / 255.0;
                        $verts = [$a0, $a1, $a2, $a3];
                        foreach ($verts as $ci => $vi) {
                            $cv = (int) min(255.0, $base * $dir * $aoF[$ci]);
                            $e->xVertexNormal($s, $vi, $nrm[0], $nrm[1], $nrm[2]);
                            $e->xVertexColor($s, $vi, $cv, $cv, $cv);
                            if ($shade) { $e->xVertexTexCoords($s, $vi, $emitF, 0.0, 1.0, 1); } // emit in uv set 1
                        }
                        // both windings so the face is never culled from the outside,
                        // regardless of per-axis chirality (backface culling keeps one)
                        $e->xAddTriangle($s, $a0, $a1, $a2);
                        $e->xAddTriangle($s, $a0, $a2, $a3);
                        $e->xAddTriangle($s, $a0, $a2, $a1);
                        $e->xAddTriangle($s, $a0, $a3, $a2);

                        for ($l = 0; $l < $hgt; $l++) {
                            for ($k = 0; $k < $w; $k++) { $mask[$n + $i + $k + $l * $du] = 0; }
                        }
                        $i += $w;
                    }
                    $n += $du;
                }
            }
        }
        // remember whether this mesh has glass (type 10) so the shader can pick the fast
        // no-clip technique for the opaque majority (keeps early-Z under overdraw).
        $this->meshHasGlass = isset($surf[10]);
    }

    /** Build (or rebuild) one chunk as a single greedy-merged mesh + water. */
    /**
     * Bake a block-light field for the chunk region: each glowstone splats a radial
     * falloff (through-walls, cheap) into $this->blockLite. Used by the mesher to make
     * torch-lit faces bright in the vertex colours - persistent glow independent of the
     * runtime point-light count, so building lights never blink out as you walk away.
     */
    private function bakeBlockLite(int $x0, int $z0): void
    {
        $this->blockLite = [];
        $R = 5; // splat radius: R^3 grows fast, so 5 (vs 7) roughly thirds the bake cost near
                // lamp-dense areas (plaza/castle) while keeping a soft torch glow.
        // Precompute the radial falloff kernel ONCE (offset + intensity for every cell
        // within R): each light source is then just a cheap splat with no per-cell sqrt.
        static $kernel = null;
        if ($kernel === null) {
            $kernel = [];
            for ($dx = -$R; $dx <= $R; $dx++) {
                for ($dy = -$R; $dy <= $R; $dy++) {
                    for ($dz = -$R; $dz <= $R; $dz++) {
                        $d = sqrt($dx * $dx + $dy * $dy + $dz * $dz);
                        if ($d > $R) { continue; }
                        $kernel[] = [$dx, $dy, $dz, 1.0 - $d / $R];
                    }
                }
            }
        }
        $xmin = $x0 - $R; $xmax = $x0 + self::CH - 1 + $R;
        $zmin = $z0 - $R; $zmax = $z0 + self::CH - 1 + $R;
        foreach ($this->lightCells as [$gx, $gy, $gz]) {
            if ($gx < $xmin || $gx > $xmax || $gz < $zmin || $gz > $zmax) { continue; }
            foreach ($kernel as [$dx, $dy, $dz, $v]) {
                $k = ($gx + $dx) . ',' . ($gy + $dy) . ',' . ($gz + $dz);
                if (!isset($this->blockLite[$k]) || $this->blockLite[$k] < $v) { $this->blockLite[$k] = $v; }
            }
        }
    }

    /**
     * Generate a chunk's trees + procedural buildings into the edit overlay ONCE (no
     * meshing). Kept separate from buildChunkMesh so the streamer can do generation on one
     * frame and meshing on the next - never both for the same chunk in a single frame,
     * which is what caused the residual hitch when flying into fresh, structure-bearing land.
     */
    private function ensureGen(int $cx, int $cz): void
    {
        $ck = "$cx,$cz";
        if (isset($this->treeGen[$ck])) { return; }
        $e = $this->e;
        $this->treeGen[$ck] = true;
        // trees + buildings write edits that can spill into neighbour chunks; track them so
        // already-built neighbours get rebuilt (no missing canopies / half-built structures).
        $this->trackSpill = true; $this->treeSpill = [];
        $this->genStructures($cx, $cz);
        $this->genTrees($cx, $cz);
        $this->trackSpill = false;

        foreach (array_keys($this->treeSpill) as $nk) {
            if ($nk === $ck) { continue; }
            if (isset($this->chunkCache[$nk])) {
                // a cached (hidden) neighbour received spilled blocks -> its mesh is stale;
                // drop it so it rebuilds fresh the next time it loads
                foreach ($this->chunkCache[$nk] as $h) { unset($this->meshCk[$h], $this->water[$h]); $e->xFreeEntity($h); }
                unset($this->chunkCache[$nk], $this->chunk[$nk], $this->chunkMesh[$nk]);
                continue;
            }
            // queue (don't synchronously rebuild) already-built neighbours -> rebuildQ drains
            // a few per frame, so a big blueprint's border faces fill in without a freeze
            if (isset($this->loaded[$nk]) && isset($this->chunkMesh[$nk])) { $this->rebuildQ[$nk] = true; }
        }
    }

    private function buildChunkMesh(int $cx, int $cz): void
    {
        $e = $this->e;
        $ck = "$cx,$cz";
        $this->ensureGen($cx, $cz); // no-op if already generated (streamer usually gens earlier)

        foreach ($this->chunk[$ck] ?? [] as $h) {
            unset($this->meshCk[$h], $this->water[$h]);
            $e->xFreeEntity($h);
        }
        $this->chunk[$ck] = [];

        $x0 = $cx * self::CH; $z0 = $cz * self::CH;
        $yMax = 0;
        for ($x = $x0; $x < $x0 + self::CH; $x++) {
            for ($z = $z0; $z < $z0 + self::CH; $z++) {
                if ($this->heightAt($x, $z) > $yMax) { $yMax = $this->heightAt($x, $z); }
            }
        }
        foreach ($this->editsByChunk[$ck] ?? [] as $k => $t) {
            if ($t > 0) { $y = (int) explode(',', $k)[1]; if ($y > $yMax) { $yMax = $y; } }
        }
        $yMax = min(self::Y_MAX, $yMax);

        $this->bakeBlockLite($x0, $z0);            // glowstone glow baked into vertex colours
        $mesh = $e->xCreateMesh();
        $this->greedyMesh($mesh, $x0, $z0, $yMax); // sets its own vertex normals + double winding
        if ($this->blockShade) {
            $this->attachBlockFX($mesh);                 // per-pixel soft lighting shader
        } else {
            $e->xEntityFX($mesh, Constants::FX_VERTEXCOLOR); // fallback: baked vertex colours
        }
        $e->xEntityPickMode($mesh, 2);

        $list = [];
        if ((int) $this->settings['water']) {
            for ($x = $x0; $x < $x0 + self::CH; $x++) {
                for ($z = $z0; $z < $z0 + self::CH; $z++) {
                    if ($this->heightAt($x, $z) < self::SEA) { $this->spawnWater($cx, $x, $z, $list); }
                }
            }
        }

        $this->chunkMesh[$ck] = $mesh;
        $this->meshCk[$mesh] = $ck;
        $this->chunk[$ck] = array_merge([$mesh], $list);
    }

    private function loadChunk(int $cx, int $cz): void
    {
        $ck = "$cx,$cz";
        if (isset($this->loaded[$ck])) { return; }
        // Reuse a previously-built mesh kept hidden in the cache (backtracking): just show it
        // again - no re-mesh, no gen. This is the "chunk reuse" that avoids rebuilding chunks
        // you already visited when you fly back into them.
        if (isset($this->chunkCache[$ck])) {
            $e = $this->e;
            foreach ($this->chunkCache[$ck] as $h) { $e->xShowEntity($h); }
            unset($this->chunkCache[$ck]);
            $this->loaded[$ck] = true;
            // refresh shader lighting on the revealed mesh (its constants went stale while hidden)
            if ($this->blockShade && isset($this->chunkMesh[$ck])) { $this->applyBlockFXConsts($this->chunkMesh[$ck]); }
            return;
        }
        $this->loaded[$ck] = true;
        $this->buildChunkMesh($cx, $cz);
    }

    private function rebuildChunk(int $cx, int $cz): void
    {
        $ck = "$cx,$cz";
        if (isset($this->loaded[$ck])) { $this->buildChunkMesh($cx, $cz); return; }
        // not loaded but cached (hidden): its mesh is now stale -> drop so it rebuilds on return
        if (isset($this->chunkCache[$ck])) {
            $e = $this->e;
            foreach ($this->chunkCache[$ck] as $h) { unset($this->meshCk[$h], $this->water[$h]); $e->xFreeEntity($h); }
            unset($this->chunkCache[$ck], $this->chunk[$ck], $this->chunkMesh[$ck]);
        }
    }

    /** Free every cached (hidden) chunk mesh. Called when the whole world's look changes
     *  (snow settle/melt) or on world reset, so no stale chunk is ever shown again. */
    private function clearChunkCache(): void
    {
        $e = $this->e;
        foreach ($this->chunkCache as $ck => $list) {
            foreach ($list as $h) { unset($this->meshCk[$h], $this->water[$h]); $e->xFreeEntity($h); }
            unset($this->chunk[$ck], $this->chunkMesh[$ck]);
        }
        $this->chunkCache = [];
    }

    /** Queue every loaded chunk for a rebuild (snow settle/melt), spread over frames. */
    private function remeshLoaded(): void
    {
        $this->clearChunkCache(); // cached chunks hold the old snow state; drop them
        foreach (array_keys($this->loaded) as $ck) { $this->rebuildQ[$ck] = true; }
    }

    private function unloadChunk(int $cx, int $cz): void
    {
        $ck = "$cx,$cz";
        if (!isset($this->loaded[$ck])) { return; }
        $e = $this->e;
        // Don't destroy the mesh - hide it and keep it in an LRU cache so returning here is
        // free (no rebuild). Entities/handles (mesh + water) stay valid; they're just not
        // drawn. Only when the cache overflows do the oldest chunks get truly freed.
        foreach ($this->chunk[$ck] ?? [] as $h) { $e->xHideEntity($h); }
        unset($this->chunkCache[$ck]);                     // refresh LRU position
        $this->chunkCache[$ck] = $this->chunk[$ck] ?? [];
        unset($this->loaded[$ck]);

        while (count($this->chunkCache) > self::CHUNK_CACHE_MAX) {
            $old = array_key_first($this->chunkCache);
            foreach ($this->chunkCache[$old] as $h) {
                unset($this->meshCk[$h], $this->water[$h]);
                $e->xFreeEntity($h);
            }
            unset($this->chunkCache[$old], $this->chunk[$old], $this->chunkMesh[$old]);
        }
    }

    /**
     * Decide which chunks are wanted around ($wx,$wz): queue missing ones for budgeted
     * loading and unload the far ones. The actual mesh building is drained a few chunks
     * per frame by {@see processStreaming()} so crossing a chunk border never builds a
     * whole ring in one frame (which caused brief freezes despite high average FPS).
     */
    private function updateStreaming(float $wx, float $wz): void
    {
        $pcx = $this->cdiv($this->cellOf($wx));
        $pcz = $this->cdiv($this->cellOf($wz));
        if ($pcx === $this->streamCX && $pcz === $this->streamCZ) { return; }
        $this->streamCX = $pcx; $this->streamCZ = $pcz;

        $r = (int) ceil(((int) $this->settings['renderDist']) / self::CH);
        $u = $r + 1;

        for ($cx = $pcx - $r; $cx <= $pcx + $r; $cx++) {
            for ($cz = $pcz - $r; $cz <= $pcz + $r; $cz++) {
                $ck = "$cx,$cz";
                if (!isset($this->loaded[$ck])) { $this->loadQ[$ck] = true; }
            }
        }
        // drop queued chunks that drifted out of range, and unload far loaded chunks
        foreach (array_keys($this->loadQ) as $ck) {
            [$cx, $cz] = explode(',', $ck);
            if (abs((int) $cx - $pcx) > $u || abs((int) $cz - $pcz) > $u) { unset($this->loadQ[$ck]); }
        }
        foreach (array_keys($this->loaded) as $ck) {
            [$cx, $cz] = explode(',', $ck);
            if (abs((int) $cx - $pcx) > $u || abs((int) $cz - $pcz) > $u) {
                $this->unloadChunk((int) $cx, (int) $cz);
            }
        }
    }

    /**
     * Build up to $load queued chunks (nearest to the player first) and rebuild up to
     * $rebuild pending chunks this frame. In addition to the count caps, the work is
     * TIME-budgeted: once ~6ms of chunk work has been spent this call, it stops early and
     * leaves the rest for the next frame. Chunk cost varies wildly (an empty plains chunk
     * is cheap; one carrying a tall blueprint is not), so a fixed count would still let two
     * heavy chunks land in one frame and stutter. The time budget bounds the per-frame cost
     * regardless of how heavy the individual chunks are. flushStreaming() passes big counts
     * (>=32) which disables the budget so menus/screenshots can drain everything at once.
     */
    private function processStreaming(int $load, int $rebuild): void
    {
        $budgeted = ($load < 32 && $rebuild < 32);
        $deadline = $budgeted ? microtime(true) + 0.006 : PHP_FLOAT_MAX;

        if ($this->loadQ !== [] && $load > 0) {
            $pcx = $this->streamCX; $pcz = $this->streamCZ;
            $keys = array_keys($this->loadQ);
            usort($keys, function (string $a, string $b) use ($pcx, $pcz): int {
                [$ax, $az] = explode(',', $a); [$bx, $bz] = explode(',', $b);
                $da = ((int) $ax - $pcx) ** 2 + ((int) $az - $pcz) ** 2;
                $db = ((int) $bx - $pcx) ** 2 + ((int) $bz - $pcz) ** 2;
                return $da <=> $db;
            });
            $built = 0;
            foreach ($keys as $ck) {
                if ($load-- <= 0) { break; }
                if ($built > 0 && microtime(true) >= $deadline) { break; } // spent our slice; always do >=1
                if (isset($this->loaded[$ck])) { unset($this->loadQ[$ck]); continue; }
                [$cx, $cz] = explode(',', $ck); $cx = (int) $cx; $cz = (int) $cz;
                // Generation and meshing are split across frames: if this chunk (or nearby
                // land it depends on) isn't generated yet, generate it now and leave it queued
                // - it meshes on a later frame. This keeps a heavy blueprint's generation and
                // its (tall) mesh out of the same frame.
                if (!isset($this->chunkCache[$ck]) && !isset($this->treeGen[$ck])) {
                    $this->ensureGen($cx, $cz);
                    $built++;
                    continue; // stays in loadQ -> meshed next frame
                }
                unset($this->loadQ[$ck]);
                $this->loadChunk($cx, $cz);
                $built++;
            }
        }
        if ($this->rebuildQ !== [] && $rebuild > 0) {
            $rb = 0;
            foreach (array_keys($this->rebuildQ) as $ck) {
                if ($rebuild-- <= 0) { break; }
                if ($rb > 0 && microtime(true) >= $deadline) { break; } // stay inside the frame budget
                unset($this->rebuildQ[$ck]);
                if (isset($this->loaded[$ck])) {
                    [$cx, $cz] = explode(',', $ck);
                    $this->buildChunkMesh((int) $cx, (int) $cz);
                    $rb++;
                }
            }
        }
    }

    /** Drain the whole load/rebuild queue now (menu backdrop, screenshots). */
    private function flushStreaming(): void
    {
        while ($this->loadQ !== [] || $this->rebuildQ !== []) {
            $this->processStreaming(64, 64);
        }
    }

    private function applyRenderDist(): void
    {
        $d = (int) $this->settings['renderDist'] * self::BLOCK;
        // Chunks stream in out to ~d. The fog must reach full opacity a little BEFORE
        // that boundary so chunks load/unload hidden inside the haze (no visible
        // pop-in), while still leaving most of the render distance crisp. Raise the
        // Render distance slider for a bigger clear area (you have the FPS for it).
        $this->e->xCameraRange($this->camH, 0.2, $d * 1.04);
        // thin haze only at the far edge: crisp across ~85% of the view, fog reaches full
        // opacity just before the chunk-unload boundary so pop-in stays hidden (free -
        // no change to render distance or chunk work).
        $this->e->xCameraFogRange($this->camH, $d * 0.85, $d * 0.98);
        $this->streamCX = PHP_INT_MAX; // force a streaming refresh
        $this->streamCZ = PHP_INT_MAX;
    }

}
