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

// Crash diagnostics: capture PHP fatals/exceptions to a log so a startup crash
// leaves a trace even when the window just disappears.
$crashLog = __DIR__ . '/craft-crash.log';
ini_set('log_errors', '1');
ini_set('error_log', $crashLog);
error_reporting(E_ALL);
register_shutdown_function(static function () use ($crashLog): void {
    $e = error_get_last();
    if ($e !== null && in_array($e['type'], [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR], true)) {
        @file_put_contents($crashLog, sprintf("[%s] FATAL %s in %s:%d\n",
            date('c'), $e['message'], $e['file'], $e['line']), FILE_APPEND);
    }
});

// project root = the "xors3d" folder that contains the SDK and phpx86
$config = new Config(dirname(__DIR__));

$app = new Application($config, __FILE__);

// register routes
(require __DIR__ . '/routes.php')($app->router());

try {
    exit($app->run($argv));
} catch (\Throwable $t) {
    @file_put_contents($crashLog, sprintf("[%s] EXCEPTION %s: %s\n%s\n",
        date('c'), $t::class, $t->getMessage(), $t->getTraceAsString()), FILE_APPEND);
    fwrite(STDERR, "Crash: {$t->getMessage()} (logged to craft-crash.log)\n");
    exit(1);
}
