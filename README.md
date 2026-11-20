# Project Harvest *(working title)*

A farming RPG made with **Godot 4**.

> "Project Harvest" is a placeholder name. Once we pick the real name we'll
> rename the repo and update `config/name` in `project.godot`.

## Getting started

1. Install **Godot 4.4 or newer** (standard build, not .NET): https://godotengine.org/download
2. Clone the repo:
   ```bash
   git clone https://github.com/Hans2340/project-harvest.git
   ```
3. Open Godot → **Import** → select `project.godot`.
4. Press **F5** to run.

## Project layout

```
assets/      art, audio, fonts (raw + imported)
  sprites/  tilesets/  audio/music  audio/sfx  fonts/  ui/
scenes/      .tscn files (world, player, ui, crops)
scripts/     .gd files, mirroring scenes/
  autoload/  global singletons (GameState, ...)
resources/   .tres data (item & crop definitions)
docs/        design notes
```

## Settings already configured

- 640×360 base resolution (32 px tiles), integer scaling (pixel-art friendly)
- Nearest-neighbour texture filter, pixel snapping
- Compatibility renderer (runs on older laptops)
- Input actions: `move_up/down/left/right` (WASD), `interact` (E)

See [CONTRIBUTING.md](CONTRIBUTING.md) for how we work together.
