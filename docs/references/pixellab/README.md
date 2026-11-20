# PixelLab style references

PixelLab doesn't store reference images, so each request sends them. These crops (all ≤ 256 px,
PixelLab's limit) come from our asset packs and are made by `python3 tools/make_pixellab_refs.py`.
Permission to use the Hypnobius packs as AI style references: see `CREDITS.md`.

| Folder | Contents | Use for |
|---|---|---|
| `swamp/` | water + leafy-grass autotiles, rock, stone mushroom, grass tuft, boardwalk, reeds, altar, a scene sample | swamp/wild props, tiles, structures |
| `ui/` | window frame, slot, selected slot, banner, small icons, bars | item icons, buttons, UI pieces |
| `palettes.json` | `swamp` = 24 most-used pack colours; `ui` = pack palette from its README | `target_palette` / forced colours |

## Which PixelLab feature takes which reference

| We want | PixelLab endpoint | References it accepts |
|---|---|---|
| Swamp props / objects (trees, huts, crates) | `create-1-direction-object` | `style_images` (1–4): e.g. `swamp/rock`, `swamp/altar`, `swamp/bridge_vertical_a` |
| Anything in a matching style (icons, props) | `generate-with-style-v2` | `style_images` (1–4) + `target_palette` |
| Map tilesets (e.g. mangrove mud ↔ water) | `create-tileset` | `lower_reference_image`, `upper_reference_image` (e.g. `swamp/water_autotile`, `swamp/leafy_grass_autotile`) + `target_palette` |
| Item icons for the inventory | `generate-with-style-v2` | `ui/slot`, `ui/icons_row` + `ui` palette |
| 4-direction characters | `create-character-with-4-directions` | **no style images**, only a palette (`color_image`) + optional per-direction reference sprites |
| Rotate our own character into 4/8 directions | `create-character-v3` (reference mode) | `reference_image` = a south-facing sprite we already have |

Character tip: since the 4-direction tool can't take style images, make the **front view first**
with `generate-with-style-v2` (style refs + palette), then rotate it with `create-character-v3`
(`n_directions: 4`).
