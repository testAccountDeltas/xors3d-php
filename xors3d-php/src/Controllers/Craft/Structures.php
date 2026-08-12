<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

/**
 * Spawn plaza + world buildings for the Craft voxel game: box helpers, the
 * imported-blueprint placer, hand-built castle/tower, plaza lamps, deterministic
 * tree placement (Poisson-disk) and procedural landmark buildings. Mixed into
 * MinecraftController (calls back into setEdit/plantTreeData/terrain helpers).
 */
trait Structures
{
    // ---------------------------------------------------- spawn structures

    /** Fill a solid box of one block type into the edit overlay. */
    private function fillBox(int $x0, int $y0, int $z0, int $x1, int $y1, int $z1, int $t): void
    {
        for ($x = $x0; $x <= $x1; $x++) {
            for ($y = $y0; $y <= $y1; $y++) {
                for ($z = $z0; $z <= $z1; $z++) { $this->setEdit($x, $y, $z, $t); }
            }
        }
    }

    /** Vertical walls only (perimeter) between two corners. */
    private function walls(int $x0, int $y0, int $z0, int $x1, int $y1, int $z1, int $t): void
    {
        for ($x = $x0; $x <= $x1; $x++) {
            for ($z = $z0; $z <= $z1; $z++) {
                if ($x !== $x0 && $x !== $x1 && $z !== $z0 && $z !== $z1) { continue; }
                for ($y = $y0; $y <= $y1; $y++) { $this->setEdit($x, $y, $z, $t); }
            }
        }
    }

    /** Radius (blocks) around spawn kept clear of trees for the plaza + buildings. */
    private const PLAZA_R = 48;

    /** Load a converted blueprint (assets/structures/<name>.json), cached. */
    private function loadStruct(string $name): ?array
    {
        static $cache = [];
        if (array_key_exists($name, $cache)) { return $cache[$name]; }
        $f = dirname(__DIR__, 3) . '/assets/structures/' . $name . '.json';
        $d = is_file($f) ? json_decode((string) file_get_contents($f), true) : null;
        return $cache[$name] = (is_array($d) ? $d : null);
    }

    /**
     * Stamp a converted blueprint with its min-corner at (ox, base+1, oz). When $level is
     * true a flat grass pad is levelled under it (for ground buildings); when false the
     * blocks are placed as-is (for floating set pieces like the sky island).
     */
    private function placeStruct(string $name, int $ox, int $base, int $oz, bool $level = true): void
    {
        $s = $this->loadStruct($name);
        if ($s === null) { return; }
        if ($level) {
            $w = (int) $s['w']; $d = (int) $s['d'];
            for ($x = $ox - 1; $x <= $ox + $w; $x++) {
                for ($z = $oz - 1; $z <= $oz + $d; $z++) {
                    $this->setEdit($x, $base - 1, $z, 2);
                    $this->setEdit($x, $base, $z, 1);
                    for ($y = $base + 1; $y <= $base + 12; $y++) { $this->setEdit($x, $y, $z, 0); }
                }
            }
        }
        foreach ($s['blocks'] as [$dx, $dy, $dz, $t]) {
            $this->setEdit($ox + (int) $dx, $base + 1 + (int) $dy, $oz + (int) $dz, (int) $t);
        }
    }

    /** A glowstone lamp on a short post (a "torch" light for the plaza). */
    private function lampPost(int $x, int $base, int $z): void
    {
        $this->setEdit($x, $base + 1, $z, 8);   // log post
        $this->setEdit($x, $base + 2, $z, 8);
        $this->setEdit($x, $base + 3, $z, 11);  // glowstone lamp on top
    }

    /** Build the spawn plaza with imported blueprint buildings + a castle, tower and lamps. */
    private function buildStructures(): void
    {
        $ox = $this->cellOf($this->originX);
        $oz = $this->cellOf($this->originZ);
        $base = max(self::SEA + 2, $this->heightAt($ox, $oz));

        // small clear pad where the player lands
        for ($x = $ox - 3; $x <= $ox + 3; $x++) {
            for ($z = $oz - 3; $z <= $oz + 3; $z++) {
                $this->setEdit($x, $base - 1, $z, 2);
                $this->setEdit($x, $base, $z, 1);
                for ($y = $base + 1; $y <= $base + 12; $y++) { $this->setEdit($x, $y, $z, 0); }
            }
        }

        // imported Axiom blueprints (converted from Default-assets/schematics)
        $this->placeStruct('birch_house',    $ox - 40, $base, $oz - 16);
        $this->placeStruct('medieval_house', $ox + 12, $base, $oz - 18);
        $this->placeStruct('temple',         $ox - 18, $base, $oz + 14);

        // hand-built castle + watchtower
        $this->buildCastle($ox + 12, $base, $oz + 10);
        $this->buildTower($ox - 4, $base, $oz + 6);

        // lamp posts around the central plaza for night-time light
        foreach ([[-8, -8], [8, -8], [-8, 8], [8, 8], [0, -10], [0, 10]] as [$lx, $lz]) {
            $this->lampPost($ox + $lx, $base, $oz + $lz);
        }

        // a giant floating island in the sky over the village (scenic set piece)
        $isl = $this->loadStruct('island');
        if ($isl !== null) {
            $floatY = $base + 40; // bottom of the island, high above the plaza
            $ix = $ox - (int) ((int) $isl['w'] / 2) - 20; // offset to one side
            $iz = $oz - (int) ((int) $isl['d'] / 2);
            $this->placeStruct('island', $ix, $floatY, $iz, false);
        }
    }

    /** Stone-brick castle: walls, battlements, four corner towers, gate + throne room. */
    private function buildCastle(int $x0, int $base, int $z0): void
    {
        $w = 10; $d = 10; $wh = 6;
        $x1 = $x0 + $w; $z1 = $z0 + $d;
        $this->fillBox($x0, $base, $z0, $x1, $base, $z1, 15);          // cobblestone floor
        $this->walls($x0, $base + 1, $z0, $x1, $base + $wh, $z1, 16);  // stone-brick walls
        // battlements (merlons) along the top edge, every other block
        for ($x = $x0; $x <= $x1; $x++) {
            for ($z = $z0; $z <= $z1; $z++) {
                if ($x !== $x0 && $x !== $x1 && $z !== $z0 && $z !== $z1) { continue; }
                if ((($x + $z) & 1) === 0) { $this->setEdit($x, $base + $wh + 1, $z, 16); }
            }
        }
        // taller corner towers
        foreach ([[$x0, $z0], [$x1, $z0], [$x0, $z1], [$x1, $z1]] as [$cx, $cz]) {
            $tx0 = max($x0, $cx - 1); $tx1 = min($x1, $cx + 1);
            $tz0 = max($z0, $cz - 1); $tz1 = min($z1, $cz + 1);
            $this->walls($tx0, $base + 1, $tz0, $tx1, $base + $wh + 3, $tz1, 16);
            $this->fillBox($tx0, $base + $wh + 3, $tz0, $tx1, $base + $wh + 3, $tz1, 22); // chiseled cap
        }
        // gate: 3-wide, 3-high opening in the front (-z) wall
        $gx = $x0 + 5;
        $this->fillBox($gx - 1, $base + 1, $z0, $gx + 1, $base + 3, $z0, 0);
        // interior throne room: glowstone lights, bookshelves and a throne
        $this->setEdit($x0 + 3, $base + $wh, $z0 + 3, 11);
        $this->setEdit($x1 - 3, $base + $wh, $z1 - 3, 11);
        $this->fillBox($x0 + 1, $base + 1, $z1 - 1, $x0 + 3, $base + 2, $z1 - 1, 19); // bookshelves
        $this->fillBox($x1 - 1, $base + 1, $z1 - 3, $x1 - 1, $base + 2, $z1 - 1, 19);
        $this->setEdit($x0 + 5, $base + 1, $z1 - 2, 22);            // throne base
        $this->setEdit($x0 + 5, $base + 2, $z1 - 2, 20);            // throne seat (red)
    }

    /** Slim stone watchtower with a glowstone beacon on top. */
    private function buildTower(int $cx, int $base, int $cz): void
    {
        $h = 10;
        $this->walls($cx - 1, $base + 1, $cz - 1, $cx + 1, $base + $h, $cz + 1, 16);
        $this->fillBox($cx - 1, $base, $cz - 1, $cx + 1, $base, $cz + 1, 15);        // base
        // door
        $this->setEdit($cx, $base + 1, $cz - 1, 0); $this->setEdit($cx, $base + 2, $cz - 1, 0);
        // battlement cap + beacon
        for ($x = $cx - 1; $x <= $cx + 1; $x++) {
            for ($z = $cz - 1; $z <= $cz + 1; $z++) {
                if ((($x + $z) & 1) === 0) { $this->setEdit($x, $base + $h + 1, $z, 22); }
            }
        }
        $this->setEdit($cx, $base + $h, $cz, 11); // glowstone beacon inside the top
    }

    /** Minimum spacing (blocks) between tree trunks so canopies never overlap. */
    private const TREE_DIST = 4;

    /**
     * Is (x,z) a tree candidate? Returns >=0 (its priority) if a trunk may grow here,
     * or -1 otherwise. Pure function of position so neighbouring chunks agree.
     */
    private function treeStrength(int $x, int $z): float
    {
        // keep the spawn plaza (and its buildings) clear of trees
        if (abs($x - $this->cellOf($this->originX)) <= self::PLAZA_R
            && abs($z - $this->cellOf($this->originZ)) <= self::PLAZA_R) { return -1.0; }
        $h = $this->heightAt($x, $z);
        if ($h <= self::SEA || $h >= self::SNOW) { return -1.0; }
        $b = $this->biomeVal($x, $z);
        if ($b < 0.30)      { return -1.0; }     // desert: no trees
        elseif ($b < 0.55)  { $prob = 0.012; }   // plains: sparse
        elseif ($b < 0.72)  { $prob = 0.06;  }   // forest: dense
        else                { $prob = 0.008; }   // mountains: rare
        if ($this->hash3($x, 7, $z) >= $prob * (float) $this->settings['trees']) { return -1.0; }
        return $this->hash3($x, 13, $z);          // independent priority for spacing
    }

    /** Deterministically populate a chunk's trees into the edit overlay (once). */
    private function genTrees(int $cx, int $cz): void
    {
        $x0 = $cx * self::CH; $z0 = $cz * self::CH;
        $D = self::TREE_DIST;
        for ($x = $x0; $x < $x0 + self::CH; $x++) {
            for ($z = $z0; $z < $z0 + self::CH; $z++) {
                $pri = $this->treeStrength($x, $z);
                if ($pri < 0.0) { continue; }
                // Poisson-disk spacing: only plant if this is the strongest candidate in
                // a TREE_DIST radius, so no two trunks land close enough to overlap.
                $win = true;
                for ($nx = $x - $D; $nx <= $x + $D && $win; $nx++) {
                    for ($nz = $z - $D; $nz <= $z + $D; $nz++) {
                        if ($nx === $x && $nz === $z) { continue; }
                        if ($this->treeStrength($nx, $nz) > $pri) { $win = false; break; }
                    }
                }
                if ($win) { $this->plantTreeData($x, $this->heightAt($x, $z) + 1, $z); }
            }
        }
    }

    /** Blueprint buildings that spawn randomly across the world (small/medium only;
     *  the huge cathedral & harbour HQ are excluded to avoid generation hitches). */
    private const WILD_STRUCTURES = [
        'rustic_house', 'house3', 'medieval_house', 'birch_house', 'water_tank',
        'temple', 'castle_grau', 'gate',
    ];
    private const SGRID = 10; // one candidate per 10x10-chunk cell; origin kept to the
                              // central 4x4 so neighbours stay >=7 chunks (56 blocks) apart

    /**
     * Procedural landmarks: at most one blueprint building per SGRID x SGRID chunk cell,
     * at a hashed origin chunk, on flat-ish dry ground. Deterministic from world seed so
     * it regenerates identically. Stamped when that origin chunk first generates.
     */
    private function genStructures(int $cx, int $cz): void
    {
        $g = self::SGRID;
        $gx = (int) floor($cx / $g); $gz = (int) floor($cz / $g);
        // hashed origin within the central 4x4 of the cell (offset 3..6) so structures
        // in neighbouring cells cannot land closer than ~7 chunks to each other
        $ox = $gx * $g + 3 + (int) ($this->hash3($gx, 1, $gz) * 4);
        $oz = $gz * $g + 3 + (int) ($this->hash3($gx, 2, $gz) * 4);
        if ($cx !== $ox || $cz !== $oz) { return; }
        if ($this->hash3($gx, 3, $gz) >= 0.55) { return; }   // ~55% of cells stay empty

        $wx = $ox * self::CH; $wz = $oz * self::CH;
        // keep clear of the spawn plaza
        if (abs($wx - $this->cellOf($this->originX)) < self::PLAZA_R + 24
            && abs($wz - $this->cellOf($this->originZ)) < self::PLAZA_R + 24) { return; }
        $base = $this->heightAt($wx, $wz);
        if ($base < self::SEA + 1) { return; }               // not in water
        if ($this->biomeVal($wx, $wz) >= 0.82) { return; }   // not on steep mountains

        $list = self::WILD_STRUCTURES;
        $pick = $list[(int) ($this->hash3($gx, 5, $gz) * count($list))];
        $this->placeStruct($pick, $wx, $base, $wz);
    }
}
