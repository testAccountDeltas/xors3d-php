<?php

declare(strict_types=1);

namespace Xors3D\Controllers\Craft;

use Xors3D\Ffi\Constants;
use Xors3D\Ffi\Engine;

/**
 * Per-pixel block shader (assets/shaders/Blocks.fx) for the chunk meshes: soft
 * half-Lambert directional sun + hemispheric ambient + depth fog, multiplied by the
 * baked vertex colour (ambient occlusion + skylight + torch glow). Gives the voxels
 * a soft, lit look instead of flat vertex colour.
 *
 * Falls back to fixed-function FX_VERTEXCOLOR if the GPU can't run the technique
 * (validated once at setup) or the player turns it off. Mixed into MinecraftController.
 */
trait BlockShader
{
    /** Load + validate the block shader; sets $this->blockOK / $this->blockShade. */
    private function setupBlockFX(Engine $e): void
    {
        $this->blockOK = false;
        $fx = dirname(__DIR__, 3) . '/assets/shaders/Blocks.fx';
        if (is_file($fx)) {
            $this->blockFX = $e->xLoadFXFile($fx);
            if ($this->blockFX !== 0 && $e->xValidateEffectTechnique($this->blockFX, 'Block')) {
                $this->blockOK = true;
                $this->blockCutOK = (bool) $e->xValidateEffectTechnique($this->blockFX, 'BlockCut');
            }
        }
        $this->refreshBlockShade();
        $this->computeBlockFXConsts();
    }

    /** Whether the shader is actually used right now (supported AND enabled). */
    private function refreshBlockShade(): void
    {
        $this->blockShade = $this->blockOK && (int) ($this->settings['blockfx'] ?? 1) === 1;
    }

    /** Attach the shader to a freshly built chunk mesh (semantics + current constants). */
    private function attachBlockFX(int $mesh): void
    {
        $e = $this->e;
        $e->xSetEntityEffect($mesh, $this->blockFX);
        // opaque chunks use the fast no-clip 'Block'; only glass-bearing chunks pay for
        // the alpha-test 'BlockCut' (clip() disables early-Z, costly under overdraw).
        $tech = ($this->meshHasGlass && $this->blockCutOK) ? 'BlockCut' : 'Block';
        $e->xSetEffectTechnique($mesh, $tech);
        $e->xSetEffectMatrixSemantic($mesh, 'MatWorldViewProj', Constants::WORLDVIEWPROJ);
        $e->xSetEffectMatrixSemantic($mesh, 'MatWorld', Constants::WORLD);
        $this->applyBlockFXConsts($mesh);
    }

    /** Push the cached lighting constants onto one chunk mesh. */
    private function applyBlockFXConsts(int $mesh): void
    {
        $e = $this->e; $b = $this->bfx;
        if ($b === []) { $this->computeBlockFXConsts(); $b = $this->bfx; }
        $e->xSetEffectVector($mesh, 'SunDir', $b['sun'][0], $b['sun'][1], $b['sun'][2]);
        $e->xSetEffectVector($mesh, 'SunClr', $b['sunc'][0], $b['sunc'][1], $b['sunc'][2]);
        $e->xSetEffectVector($mesh, 'SkyAmb', $b['sky'][0], $b['sky'][1], $b['sky'][2]);
        $e->xSetEffectVector($mesh, 'GndAmb', $b['gnd'][0], $b['gnd'][1], $b['gnd'][2]);
        $e->xSetEffectVector($mesh, 'FogClr', $b['fog'][0], $b['fog'][1], $b['fog'][2]);
        $e->xSetEffectVector($mesh, 'FogRange', $b['fogr'][0], $b['fogr'][1], 0.0);
    }

    /** Recompute sun direction / day-night colours / fog from the current sky state. */
    private function computeBlockFXConsts(): void
    {
        $e = $this->e;
        // direction TO the sun = opposite of the directional light's forward vector
        $e->xTFormVector(0.0, 0.0, 1.0, $this->sun, 0);
        $fx = $e->xTFormedX(); $fy = $e->xTFormedY(); $fz = $e->xTFormedZ();
        $len = sqrt($fx * $fx + $fy * $fy + $fz * $fz) ?: 1.0;
        $sun = [-$fx / $len, -$fy / $len, -$fz / $len];

        $d = max(0.0, min(1.0, $this->dayF)); // 0 night .. 1 noon
        $lerp = static fn (array $a, array $b, float $t): array => [
            $a[0] + ($b[0] - $a[0]) * $t, $a[1] + ($b[1] - $a[1]) * $t, $a[2] + ($b[2] - $a[2]) * $t,
        ];
        // wetness (overcast) mutes the sun and greys the ambient a little
        $wet = 1.0 - 0.45 * max(0.0, min(1.0, $this->wetness));

        // Night keeps a visible moonlit floor (the old fixed-function pipeline had a flat
        // ~0.47 ambient, so pure-black night felt like a regression).
        $sunc = $lerp([0.30, 0.36, 0.52], [1.0, 0.95, 0.82], $d);   // moon -> sun
        $sunc = [$sunc[0] * 0.7 * $wet, $sunc[1] * 0.7 * $wet, $sunc[2] * 0.7 * $wet];
        $sky  = $lerp([0.30, 0.34, 0.44], [0.54, 0.62, 0.74], $d);
        $gnd  = $lerp([0.20, 0.22, 0.30], [0.42, 0.39, 0.34], $d);
        $fog  = $lerp([0.09, 0.12, 0.22], [0.45, 0.72, 0.96], $d);

        $dist = (float) ((int) $this->settings['renderDist']) * self::BLOCK;
        $this->bfx = [
            'sun' => $sun, 'sunc' => $sunc, 'sky' => $sky, 'gnd' => $gnd,
            'fog' => $fog, 'fogr' => [$dist * 0.85, $dist * 0.98],
        ];
    }

    /**
     * Refresh the (slowly changing) day/night constants on all visible chunk meshes.
     * Throttled - the values drift with the sun, so a few times a second is plenty and
     * keeps the per-entity constant writes off the hot path.
     */
    private function updateBlockFX(): void
    {
        if (!$this->blockShade) { return; }
        $now = $this->e->xMillisecs();
        if ($this->bfxMs !== 0 && $now - $this->bfxMs < 120 && $now >= $this->bfxMs) { return; }
        $this->bfxMs = $now;
        $this->computeBlockFXConsts();
        foreach ($this->chunkMesh as $mesh) { $this->applyBlockFXConsts($mesh); }
    }
}
