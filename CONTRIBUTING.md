# Working together

## Branches
- `main` should always open and run in Godot.
- Make a branch per feature: `feature/crop-growth`, `art/player-sprite`, `fix/save-crash`.
- Open a Pull Request into `main` and ask someone to look at it.

## Avoiding merge conflicts in Godot
- **Two people should not edit the same `.tscn` at the same time.** Say in chat
  which scene you're working on.
- Split big scenes into smaller instanced scenes (player, HUD, each building).
- Don't commit the `.godot/` folder (already ignored).
- Do commit the `.import` files next to assets.

## Code style (GDScript)
- Follow the official style guide: tabs, `snake_case` for files/functions/vars,
  `PascalCase` for classes and node names.
- Use static typing where you can (`var speed: float = 80.0`).

## Assets
- Pixel art at 32×32 tiles; characters around 20×36 px. See `docs/game-design.md` → Art direction.
- Put source files (`.aseprite`, `.kra`) next to the exported `.png`.
