# S24 test batch (PixelLab, Plan A)

Test for S24 player customisation (`docs/game-design.md`). Generated 2026-11-20 on the
PixelLab trial (17 of 40 generations). Previews: `preview_s24_test.png` (rows: rotations, run
south, for each set) and `preview_run_south.gif`.

| Folder | What | PixelLab call | Cost |
|---|---|---|---|
| `male/petani/` | male farmer, 8 rotations + run south (8 frames) | `create_character` v3, 40 px; `animate_character` template `running-8-frames` | 2 + 1 |
| `female/petani/` | female farmer, same | same | 2 + 1 |
| `male/hulubalang/` | same man in baju rantai, 8 rotations + run south | `create_character_state` (keeps skeleton) + same template | 10 + 1 |

`metadata.json` is PixelLab's own; it names the state folders `Idle/` and `Hulubalang/`
(renamed here to `petani/` and `hulubalang/`).

Prompts:
- Male: "young Malay village farmer man, 15th-century Malay world, simple brown baju, checkered
  kain sarung at the waist, short black hair, barefoot, empty hands, standing straight, earthy muted colours"
- Female: "young Malay village farmer woman, 15th-century, long-sleeved muted indigo baju panjang,
  ankle-length kain sarung, black hair in a bun, practical modest clothing, empty hands, standing straight"
- Hulubalang state: "same person dressed as a Hulubalang warrior: dark iron chainmail baju rantai
  over a black baju, red kain samping at the waist, dark trousers, no headgear, no weapon, empty hands"

## Results against the 4 test questions

1. **Rotations, same look in every direction?** Yes for both. Rotation bounding boxes for
   petani and Hulubalang match pixel for pixel.
2. **Run (south) readable at 40 px?** Readable, but the template run reads more like a bouncy
   jog. The male farmer's run loses its shirt sleeves (arms come out bare). The female's sarung
   is drawn shorter in mid-stride.
3. **Outfit change keeps body and face?** Yes. Same face, hair, height and proportions.
   Costs 10 generations per outfit per body.
4. **New outfit animated on the same skeleton lines up?** Mostly. Mean alpha-mask overlap
   (IoU) between petani and Hulubalang run frames is 0.90 (0.83 to 0.94), and head tops
   stay within 1 px. Good enough for head/hand anchors, with a small per-outfit tweak.
