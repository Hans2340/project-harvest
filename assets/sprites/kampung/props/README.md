# Kampung details (PixelLab)

Made with `tools/pixellab_style.py` ("generate with style"). References always mix our existing
art **and leoxent's Pendekar**, so colours, outlines and shading match both:
`docs/references/pixellab/props/` (house roof and timber crops, a fruit-tree crop, the Pendekar
south sprite or its upper half, a stone pile).

| Files | What | Size |
|---|---|---|
| `pagar_0..6` | low wooden/bamboo rail fence, one per half tile | ~26×27 |
| `kayu_api_0..7` | firewood pile | ~28×25 |
| `tempayan_0..7` | clay water jar with lid | ~24×27 |
| `batu_0..6` | river stone pile | ~37×24 |
| `rumput_air_0..7` | tall reeds / water grass (sway in the wind) | ~42×45 |
| `papan_tanda` | Tok Pawang's small vine-wrapped sign (meant to be easy to miss) | 25×25 |
| `pelita` | tin oil lamp on a post (flame at pixel 17,29; lights up at night) | 25×46 |

**Drawn at 1×** (the Pendekar's pixel size), unlike tiles, houses and trees (2×). At 2× these
small objects would be taller than the player. `raw/` (48 px) and `raw_small/` (28 px) hold every
variant PixelLab returned; the top-level files are the picks (cropped, stray pixels removed).
Cost: 9 calls × 10 generations.
