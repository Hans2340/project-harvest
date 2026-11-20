# Dark Swamp pack: team notes

- **Source:** Dark Swamp Starter Asset Pack v1.0 by Hypnobius (https://hypnobius.itch.io/). See `LICENSE.txt`.
- **Keep the repo private** while these files are in it (no redistribution allowed).
- `raw/`: the original files from the pack's `RawAssets` folder (the RPG Maker folder isn't needed).
- `generated/`: made from `raw/` by our scripts. Don't edit by hand; rerun them instead:
  ```
  python3 tools/rpgmaker_autotile.py   # water + leafy grass -> 47-tile autotile atlases
  python3 tools/slice_swamp_props.py   # props + repeatable boardwalk strips
  ```
- Native size is **48 px tiles** (the pack says scale up, not down), so the swamp zone uses a
  48 px grid while the farm uses 32 px.
- **Pixel density note:** the pack is drawn chunkier (about 2 screen px per art pixel) than our
  24×40 character format. It's fine for the prototype; decide later whether to keep the swamp at
  this scale or redraw final swamp art in our own style.
