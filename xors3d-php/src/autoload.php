<?php

declare(strict_types=1);

/**
 * Minimal PSR-4 autoloader for the "Xors3D\" namespace, rooted at this src/ dir.
 * No Composer required.
 */
spl_autoload_register(static function (string $class): void {
    $prefix = 'Xors3D\\';
    if (!str_starts_with($class, $prefix)) {
        return;
    }
    $relative = substr($class, strlen($prefix));
    $file = __DIR__ . DIRECTORY_SEPARATOR
          . str_replace('\\', DIRECTORY_SEPARATOR, $relative) . '.php';

    if (is_file($file)) {
        require $file;
    }
});
