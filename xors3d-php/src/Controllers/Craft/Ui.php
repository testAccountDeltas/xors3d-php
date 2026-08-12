<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;
use Xors3D\Ffi\Engine;

/**
 * UI + settings for the Craft voxel game: settings load/save/apply, block icons,
 * the main menu, live settings menu, the spinning menu backdrop and the in-game
 * HUD (crosshair, hotbar with counts, block name). Mixed into MinecraftController.
 */
trait Ui
{
    /**
     * Cinematic camera for README media (CRAFT_CINE): a slow orbit around the spawn village
     * that rises over $max frames, always looking in at the plaza + castle + floating island.
     * Also drives px/pz so chunks stream around the camera. No player physics/HUD in this mode.
     */
    private function cineCamera(int $frame, int $max): void
    {
        $e = $this->e; $B = self::BLOCK;
        $span = max(1, $max);
        $t = $frame / $span;                                   // 0..1 progress

        $gx = $this->cellOf($this->originX); $gz = $this->cellOf($this->originZ);
        $ground = $this->heightAt($gx, $gz);
        $cx = $this->originX; $cz = $this->originZ;             // orbit centre (world units)

        $ang = $t * 2.0 * M_PI * 0.85;                         // ~0.85 turn over the clip
        $radius = (46.0 - 8.0 * $t) * $B;                      // spiral gently inward
        $height = ($ground + 13.0 + 9.0 * $t) * $B;            // a gentle rise over the village

        $camx = $cx + cos($ang) * $radius;
        $camz = $cz + sin($ang) * $radius;
        $camy = $height;

        // look slightly down at the plaza; the floating island stays high in the upper frame
        $tx = $cx; $tz = $cz; $ty = ($ground + 7.0) * $B;
        $dx = $tx - $camx; $dy = $ty - $camy; $dz = $tz - $camz;
        $horiz = sqrt($dx * $dx + $dz * $dz);
        $yaw = atan2($dx, $dz) * 180.0 / M_PI;
        $pitch = -atan2($dy, $horiz) * 180.0 / M_PI;

        $e->xPositionEntity($this->camH, $camx, $camy, $camz);
        $e->xRotateEntity($this->camH, $pitch, $yaw, 0);
        $this->px = $camx; $this->py = $camy; $this->pz = $camz; // stream around the camera
        $e->xHideEntity($this->hand); // no first-person held block in cinematic shots
    }

    private function settingsFile(): string { return dirname(__DIR__, 3) . '/craft-settings.json'; }

    private function loadSettings(): void
    {
        $f = $this->settingsFile();
        if (is_file($f) && ($json = json_decode((string) file_get_contents($f), true)) !== null) {
            foreach ($this->settings as $k => $v) {
                if (isset($json[$k])) {
                    $this->settings[$k] = is_float($v) ? (float) $json[$k] : (is_int($v) ? (int) $json[$k] : $json[$k]);
                }
            }
        }
    }

    private function saveSettings(): void
    {
        @file_put_contents($this->settingsFile(), json_encode($this->settings, JSON_PRETTY_PRINT));
    }

    private function applySettings(): void
    {
        $this->cam->setSensitivity((float) $this->settings['sensitivity']);
        $this->cam->setInvertY((bool) $this->settings['invertY']);
        $this->e->xCameraZoom($this->camH, (float) $this->settings['fov']);
        $this->e->xCameraFogMode($this->camH, (int) $this->settings['fog'] ? 1 : 0);
        if ($this->ambCh !== 0) {
            $this->e->xChannelVolume($this->ambCh, (float) $this->settings['volume'] * 0.6);
        }
        $this->applyRenderDist();
    }

    private function loadIcons(Engine $e): void
    {
        $base = dirname(__DIR__, 3) . '/assets/blocks/';
        foreach (self::TYPES as $id => [$name, $file]) {
            if ($id === 7) { continue; } // leaves not placeable/selectable
            $img = $e->xLoadImage($base . $file);
            $e->xResizeImage($img, 44, 44);
            $this->icon[$id] = $img;
        }
    }

    /** All block types that can be selected in the crafting/block menu. */
    private function craftable(): array
    {
        $ids = array_keys(self::TYPES);
        return array_values(array_filter($ids, fn($id) => $id !== 7)); // exclude leaves
    }

    private function mainMenu(): string
    {
        $items   = ['Play', 'New World', 'Save World', 'Load World', 'Settings', 'Quit'];
        $actions = ['play', 'new', 'save', 'load', 'settings', 'quit'];
        $sel = 0; $e = $this->e;
        $this->streamCX = PHP_INT_MAX;
        $this->updateStreaming($this->originX, $this->originZ); // queue the area around the map centre
        $shot = getenv('CRAFT_MENUSHOT'); $sf = 0;
        if ($shot) { $this->flushStreaming(); } // screenshots need the backdrop present at once

        while (true) {
            if ($this->closeRequested()) { $this->quit = true; return 'quit'; }
            if ($e->xKeyHit(Constants::KEY_UP))   { $sel = ($sel + count($items) - 1) % count($items); }
            if ($e->xKeyHit(Constants::KEY_DOWN)) { $sel = ($sel + 1) % count($items); }
            if ($e->xKeyHit(Constants::KEY_ESCAPE)) { return 'quit'; }
            if ($e->xKeyHit(Constants::KEY_RETURN)) { return $actions[$sel]; }

            $this->orbitBackdrop();
            $w = $e->xGraphicsWidth();
            $e->xColor(255, 255, 255);
            $e->xText($w / 2, 150, 'C R A F T', 1);
            $e->xColor(200, 220, 255);
            $e->xText($w / 2, 180, 'a voxel world for Xors3d (PHP / FFI)', 1);
            foreach ($items as $i => $label) {
                $e->xColor(...($i === $sel ? [255, 240, 120] : [210, 210, 210]));
                $e->xText($w / 2, 250 + $i * 32, $i === $sel ? "> $label <" : $label, 1);
            }
            if ($this->status !== '') {
                $e->xColor(120, 255, 160);
                $e->xText($w / 2, 250 + count($items) * 32 + 10, $this->status, 1);
            }
            $e->xColor(150, 150, 150);
            $e->xText($w / 2, $e->xGraphicsHeight() - 40, 'Arrows: move    Enter: select    Esc: quit', 1);
            if ($shot && ++$sf > 40) { $e->xSaveBuffer($e->xBackBuffer(), $shot); $this->quit = true; return 'quit'; }
            $e->xFlip();
        }
    }

    private function settingsMenu(): void
    {
        $opts = self::OPTIONS; $sel = 0; $e = $this->e;
        $shot = getenv('CRAFT_SETSHOT'); $sf = 0;

        while (true) {
            if ($this->closeRequested()) { $this->quit = true; return; }
            if ($e->xKeyHit(Constants::KEY_ESCAPE)) { $this->saveSettings(); return; }
            if ($e->xKeyHit(Constants::KEY_UP))   { $sel = ($sel + count($opts) - 1) % count($opts); }
            if ($e->xKeyHit(Constants::KEY_DOWN)) { $sel = ($sel + 1) % count($opts); }
            if ($e->xKeyHit(Constants::KEY_LEFT))  { $this->adjust($opts[$sel], -1); }
            if ($e->xKeyHit(Constants::KEY_RIGHT)) { $this->adjust($opts[$sel], +1); }

            $this->orbitBackdrop();
            $w = $e->xGraphicsWidth();
            $e->xColor(255, 255, 255);
            $e->xText($w / 2, 70, 'S E T T I N G S', 1);
            foreach ($opts as $i => $opt) {
                $note = isset($opt['note']) ? "  ({$opt['note']})" : '';
                $line = sprintf('%-18s  < %s >%s', $opt['label'], $this->valueText($opt), $note);
                $e->xColor(...($i === $sel ? [255, 240, 120] : [210, 210, 210]));
                $e->xText($w / 2, 130 + $i * 32, $line, 1);
            }
            $e->xColor(150, 150, 150);
            $e->xText($w / 2, $e->xGraphicsHeight() - 40, 'Up/Down: choose    Left/Right: change    Esc: back (saves)', 1);
            if ($shot && ++$sf > 40) { $e->xSaveBuffer($e->xBackBuffer(), $shot); $this->quit = true; return; }
            $e->xFlip();
        }
    }

    private function valueText(array $opt): string
    {
        $k = $opt['key'];
        return match ($opt['type']) {
            'bool'  => ((int) $this->settings[$k] ? 'On' : 'Off'),
            'int'   => (string) (int) $this->settings[$k],
            'float' => number_format((float) $this->settings[$k], 2),
            'res'   => (int) $this->settings['width'] . 'x' . (int) $this->settings['height'],
            default => (string) $this->settings[$k],
        };
    }

    private function adjust(array $opt, int $dir): void
    {
        $k = $opt['key'];
        switch ($opt['type']) {
            case 'bool':
                $this->settings[$k] = (int) !((int) $this->settings[$k]);
                break;
            case 'int':
                $this->settings[$k] = (int) max($opt['min'], min($opt['max'], (int) $this->settings[$k] + $dir * $opt['step']));
                break;
            case 'float':
                $v = (float) $this->settings[$k] + $dir * $opt['step'];
                $this->settings[$k] = round(max($opt['min'], min($opt['max'], $v)), 2);
                break;
            case 'res':
                $cur = 0;
                foreach (self::RESOLUTIONS as $i => [$rw, $rh]) {
                    if ((int) $this->settings['width'] === $rw && (int) $this->settings['height'] === $rh) { $cur = $i; }
                }
                $cur = ($cur + $dir + count(self::RESOLUTIONS)) % count(self::RESOLUTIONS);
                [$this->settings['width'], $this->settings['height']] = self::RESOLUTIONS[$cur];
                break;
        }
        $this->applySettings();
        $this->saveSettings();
    }

    private function orbitBackdrop(): void
    {
        $e = $this->e;
        $this->processStreaming(6, 2); // keep the backdrop filling in without a freeze
        $mid = $this->originX;
        $t = $e->xMillisecs() / 4000.0;
        $r = (int) $this->settings["renderDist"] * self::BLOCK * 0.5;
        $e->xPositionEntity($this->pivot, $mid, self::MAX_H * self::BLOCK, $mid);
        $e->xPositionEntity($this->camH, $mid + cos($t) * $r, (self::MAX_H + 6) * self::BLOCK, $mid + sin($t) * $r);
        $e->xPointEntity($this->camH, $this->pivot);
        $this->updateSky();
        $this->updateSkyObjects();
        $this->animateWater();
        $this->streamMobs();
        $this->updateMobs();
        $e->xRenderWorld();
    }

    // ================================================================ gameplay


    private function animateWater(): void
    {
        if ($this->waterTex === 0 || $this->water === []) { return; }
        $frame = (int) ($this->e->xMillisecs() / 90) % 32;
        foreach (array_keys($this->water) as $w) {
            $this->e->xEntityTexture($w, $this->waterTex, $frame);
        }
    }

    private function drawHud(Engine $e, bool $hasTarget): void
    {
        $w = $e->xGraphicsWidth();
        $cx = (int) ($w / 2);
        $cy = (int) ($e->xGraphicsHeight() / 2);

        // crosshair (two lines)
        $e->xColor(255, 255, 255);
        $e->xLine($cx - 9, $cy, $cx + 9, $cy);
        $e->xLine($cx, $cy - 9, $cx, $cy + 9);

        $e->xColor(255, 255, 0);
        $e->xText(10, 10, 'FPS: ' . $e->xGetFPS());
        $e->xColor(220, 220, 220);
        $e->xText(10, 30, 'Chunks: ' . count($this->chunkMesh) . '   Mobs: ' . count($this->mobs));
        $e->xText(10, 50, 'Mode: ' . ($this->fly ? 'Fly (F)' : 'Walk (F)')
            . '   XZ: ' . $this->cellOf($this->px) . ',' . $this->cellOf($this->pz));
        $e->xText(10, 70, $hasTarget ? 'LMB destroy / RMB place / E door-chest' : 'no target');
        $e->xText(10, 90, 'C: craft   B: sleep   Esc: menu');
        if ($this->status !== '') { $e->xColor(255, 235, 150); $e->xText(10, 110, $this->status); }

        // visual hotbar: block icons with a selection frame
        $slots = count($this->hotbar);
        $cell = 52; $pad = 4; $iw = 44;
        $barW = $slots * $cell;
        $x0 = $cx - (int) ($barW / 2);
        $y0 = $e->xGraphicsHeight() - $cell - 8;
        foreach ($this->hotbar as $i => $id) {
            $sx = $x0 + $i * $cell;
            $cnt = $this->invCount($id);
            $e->xColor(20, 20, 20);
            $e->xRect($sx, $y0, $cell - 2, $cell - 2, 1);             // slot background
            $e->xDrawImage($this->icon[$id], $sx + $pad, $y0 + $pad);  // block icon
            if ($i === $this->slot) {
                $e->xColor(255, 255, 255);
                $e->xRect($sx - 1, $y0 - 1, $cell, $cell, 0);          // selection frame
            }
            $e->xColor(200, 200, 200);
            $e->xText($sx + 4, $y0 + 2, (string) ($i + 1));            // slot number
            // held count (bottom-right), red when empty
            if ($cnt > 0) { $e->xColor(255, 255, 255); } else { $e->xColor(210, 90, 90); }
            $e->xText($sx + $cell - 22, $y0 + $cell - 18, (string) $cnt);
        }
        // selected block name
        $e->xColor(255, 255, 255);
        $e->xText($cx, $y0 - 18, self::TYPES[$this->selectedType()][0], 1);
    }
}
