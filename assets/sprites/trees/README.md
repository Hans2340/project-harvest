# Trees (PixelLab)

Made with PixelLab "generate with style" (`tools/pixellab_style.py`), 16 variants per call,
**10 generations per call**. Style refs: `docs/references/pixellab/trees/house_roof_64.png`,
`house_timber_64.png` (64 px crops of a PixelLab house) plus the swamp rock and grass tuft.

| Files | Tree | Size |
|---|---|---|
| `kelapa_00..15.png` | pokok kelapa (coconut palm) | 64×64 |
| `pokok_buah_00..15.png` | pokok buah: durian / rambutan-style fruit trees (rambutan = 0, 10; hanging fruit = 1, 6, 13) | 64×64 |

- `raw/` = straight from PixelLab; the top-level files had a few stray white pixels removed.
- In game they're drawn at **2×** (128 px), the same as the houses, so the pixel size matches the
  swamp pack. Placement: `PALMS` / `FRUIT_TREES` in `scripts/world/kampung.gd`.
- Still wanted later: pokok pisang (banana), bakau (mangrove), nipah palm, bamboo.
