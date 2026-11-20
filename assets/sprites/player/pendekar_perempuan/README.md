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
