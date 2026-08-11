<?php

declare(strict_types=1);

use Xors3D\Core\Router;

/**
 * Route table. Controllers in src/Controllers are auto-discovered:
 * route name = lowercased class name without the "Controller" suffix.
 * Add a new sample simply by dropping a *Controller.php file in there.
 */
return static function (Router $router): void {
    $router->autodiscover(__DIR__ . '/src/Controllers', 'Xors3D\\Controllers');
};
