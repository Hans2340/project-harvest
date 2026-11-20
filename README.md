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
| WASD | Walk · hold **Shift** to run |
| 1 / 2 / 3 | Tool: Cangkul (hoe) / Benih padi (seeds) / Air (water) |
| E | Use the tool on the highlighted tile · harvest ripe padi · sleep (face your house) |
| I or Tab | Open / close the inventory (game pauses) · Esc also closes |

You start at **home in the kampung** (the house top-left of the yard). Plant padi in the
**sawah** east of the houses (2 + E). The sawah is flooded, so padi grows one stage every night
without watering and is ripe after 3 nights. Face your house and press E to sleep.
Walk **west** along the path to reach **Paya Bakau**, the mangrove swamp.

Time: **1 real hour = 24 in-game hours**. A day runs 06:00 to 02:00 (50 real minutes); at
02:00 you pass out and wake at home.

The player sprite and padi/item icons are **placeholders** until the real sprites are ready.

## Tests

```bash
godot --headless --path . -s tests/test_sawah_farming.gd
godot --headless --path . -s tests/test_mangrove.gd
godot --headless --path . -s tests/test_zone_travel.gd
godot --headless --path . -s tests/test_inventory.gd
godot --headless --path . -s tests/test_kampung.gd
```

Each prints PASS/FAIL: sawah farming, the swamp, travelling between zones, the inventory, and the kampung.

## Credits

Third-party assets are listed in [CREDITS.md](CREDITS.md). **Keep this repo private**: one asset pack may not be redistributed.

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
tools/       asset conversion scripts (Python + Pillow)
```

## Settings already configured

- 640×360 base resolution (32 px tiles), integer scaling (pixel-art friendly)
- Nearest-neighbour texture filter, pixel snapping
- Compatibility renderer (runs on older laptops)
- Input actions: `move_up/down/left/right` (WASD), `interact` (E)

See [CONTRIBUTING.md](CONTRIBUTING.md) for how we work together.
