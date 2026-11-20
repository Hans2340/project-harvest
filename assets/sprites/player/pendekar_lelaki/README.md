# Pendekar lelaki (S24 player base)

PixelLab `create_character` mode **pro**, size 56 (10 generations), 2026-11-20.
Concept image: `docs/references/concept/s24_pendekar_lelaki.png` (Gemini).
PixelLab id: `0cacaf43-0c25-4e86-867a-86e6834d4195`. `metadata.json` names the state folder `Idle/` (renamed `base/`).

- 8 rotations in `base/rotations/`, canvas 56x56, figure ~37 px tall (y 9..47), about the
  same height as the v3 test sprites in `../s24_test` (~36 px).
- `preview_size_compare.png`: petani NPC (v3, 40), first try (pro, 44, figure ~29 px, replaced),
  this one (pro, 56).
- Pro mode: figure is ~2/3 of the canvas at these sizes, so use canvas 56 for a ~37 px figure.
- Animations in south, east, north (`base/animations/<name>/<dir>/`), template mode unless noted:
  - `idle`: `breathing-idle`, 4 frames (3 generations).
  - `walk`: `walking-8-frames` (3 generations). **south is skeleton-v3** (3 generations): the
    template turned the character around mid-cycle. Cropped from 64x64 to 56 at (4,5) so the
    head top sits at y=9 like the rest.
  - `run`: `running-8-frames` (3 generations). **south is skeleton-v3** (2026-11-20, 4 generations
    with the pose estimates): the poses come from the run of the free "Adventurer 2D Pixel Art"
    pack (licence allows use in a game). Skeletons were estimated on its 8 run_down frames, and
    the limbs' moves relative to shoulders/hips were put on Pendekar's own proportions, with the
    fists kept at chest height. east and north stay the template run for now.
- `player_sheet.png`: 8 columns x 9 rows, used by `scenes/player/player.tscn`. Rows in blocks of
  three facings (down, up, side; left = side flipped): idle (4 frames), walk (8), run (8).
  Preview: `preview_player_sheet.png`.
- Previews for both Pendekar: `../preview_pendekar.png`, `../preview_pendekar_run.gif`.
