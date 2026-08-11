# Xors3d + PHP (FFI) — OOP framework

Полноценный **ООП-каркас** для движка **Xors3d Indie 7.50** на PHP + FFI:
PSR-4 автолоадер, роутер, контроллеры, а весь биндинг FFI **сгенерирован
заранее** в типизированные классы (никакого разбора заголовков в рантайме).

## Структура

```
xors3d/
├─ run.bat                  Лаунчер в корне (запускает app.php нужным 32-бит PHP)
├─ phpx86/                  32-битная сборка PHP (+ php.ini с включённым FFI)
└─ xors3d-php/              Этот проект:
   ├─ app.php               Фронт-контроллер (точка входа)
   ├─ routes.php            Таблица маршрутов: имя -> контроллер::метод
   ├─ bin/
   │  └─ generate.php       Кодогенератор: xors3d.h -> src/Ffi/*.php (build-time)
   └─ src/
      ├─ autoload.php       PSR-4 автолоадер для пространства Xors3D\
      ├─ Core/              Application, Router, Controller, Config
      ├─ Ffi/               NativeLibrary + ГЕНЕРИРУЕМЫЕ Engine.php / Constants.php
      ├─ Scene/             ООП-обёртки: Entity, Camera, Cube, Texture, MouseLookCamera…
      └─ Controllers/       По одному контроллеру на демку (32 примера + info)
```

## Запуск

**Интерактивный лаунчер демок** (меню со всеми примерами):

```bat
run.bat                 rem откроет меню; выбор по номеру или имени
```

После выхода из демки (ESC) лаунчер возвращается в меню — движок грузится один раз.

**Прямой запуск конкретной демки:**

```bat
run.bat simple          rem пример с кубом (выход по ESC)
run.bat simple 300      rem авто-выход после 300 кадров (для теста)
run.bat info            rem инфо о движке (без окна)
run.bat help            rem список маршрутов
```

или напрямую:

```bat
..\phpx86\php.exe app.php simple
```

## Демки (порт всех примеров Samples/Source/C++)

Портированы **все 32 примера** из SDK (+ демка `info`). Каждый — отдельный
контроллер в `src/Controllers`, доступный как маршрут:

`animtex army blank bloom bump butterfly clipplane cubemap dof editor forest fx
glass instancing instancing2 meshesintersect pick pointing psystem px r2i r2t
rwpixel shadows simple skinning splatting stretchbb surface sysinfo terrain water`

Управление в большинстве демок: **WASD + мышь** (камера), **ESC** — выход.
Особые клавиши подписаны прямо в окне (SPACE, 1-4, Q, стрелки, ЛКМ/ПКМ).

Общая логика вынесена в переиспользуемые классы `src/Scene`:
`MouseLookCamera` (камера WASD+мышь), `Cubemap`, `Skybox`, `Entity`/`Camera`/`Cube`/`Texture`.

## Как добавить свой пример (route + controller)

1. Создать `src/Controllers/MyController.php`:

   ```php
   namespace Xors3D\Controllers;

   use Xors3D\Core\Controller;
   use Xors3D\Scene\Cube;

   final class MyController extends Controller
   {
       public function index(): int
       {
           $e = $this->engine;                 // типизированный Engine (FFI)
           $e->xKey($this->config->firstKey());
           $e->xGraphics3D(800, 600, 32, 0, 1);
           $cube = Cube::create($e);
           while (!$e->xKeyDown(\Xors3D\Ffi\Constants::KEY_ESCAPE)) {
               $cube->turn(0, 1, 0);
               $e->xRenderWorld();
               $e->xFlip();
           }
           $e->xReleaseGraphics();
           return 0;
       }
   }
   ```

2. Зарегистрировать маршрут в `routes.php`:

   ```php
   $router->add('my', \Xors3D\Controllers\MyController::class);
   ```

3. Запустить: `run.bat my`.

## Кодогенерация

Биндинг создаётся один раз (и при обновлении SDK):

```bat
..\phpx86\php.exe bin\generate.php
```

Генератор разбирает `headers/CPP/inc/xors3d.h` и выдаёт `src/Ffi/Engine.php`
(по одному типизированному методу на каждую нативную функцию, с корректными
значениями по умолчанию) и `src/Ffi/Constants.php`. **В рантайме заголовок
больше не парсится** — приложение стартует из обычных PHP-классов.

## Технические детали

- Нужен **32-битный PHP** (`..\phpx86`), т.к. все DLL движка — x86.
- FFI включён в `..\phpx86\php.ini` (`extension=ffi`, `ffi.enable=true`).
- Экспорты `Xors3d.dll` используют `__stdcall` → имена декорированы как
  `_имя@N`. У авто-декорации PHP FFI баг (segfault на функциях без аргументов),
  поэтому символы резолвятся вручную через `GetProcAddress` по точному имени,
  а адрес приводится к типизированному указателю через `FFI::cast()` —
  штатное использование FFI.
- «Значения по умолчанию» C++ отсутствуют на уровне ABI, поэтому они запечены
  в сигнатуры сгенерированных PHP-методов.

## Демка «Craft» (minecraft-подобная игра)

Маршрут `minecraft` — самостоятельный пример игры (`src/Controllers/MinecraftController.php`):

- **Меню**: Play / New World / Save World / Load World / Settings / Quit (стрелки + Enter), живой вращающийся мир на фоне.
- **Настройки** (`craft-settings.json`): чувствительность, инверсия Y, FOV, туман, **день/ночь**, **громкость звука** — вживую; разрешение, vsync — при перезапуске; размер мира, деревья, **вода** — при New World.
- **Мир**: процедурный рельеф, **биомы** (трава / песчаные пляжи у воды / снежные шапки), слои земля/камень, **деревья**, **анимированная вода** в низинах.
- **Ходьба и полёт**: `F` переключает режим. В ходьбе — гравитация, воксельная коллизия, прыжок (SPACE); в полёте — свободно (SPACE/SHIFT — вверх/вниз).
- **Геймплей**: WASD + мышь, ЛКМ — ломать, ПКМ — ставить, **1-9 или колесо мыши** — выбор блока (9 типов), держимый блок «в руке», Esc — в меню.
- **Звук** (синтезируется в `assets/sounds/` через `bin/gen_sounds.php`): ломание, установка, шаги, зацикленный эмбиент-ветер; громкость в настройках.
- **Save/Load** мира в `craft-world.json`.
- Текстуры — настоящие 16×16 тайлы Minecraft в `assets/blocks/` (легко заменить своими).

Запуск: `run.bat minecraft`.
