<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Engine;

/**
 * World data + operations for the Craft voxel game: the edit overlay, block
 * queries (solidType), world (re)generation lifecycle, block break/place, doors,
 * chunk rebuild-around, picking face offset and world save/load. Mixed in.
 */
trait World
{
    // ============================================================ world (gen)

    /** Free all instantiated entities; keep the data model (height/edits). */
    private function clearWorld(): void
    {
        $e = $this->e;
        $this->clearMobs();
        foreach ($this->chunk as $list) {
            foreach ($list as $h) { $e->xFreeEntity($h); }
        }
        $this->chunk = $this->chunkMesh = $this->meshCk = $this->water = $this->loaded = [];
        $this->chunkCache = []; // handles already freed by the loop above
        $this->streamCX = PHP_INT_MAX;
        $this->streamCZ = PHP_INT_MAX;
    }

    private function rebuildWorld(): void
    {
        $this->clearWorld();
        $this->edits = [];
        $this->editsByChunk = [];
        $this->lightCells = [];
        $this->treeGen = [];
        $this->height = [];
        $this->biome = [];
        $this->generateData();
    }

    /**
     * Infinite world: nothing is precomputed. The height map, ores and trees are
     * generated procedurally per column/chunk on demand as the player explores
     * (see heightAt / groundType / loadChunk). Only a new random seed + mobs.
     */
    private function generateData(): void
    {
        $this->seed = mt_rand() / mt_getrandmax() * 1000.0;
        $this->chests = [];
        $this->starterKit();
        $this->buildStructures();
    }



    private function clearMobs(): void
    {
        foreach ($this->mobs as $m) {
            foreach ($m['parts'] as $p) { $this->e->xFreeEntity($p); }
            $this->e->xFreeEntity($m['pivot']);
        }
        $this->mobs = [];
    }

    // =============================================================== hud icons


    private function exposedBottom(int $x, int $z): int
    {
        $min = $this->heightAt($x, $z);
        foreach ([[1, 0], [-1, 0], [0, 1], [0, -1]] as [$dx, $dz]) {
            $nx = $x + $dx; $nz = $z + $dz;
            $nh = $this->heightAt($nx, $nz);
            $min = min($min, $nh);
        }
        return max(0, $min);
    }

    /** Block types that snow settles on top of (natural ground + built stone/brick/wood). */
    private function coverable(int $type): bool
    {
        // grass, dirt, stone, brick, wood, snow, sand, glowstone, ores
        return in_array($type, [1, 2, 3, 4, 5, 6, 9, 11, 12, 13, 14], true);
    }

    private function setEdit(int $x, int $y, int $z, int $type): void
    {
        $k = "$x,$y,$z";
        $this->edits[$k] = $type;
        $ck = $this->cdiv($x) . "," . $this->cdiv($z);
        $this->editsByChunk[$ck][$k] = $type;
        if ($this->trackSpill) { $this->treeSpill[$ck] = true; }
        if ($type === 11) { $this->lightCells[$k] = [$x, $y, $z]; } // glowstone = light source
        else { unset($this->lightCells[$k]); }
    }

    /** Bake a tree into the edit overlay (streamed in with its chunk). */
    private function plantTreeData(int $x, int $y, int $z): void
    {
        $trunk = mt_rand(3, 4);
        for ($i = 0; $i < $trunk; $i++) { $this->setEdit($x, $y + $i, $z, 8); }
        $top = $y + $trunk;
        for ($dy = -1; $dy <= 0; $dy++) {
            for ($dx = -2; $dx <= 2; $dx++) {
                for ($dz = -2; $dz <= 2; $dz++) {
                    if (abs($dx) === 2 && abs($dz) === 2) { continue; }
                    $this->setEdit($x + $dx, $top + $dy, $z + $dz, 7);
                }
            }
        }
        foreach ([[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]] as [$dx, $dz]) {
            $this->setEdit($x + $dx, $top + 1, $z + $dz, 7);
        }
    }

    // ============================================================ world (ops)

    private function key(int $x, int $y, int $z): string { return "$x,$y,$z"; }
    private function cdiv(int $v): int { return (int) floor($v / self::CH); }

    /** Final block type at a cell from the data model (edits over generation). 0 = air. */
    private function solidType(int $x, int $y, int $z): int
    {
        // solid "bedrock" below the world so the underside of the terrain is never meshed
        // (no wasted bottom faces you'd only ever see by flying under the map)
        if ($y < 0) { return 3; }
        $k = "$x,$y,$z";
        if (array_key_exists($k, $this->edits)) {
            $t = $this->edits[$k];
            if ($t === self::DOOR && ($this->doorOpen[$k] ?? false)) { return 0; } // open door = passable
            return $t;
        }
        $h = $this->heightAt($x, $z);
        if ($y <= $h) {
            // carve caves below the surface crust (top block stays solid so no surface holes)
            if ($y >= 2 && $y <= $h - 2 && $this->caveAt($x, $y, $z)) { return 0; }
            return $this->groundType($x, $y, $z);
        }
        return 0;
    }

    // =================================================================== bloom

    /** Rebuild the chunk containing (x,z) plus horizontal neighbours (border faces). */
    private function rebuildAround(int $x, int $z): void
    {
        $done = [];
        foreach ([[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]] as [$dx, $dz]) {
            $cx = $this->cdiv($x + $dx); $cz = $this->cdiv($z + $dz);
            $ck = "$cx,$cz";
            if (!isset($done[$ck])) { $done[$ck] = true; $this->rebuildChunk($cx, $cz); }
        }
    }

    private function destroyAt(Engine $e, int $x, int $y, int $z): void
    {
        $type = $this->solidType($x, $y, $z);
        if ($type <= 0) { return; }
        $this->spawnBreakParticles($x, $y, $z, $type);
        $this->invAdd($this->dropFor($type)); // mined block drops into the inventory
        if ($type === self::CHEST && isset($this->chests["$x,$y,$z"])) { // spill chest contents
            foreach ($this->chests["$x,$y,$z"] as $t => $c) { $this->invAdd($t, $c); }
            unset($this->chests["$x,$y,$z"]);
        }
        $this->setEdit($x, $y, $z, 0); // record removal in the data model
        $this->play($this->sndBreak);
        $this->rebuildAround($x, $z);
    }

    private function placeAt(Engine $e, int $x, int $y, int $z, int $type): void
    {
        if ($y < 0 || $y > self::Y_MAX) { return; }
        if ($this->solidType($x, $y, $z) > 0) { return; }
        if ($this->invCount($type) <= 0) { return; }  // need the block in the inventory
        $this->invAdd($type, -1);
        $this->setEdit($x, $y, $z, $type);
        if ($type === self::DOOR) {                         // doors are 2 blocks tall
            if ($this->solidType($x, $y + 1, $z) <= 0) { $this->setEdit($x, $y + 1, $z, self::DOOR); }
            $this->doorOpen["$x,$y,$z"] = false;
            $this->doorOpen[($x) . ',' . ($y + 1) . ',' . ($z)] = false;
        }
        $this->play($this->sndPlace);
        $this->rebuildAround($x, $z);
    }

    /** Toggle the door at (x,y,z) and its vertical partner (open/close), rebuild + sound. */
    private function toggleDoor(int $x, int $y, int $z): bool
    {
        if (($this->edits["$x,$y,$z"] ?? -1) !== self::DOOR) { return false; }
        $cells = ["$x,$y,$z"];
        if (($this->edits[($x).','.($y + 1).','.($z)] ?? -1) === self::DOOR) { $cells[] = ($x).','.($y + 1).','.($z); }
        if (($this->edits[($x).','.($y - 1).','.($z)] ?? -1) === self::DOOR) { $cells[] = ($x).','.($y - 1).','.($z); }
        $open = !($this->doorOpen["$x,$y,$z"] ?? false);
        foreach ($cells as $c) { $this->doorOpen[$c] = $open; }
        $this->play($open ? $this->sndPlace : $this->sndBreak);
        $this->rebuildAround($x, $z);
        return true;
    }

    private function faceOffset(Engine $e): array
    {
        $nx = $e->xPickedNX(); $ny = $e->xPickedNY(); $nz = $e->xPickedNZ();
        $ax = abs($nx); $ay = abs($ny); $az = abs($nz);
        if ($ax >= $ay && $ax >= $az) { return [$nx < 0 ? -1 : 1, 0, 0]; }
        if ($ay >= $az)               { return [0, $ny < 0 ? -1 : 1, 0]; }
        return [0, 0, $nz < 0 ? -1 : 1];
    }

    // ============================================================ save / load

    private function worldFile(): string { return dirname(__DIR__, 3) . '/craft-world.json'; }

    private function saveWorld(): void
    {
        // infinite world: only the seed + player edits + which chunks have trees.
        // Terrain/ores regenerate procedurally from the seed.
        $data = ['seed' => $this->seed, 'edits' => $this->edits, 'treeGen' => array_keys($this->treeGen), 'inv' => $this->inv, 'chests' => $this->chests];
        $ok = @file_put_contents($this->worldFile(), json_encode($data)) !== false;
        $this->status = $ok ? 'World saved.' : 'Save failed.';
    }

    private function loadWorld(): void
    {
        $f = $this->worldFile();
        if (!is_file($f) || ($d = json_decode((string) file_get_contents($f), true)) === null) {
            $this->status = 'No saved world.';
            return;
        }
        $this->clearWorld();
        $this->seed = (float) ($d['seed'] ?? 0);
        $this->height = [];
        $this->biome = [];
        $this->edits = [];
        $this->editsByChunk = [];
        $this->lightCells = [];
        $this->treeGen = [];
        foreach (($d['treeGen'] ?? []) as $ck) { $this->treeGen[(string) $ck] = true; }
        foreach (($d['edits'] ?? []) as $k => $type) {
            [$x, $y, $z] = array_map('intval', explode(',', (string) $k));
            $this->setEdit($x, $y, $z, (int) $type);
        }
        $this->inv = [];
        foreach (($d['inv'] ?? []) as $t => $c) { $this->inv[(int) $t] = (int) $c; }
        if ($this->inv === []) { $this->starterKit(); } // older saves had no inventory
        $this->chests = [];
        foreach (($d['chests'] ?? []) as $k => $items) {
            $this->chests[(string) $k] = array_map('intval', (array) $items);
        }
        $this->status = 'World loaded.'; // chunks stream in around the player on Play
    }
}
