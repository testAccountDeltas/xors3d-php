<?php

declare(strict_types=1);

/**
 * Front controller / entry point.
 *
 * Usage:
 *   ..\phpx86\php.exe app.php <route> [args...]
 *
 * Examples:
 *   ..\phpx86\php.exe app.php info
 *   ..\phpx86\php.exe app.php simple
 *   ..\phpx86\php.exe app.php simple 300     (auto-exit after 300 frames)
 *   ..\phpx86\php.exe app.php help
 */

require __DIR__ . '/src/autoload.php';

use Xors3D\Core\Application;
use Xors3D\Core\Config;

// project root = the "xors3d" folder that contains the SDK and phpx86
$config = new Config(dirname(__DIR__));

$app = new Application($config, __FILE__);

// register routes
(require __DIR__ . '/routes.php')($app->router());

exit($app->run($argv));
