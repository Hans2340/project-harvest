# Kampung ground detail (PixelLab, Stoneshard-inspired)

Made with `tools/pixellab_style.py`; references mix our art **and leoxent's Pendekar**
(`docs/references/pixellab/props/*_28.png`, `*_48.png`, `*_16.png`). All drawn at **1×**.
`raw/` keeps every variant PixelLab returned; top-level files are the picks.

| Group (files) | What | Where it goes |
|---|---|---|
| `serpihan_*` | wood chips, bark | around firewood |
| `rumput_*`, `rumput_kering_*` | grass / weed clumps (sway) | base of objects, grass, edges |
| `bunga_*` | small yellow/white wildflowers (sway) | grass |
| `kerikil_*` | pebbles | yard, sand, by stones and houses |
| `lumpur_*`, `tanah_*` | mud and trampled earth (outline softened, drawn faint) | yard, under firewood and the patung |
| `lopak_*` | puddles | yard, **only visible in rain** |
| `daun_*` | fallen dry leaves | under the fruit trees |
| `lumut_*` | moss | foot of jars and posts |
| `batu_tepi_h_*`, `batu_tepi_v_*` | half-sunk edging stones | along the main paths, with worn gaps |
| `renek_*` | bushes (sway, block a little) | grass |
| `pelepah_*`, `kelapa_jatuh_*` | fallen palm fronds and coconuts | under the palms |
| `tiung_diri_*`, `tiung_patuk_*` | burung tiung standing / pecking (16×16) | `GroundBirds`: peck, hop, fly off near the player |

Placement lives in `scripts/world/kampung.gd` (`_dress()` = base dressing per object kind,
`_scatter()` = fixed-seed scatter by terrain that keeps paths, houses, sawah and water clear,
`_build_path_edges()`) and `scripts/world/ground_birds.gd`.
Shadows follow leoxent's rule: cast shadow only; foot ovals are for the fruit trees.
Cost: 13 calls × 10 generations.
