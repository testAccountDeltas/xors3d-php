<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;
use Xors3D\Ffi\Constants;

/**
 * Prints engine information without opening a window - handy to verify the
 * FFI binding and routing without any GUI.
 *
 * Route:  php app.php info
 */
final class InfoController extends Controller
{
    public const TITLE = 'Engine info (no window)';

    public function index(): int
    {
        $e = $this->engine;

        fwrite(STDOUT, "Xors3d engine (via PHP FFI)\n");
        fwrite(STDOUT, "  version : " . $e->xGetXors3dVersion() . "\n");
        fwrite(STDOUT, "  major   : " . $e->xGetXors3dMajorVersion() . "\n");
        fwrite(STDOUT, "  minor   : " . $e->xGetXors3dMinorVersion() . "\n");
        fwrite(STDOUT, "  maxAA   : " . $e->xGetMaxAntiAlias() . "\n");
        fwrite(STDOUT, "  KEY_ESCAPE=" . Constants::KEY_ESCAPE
            . " KEY_W=" . Constants::KEY_W
            . " LIGHT_POINT=" . Constants::LIGHT_POINT . "\n");

        return 0;
    }
}
