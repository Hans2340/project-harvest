# Kampung tilesets (PixelLab)

## kampung_grass_dirt
- **Made with:** PixelLab `create-tileset`, standard mode, **1 generation**. Tileset id `b9baaed9-a515-4a4a-b53a-c537cb15a89e`.
- **Style refs:** `docs/references/pixellab/tileset/grass_ref_24.png` (a swamp-pack grass tile at native
  pixel size) and `dirt_ref_24.png` (a swatch in the pack's browns). A first try with only the grass
  ref turned both terrains green, so the dirt ref is needed.
- `raw/kampung_grass_dirt_24.png`: 16 Wang (corner) tiles at 24 px. Tile index = corner mask
  (NW=1, NE=2, SW=4, SE=8; set bit = dirt), 4 tiles per row.
- `kampung_grass_dirt_48.png`: the same sheet at 2×, **use this one**. It matches the swamp pack's
  48 px tiles and chunky pixels.
- **Using it:** paint terrain on the *corners* (vertices) of the grid; each cell picks the tile whose
  4 corners match. Preview: `docs/references/concept/kampung_grass_dirt-demo.png`.
- **Remake / variants:** `tools/pixellab_wang_demo.py <tileset.json> <name>` turns a
  `GET /v2/tilesets/{id}` response into these sheets.

## kampung_grass_sawah, kampung_water_sand, kampung_grass_sand
- Same method, 1 generation each (`tools/pixellab_tileset.py`). Refs in `docs/references/pixellab/tileset/`
  (`sawah_ref_24`, `sand_ref_24`, `water_ref_24` = swamp-pack water at native pixel size).
- Upper terrain: sawah / sand / sand. Lower: grass / water / grass. Raw JSON in `raw/`.
- In Godot: `resources/tilesets/kampung_tileset.tres` (sources 0-3 = the four sets; 4 = water/sand
  without collision, for the jetty). Water quarters of each tile block movement.
