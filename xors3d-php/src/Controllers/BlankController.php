<?php

declare(strict_types=1);

namespace Xors3D\Controllers;

use Xors3D\Core\Controller;

/**
 * The "blank" sample - does nothing (the C++ version is an empty WinMain).
 */
final class BlankController extends Controller
{
    public const TITLE = 'Empty program (does nothing)';

    public function index(int|string $maxFrames = 0): int
    {
        return 0;
    }
}
