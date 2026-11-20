# Pendekar perempuan (S24 player base)

PixelLab `create_character` mode **pro**, size 56 (10 generations), 2026-11-20, styled on the
Pendekar lelaki (`style_character_id` = `0cacaf43-0c25-4e86-867a-86e6834d4195`), from text.
PixelLab id: `1ca2d0cf-7230-4292-8b84-f0a1e050092e`. `metadata.json` names the state folder `Idle/` (renamed `base/`).

- 8 rotations in `base/rotations/`, canvas 56x56, figure ~37 px tall, same height and position as the lelaki.
- Hair in a tight bun, no head covering: the kelubung is a separate headgear layer (S24).
- Run (`running-8-frames`) in south, east, north (`base/animations/run/`).
  - east and north: template mode, 1 generation each.
  - **south: skeleton-v3** (3 generations). The template run lost the trousers (bare shins).
    Skeleton-v3 comes out on a 64x64 canvas, so it was cropped to 56 at (4,6) to put the head
    top at y=9 like the base. PixelLab also keeps it as a separate animation `run_sk`.
- Idle (`breathing-idle`, 4 frames) and walk (`walking-8-frames`) in south, north, east, template
  mode, 2026-11-20 (6 generations). Walk south frame 7 turned her around, so it is a copy of
  frame 3. Idle feet pinned to frame 0 (bottom 4 rows), as for the lelaki.
- `player_sheet.png`: same 8x9 layout as the lelaki (idle / walk / run x down, up, side).
  Picked in game from the dev tools (F1). Preview: `preview_player_sheet.png`.

Silat combo (2026-11-20, template mode, 9 generations per character + 1 for the north kick):
- `atk1_jab` (`lead-jab`, 3 frames), `atk2_cross` (`cross-punch`, 6 frames), `atk3_kick`
  (`roundhouse-kick`, 7 frames) in south, east, north (`base/animations/<name>/<dir>/`).
- **north kick is `high-kick`** (PixelLab animation `atk3_kick_north`): the roundhouse turned the
  character to face the camera mid-spin.
- In `player_sheet.png` rows 9-17 (8 columns x 18 rows now): blocks of three facings
  (down, up, side) for jab, cross, kick. Hit frames (fist/foot furthest out): 1, 5, 4.
