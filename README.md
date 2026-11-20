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

## Prototype controls

| Key | Action |
|---|---|
| WASD | Move |
| 1 / 2 / 3 | Tool: Cangkul (hoe) / Benih padi (seeds) / Air (water) |
| E | Use tool on the highlighted tile · harvest ripe padi · sleep (face the bed) |

Loop: hoe grass → plant → water → sleep. Watered padi grows one stage per
night and is ripe after 3 watered nights. 1 real second = 10 in-game minutes;
at 02:00 you pass out and the next day starts.

All art is **placeholder** (`assets/sprites/placeholder/`, `assets/tilesets/placeholder_tiles.png`)
until the real sprites are ready.

## Tests

```bash
godot --headless --path . -s tests/test_farm_cycle.gd
```

Plays a full hoe → plant → water → sleep → harvest cycle and prints PASS/FAIL.

## Project layout

```
assets/      art, audio, fonts (raw + imported)
  sprites/  tilesets/  audio/music  audio/sfx  fonts/  ui/
scenes/      .tscn files (world, player, ui, crops)
scripts/     .gd files, mirroring scenes/
  autoload/  global singletons (GameState, ...)
tests/       headless test scripts
resources/   .tres data (item & crop definitions)
docs/        design notes
```

## Settings already configured

- 640×360 base resolution (32 px tiles), integer scaling (pixel-art friendly)
- Nearest-neighbour texture filter, pixel snapping
- Compatibility renderer (runs on older laptops)
- Input actions: `move_up/down/left/right` (WASD), `interact` (E)

See [CONTRIBUTING.md](CONTRIBUTING.md) for how we work together.
