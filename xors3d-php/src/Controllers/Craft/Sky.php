<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;
use Xors3D\Ffi\Engine;

/**
 * Sky & atmosphere for the Craft voxel game: sun/moon discs, drifting clouds,
 * the day/night cycle (sky/fog colour, ambient + directional light) and overcast
 * tinting. createSky() also builds the weather pool. Mixed into MinecraftController.
 */
trait Sky
{
    /** Create the visible sun/moon discs and a few drifting clouds (fog-immune). */
    private function createSky(Engine $e): void
    {
        $sky = dirname(__DIR__, 3) . '/assets/sky/';
        $fxSky = Constants::FX_FULLBRIGHT + Constants::FX_DISABLEFOG;

        $this->sunDisc = $e->xCreateSprite();
        $e->xEntityTexture($this->sunDisc, $e->xLoadTexture($sky . 'sun.png', 1 + 2 + 8));
        $e->xEntityFX($this->sunDisc, $fxSky);
        $e->xScaleSprite($this->sunDisc, 34, 34);

        $this->moonDisc = $e->xCreateSprite();
        $e->xEntityTexture($this->moonDisc, $e->xLoadTexture($sky . 'moon.png', 1 + 2 + 8));
        $e->xEntityFX($this->moonDisc, $fxSky);
        $e->xScaleSprite($this->moonDisc, 26, 26);

        // soft, airy clouds: clusters of overlapping billboard puffs
        $puffTex = $e->xLoadTexture($sky . 'puff.png', 1 + 2 + 8);
        for ($i = 0; $i < 8; $i++) {
            $pivot = $e->xCreatePivot();
            $rx = mt_rand(9, 16);   // cloud radius (blocks)
            $rz = mt_rand(6, 11);
            $puffs = mt_rand(7, 13);
            for ($p = 0; $p < $puffs; $p++) {
                $ox = (mt_rand(-100, 100) / 100.0) * $rx;
                $oz = (mt_rand(-100, 100) / 100.0) * $rz;
                $oy = (mt_rand(-100, 100) / 100.0) * 1.2;
                $size = mt_rand(7, 14);                    // puff diameter (blocks)
                $sp = $e->xCreateSprite();
                $e->xEntityTexture($sp, $puffTex);
                $e->xEntityFX($sp, $fxSky);
                $e->xEntityAlpha($sp, mt_rand(45, 75) / 100.0);
                $e->xScaleSprite($sp, $size * self::BLOCK, $size * self::BLOCK);
                $e->xEntityParent($sp, $pivot);
                $e->xPositionEntity($sp, $ox * self::BLOCK, $oy * self::BLOCK, $oz * self::BLOCK, 0);
                $this->cloudPuffs[] = $sp;
            }
            $this->clouds[] = [
                'pivot' => $pivot,
                'x'     => mt_rand(-20, 140) * self::BLOCK,
                'y'     => (self::MAX_H + mt_rand(10, 15)) * self::BLOCK,
                'z'     => mt_rand(-20, 140) * self::BLOCK,
                'sp'    => (mt_rand(2, 5) / 100.0) * self::BLOCK,
            ];
        }

        $this->createWeather($e, $sky, $fxSky);
    }


    /** Position sun & moon discs relative to the camera, drift the clouds. */
    private function updateSkyObjects(): void
    {
        $e = $this->e;
        $d = (int) $this->settings['renderDist'] * self::BLOCK * 0.9;
        $cxp = $e->xEntityX($this->camH, 1);
        $cyp = $e->xEntityY($this->camH, 1);
        $czp = $e->xEntityZ($this->camH, 1);

        // constant on-screen size regardless of render distance (angular size)
        $e->xScaleSprite($this->sunDisc, $d * 0.095, $d * 0.095);
        $e->xScaleSprite($this->moonDisc, $d * 0.075, $d * 0.075);

        // sun sits opposite the sun-light ray direction
        $e->xTFormVector(0, 0, 1, $this->sun, 0);
        $fx = $e->xTFormedX(); $fy = $e->xTFormedY(); $fz = $e->xTFormedZ();
        $e->xPositionEntity($this->sunDisc, $cxp - $fx * $d, $cyp - $fy * $d, $czp - $fz * $d);
        (-$fy > -0.05) ? $e->xShowEntity($this->sunDisc) : $e->xHideEntity($this->sunDisc);

        // moon sits opposite the sun (along the moon-light ray direction)
        $e->xTFormVector(0, 0, 1, $this->moon, 0);
        $mx = $e->xTFormedX(); $my = $e->xTFormedY(); $mz = $e->xTFormedZ();
        $e->xPositionEntity($this->moonDisc, $cxp - $mx * $d, $cyp - $my * $d, $czp - $mz * $d);
        (-$my > -0.05) ? $e->xShowEntity($this->moonDisc) : $e->xHideEntity($this->moonDisc);

        // clouds: tint by time of day so they aren't glaring white at night
        $v = (int) (85 + $this->dayF * 170);
        foreach ($this->cloudPuffs as $sp) {
            $e->xEntityColor($sp, $v, $v, min(255, $v + 8));
        }

        $lo = $this->px - 70 * self::BLOCK; $hi = $this->px + 70 * self::BLOCK;
        foreach ($this->clouds as &$c) {
            $c['x'] += $c['sp'] * $this->dt;
            if ($c['x'] > $hi) { $c['x'] = $lo; }
            $e->xPositionEntity($c['pivot'], $c['x'], $c['y'], $c['z']);
        }
        unset($c);
    }

    private function updateSky(): void
    {
        $e = $this->e;

        if (!(int) $this->settings['daynight']) {
            $this->dayF = 1.0;
            $e->xCameraClsColor($this->camH, 115, 185, 245);
            $e->xCameraFogColor($this->camH, 115, 185, 245);
            $e->xRotateEntity($this->sun, 50, 30, 0);
            $e->xLightColor($this->sun, 255, 250, 235);
            $e->xLightColor($this->moon, 0, 0, 0);
            $e->xAmbientLight(120, 120, 130);
            return;
        }

        $t = getenv('CRAFT_TIME');
        $frac = ($t !== false) ? (float) $t : fmod($e->xMillisecs() / 120000.0 + $this->timeShift, 1.0);
        $ang = $frac * 360.0;
        $e->xRotateEntity($this->sun, $ang, 30, 0);
        $e->xRotateEntity($this->moon, $ang + 180.0, 30, 0); // opposite the sun

        $day   = max(0.0, sin(deg2rad($ang)));   // 1 at noon, 0 at night
        $night = max(0.0, -sin(deg2rad($ang)));  // 1 at midnight, 0 at day
        $this->dayF = $day;

        // sun bright by day, moon dim-blue by night
        $e->xLightColor($this->sun, (int) (255 * $day), (int) (250 * $day), (int) (235 * $day));
        $e->xLightColor($this->moon, (int) (80 * $night), (int) (95 * $night), (int) (150 * $night));

        // sky: bright blue by day -> deep blue at night. Use sqrt(day) so the sky reads
        // blue for most of the daytime instead of dimming to grey at low sun angles.
        $sd = sqrt($day);
        $r = 30 + $sd * 85;   //  30 -> 115
        $g = 45 + $sd * 145;  //  45 -> 190
        $b = 78 + $sd * 172;  //  78 -> 250 (kept high for a blue tint)

        // overcast: pull the sky toward flat grey and dim the sun while it rains/snows
        $w = $this->wetness;
        if ($w > 0.001) {
            $gr = 70 + $day * 55; // grey level that tracks day/night
            $r = $r + ($gr - $r) * $w; $g = $g + ($gr - $g) * $w; $b = $b + ($gr * 1.05 - $b) * $w;
            $dim = 1.0 - 0.5 * $w;
            $e->xLightColor($this->sun, (int) (255 * $day * $dim), (int) (250 * $day * $dim), (int) (235 * $day * $dim));
        }
        $e->xCameraClsColor($this->camH, (int) $r, (int) $g, (int) $b);
        $e->xCameraFogColor($this->camH, (int) $r, (int) $g, (int) $b);

        // keep night navigable (moonlit), bright at noon; a touch dimmer when overcast
        $amb = (45 + $day * 80) * (1.0 - 0.25 * $w);
        $ar = $amb; $ag = $amb; $ab = $amb * 1.25; // slightly blue ambient
        // rain: cool sky-coloured sheen so wet surfaces glisten (fake reflection)
        if ($this->weather === 1) {
            $sheen = $w * (0.35 + $day * 0.4);
            $ar += (150 - $ar) * $sheen * 0.5;
            $ag += (175 - $ag) * $sheen * 0.6;
            $ab += (210 - $ab) * $sheen * 0.8;
        }
        $e->xAmbientLight((int) $ar, (int) $ag, (int) min(255.0, $ab));
    }
}
