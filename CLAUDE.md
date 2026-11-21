# Project Harvest: notes for Claude

## Godot version: 4.7 only
- The project uses **Godot 4.7** (`config/features` in `project.godot`). Always run and test with 4.7.
  Never use another version: other versions rewrite `.import` files (new `uid`s) and cause merge conflicts.
- Check with `godot --version` (must start with `4.7.stable`). If it's missing or wrong, install it:
  ```bash
  curl -sSfL -o /tmp/godot47.zip https://github.com/godotengine/godot/releases/download/4.7-stable/Godot_v4.7-stable_linux.x86_64.zip
  mkdir -p /opt/godot47 && unzip -qo /tmp/godot47.zip -d /opt/godot47 && rm -f /tmp/godot47.zip
  ln -sf /opt/godot47/Godot_v4.7-stable_linux.x86_64 /usr/local/bin/godot
  ```

## Story, world and content: read the lore first
- **Before any story, world, dialogue, NPC, zone or asset-content work, read `docs/lore.md` and
  `docs/game-design-proposed.md`** (leoxent's lore and decisions), plus `docs/opening-scene.md` for
  cinematic work. They take priority over older text in `docs/game-design.md`.
- **Religion rules** (full text in `docs/lore.md`): unseen beings are creations of God, never
  protectors, prayed to or asked for help; no offerings, jampi, azimat or incense rituals shown as
  good; pantang larang that depend on spirits are never shown as true; Islam is part of village life,
  shown with respect, never as magic; no Quran verses or Arabic writing in art.
- **Names:** the old healer is **Tok Senik**; boundary stones are **Batu Sempadan** (not keramat);
  powers are **Bakat** (good deeds) and **Anugerah** (Pawang class only); Mata Batin → Firasat.
- **Timeline:** in the prologue the kampung is still at peace (the Ordo arrive on day 3);
  only foreshadowing before that.
- Suggestion numbers: `game-design-proposed.md` uses S25–S30; new ones continue after the highest.

## Running and testing
- Import once after pulling (run twice; the first pass may log font errors): `godot --headless --path . --import`
- Tests (each prints `RESULT: PASS/FAIL`): `for t in tests/test_*.gd; do godot --headless --path . -s $t; done`
- Test scripts run with `-s` compile before autoloads exist: don't name autoloads or `class_name`
  classes statically in tests; reach them via `root.get_node("GameState")` or instances.
- Screenshots: `xvfb-run -a -s "-screen 0 1280x720x24" godot --path . --rendering-driver opengl3 -s <script>`
- Don't commit Godot editor noise (`.import` / `project.godot` churn you didn't intend).

## Team & repo
- Friends collaborate through pull requests. leoxent does the player sprites.
- Third-party packs (Hypnobius Dark Swamp + Dark Ages UI) may not be redistributed: **keep the repo private**.
  See `CREDITS.md`.
- Design decisions live in `docs/game-design.md` (approved vs suggestions). Record new decisions there.
- Art tools: PixelLab (token on the cloud environment, `tools/pixellab_*.py`) and SpriteCook
  (style-reference ids in `spritecook-assets.json`).
