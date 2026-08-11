<?php

declare(strict_types=1);

namespace Xors3D\Core;

use Xors3D\Ffi\Engine;

/**
 * Front controller. Dispatches a CLI route to the matching controller/action.
 *
 * Because a Xors3d app owns a native window and a blocking render loop, routes
 * are CLI commands (e.g. `php app.php simple`) rather than HTTP requests.
 *
 * The interactive menu launches each demo in its *own* child process: that way
 * closing the window (ESC or the close button) ends that process and the OS
 * destroys the window cleanly, returning control to the menu. Running demos
 * back-to-back inside one process would leave the previous window on screen
 * with no message pump (shown as "Not Responding") while the menu waits for
 * input.
 */
final class Application
{
    private ?Engine $engine = null;
    private Router $router;

    /**
     * @param string|null $entryScript Absolute path to the entry script (app.php),
     *                                  used to relaunch demos as child processes.
     */
    public function __construct(
        private readonly Config $config,
        private readonly ?string $entryScript = null,
    ) {
        $this->router = new Router();
    }

    public function router(): Router
    {
        return $this->router;
    }

    /** Lazily create the engine (only needed when a demo runs in this process). */
    private function engine(): Engine
    {
        return $this->engine ??= new Engine($this->config->dllDir, 'Xors3d.dll');
    }

    /**
     * Dispatch based on argv: argv[1] = route name, argv[2..] = action args.
     * With no route (or "menu") it shows the interactive demo launcher.
     */
    public function run(array $argv): int
    {
        $route  = $argv[1] ?? 'menu';
        $params = array_slice($argv, 2);

        if ($route === 'menu' || $route === '') {
            return $this->menu();
        }
        if ($route === 'help' || $route === '--help' || $route === '-h' || $route === 'list') {
            fwrite(STDOUT, "Available routes: " . implode(', ', $this->router->names()) . "\n");
            return 0;
        }

        [$class, $action] = $this->router->match($route);
        return $this->dispatch($class, $action, $params);
    }

    private function dispatch(string $class, string $action, array $params): int
    {
        /** @var Controller $controller */
        $controller = new $class($this->engine(), $this->config);
        return (int) ($controller->$action(...$params) ?? 0);
    }

    /**
     * Interactive launcher: lists demos and runs the chosen one in a child
     * process, then returns to the menu when the demo exits.
     */
    private function menu(): int
    {
        $names = $this->router->names();

        while (true) {
            fwrite(STDOUT, "\n============================================\n");
            fwrite(STDOUT, "   Xors3d PHP demo launcher (" . count($names) . " demos)\n");
            fwrite(STDOUT, "============================================\n");
            foreach ($names as $i => $name) {
                $title = $this->router->title($name);
                fwrite(STDOUT, sprintf("  %2d) %-16s %s\n", $i + 1, $name, $title ? "- $title" : ''));
            }
            fwrite(STDOUT, "   q) quit\n");
            fwrite(STDOUT, "\nSelect a demo (number or name); ESC or the close button returns here:\n> ");

            $input = trim((string) fgets(STDIN));
            if ($input === 'q' || $input === 'quit' || $input === '') {
                return 0;
            }

            $selected = null;
            if (ctype_digit($input)) {
                $selected = $names[(int) $input - 1] ?? null;
            } elseif (in_array($input, $names, true)) {
                $selected = $input;
            }
            if ($selected === null) {
                fwrite(STDOUT, "Invalid choice: $input\n");
                continue;
            }

            fwrite(STDOUT, "\n>>> Launching '$selected'... (press ESC or close the window to return)\n");
            $this->launchInChildProcess($selected);
        }
    }

    /** Run a demo route in a separate PHP process and wait for it to finish. */
    private function launchInChildProcess(string $route): void
    {
        // If we don't know the entry script, fall back to in-process dispatch.
        if ($this->entryScript === null) {
            [$class, $action] = $this->router->match($route);
            $this->dispatch($class, $action, []);
            return;
        }

        $cmd = escapeshellarg(PHP_BINARY) . ' '
             . escapeshellarg($this->entryScript) . ' '
             . escapeshellarg($route);

        passthru($cmd, $exitCode);
        if ($exitCode !== 0) {
            fwrite(STDOUT, "(demo '$route' exited with code $exitCode)\n");
        }
    }
}
