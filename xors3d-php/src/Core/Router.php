<?php

declare(strict_types=1);

namespace Xors3D\Core;

use RuntimeException;

/**
 * Tiny route table mapping a route name to a controller class + action method.
 */
final class Router
{
    /** @var array<string,array{0:class-string,1:string}> */
    private array $routes = [];

    /** @var array<string,?string> */
    private array $titles = [];

    public function add(string $name, string $controller, string $action = 'index', ?string $title = null): void
    {
        $this->routes[$name] = [$controller, $action];
        $this->titles[$name] = $title;
    }

    /**
     * Register every *Controller.php in a directory as a route.
     * Route name = lowercased class name without the "Controller" suffix.
     * An optional `public const TITLE` on the controller becomes its label.
     */
    public function autodiscover(string $dir, string $namespace): void
    {
        foreach (glob($dir . DIRECTORY_SEPARATOR . '*Controller.php') as $file) {
            $short = basename($file, '.php');            // e.g. SimpleController
            $class = $namespace . '\\' . $short;
            $name  = strtolower(substr($short, 0, -strlen('Controller')));
            $title = defined("$class::TITLE") ? constant("$class::TITLE") : null;
            $this->add($name, $class, 'index', $title);
        }
        ksort($this->routes);
        ksort($this->titles);
    }

    public function title(string $name): ?string
    {
        return $this->titles[$name] ?? null;
    }

    /** @return array{0:class-string,1:string} */
    public function match(string $name): array
    {
        if (!isset($this->routes[$name])) {
            throw new RuntimeException(
                "Unknown route '$name'. Available: " . implode(', ', $this->names())
            );
        }
        return $this->routes[$name];
    }

    /** @return string[] */
    public function names(): array
    {
        return array_keys($this->routes);
    }
}
