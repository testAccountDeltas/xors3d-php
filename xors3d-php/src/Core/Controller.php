<?php

declare(strict_types=1);

namespace Xors3D\Core;

use Xors3D\Ffi\Constants;
use Xors3D\Ffi\Engine;

/**
 * Base controller. Every controller gets the shared engine + config injected,
 * plus a few helpers common to all demos.
 */
abstract class Controller
{
    public function __construct(
        protected readonly Engine $engine,
        protected readonly Config $config,
    ) {
    }

    /**
     * Standard start-up: license key, AA, window title, graphics mode.
     * Returns the engine for convenient chaining/short local aliases.
     */
    protected function boot(string $title, int $width = 800, int $height = 600, int $depth = 32, int $vsync = 1): Engine
    {
        $e = $this->engine;
        $e->xKey($this->config->firstKey());
        $e->xSetAntiAliasType($e->xGetMaxAntiAlias());
        $e->xAppTitle($title);
        $e->xGraphics3D($width, $height, $depth, 0, $vsync);
        return $e;
    }

    /** Absolute path to a media asset (e.g. 'Textures/logo.jpg'). */
    protected function media(string $relative): string
    {
        return $this->config->media($relative);
    }

    /** Engine millisecond timer. */
    protected function millis(): int
    {
        return $this->engine->xMillisecs();
    }

    /**
     * Main-loop condition: keep running until ESC is pressed OR the window's
     * close button (WM_CLOSE) is clicked. Handling WM_CLOSE is what stops the
     * app from hanging when the window is closed with the mouse.
     */
    protected function running(): bool
    {
        return !$this->engine->xKeyDown(Constants::KEY_ESCAPE)
            && !$this->engine->xWinMessage('WM_CLOSE');
    }
}
