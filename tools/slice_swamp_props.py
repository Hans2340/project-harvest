#!/usr/bin/env python3
"""Cut the Dark Swamp props sheet into individual PNGs + repeatable bridge strips.
Usage (from repo root): python3 tools/slice_swamp_props.py   (requires Pillow)"""
from pathlib import Path
from PIL import Image

raw = Path("assets/tilesets/dark_swamp/raw")
out = Path("assets/tilesets/dark_swamp/generated/props")
out.mkdir(parents=True, exist_ok=True)
sheet = Image.open(raw / "PropsTileset.png").convert("RGBA")

# name: (x0, y0, x1, y1) measured from the sheet's alpha islands
PROPS = {
    "rock": (0, 55, 35, 89),
    "grass_tuft_small": (58, 60, 75, 84),
    "stone_mushroom": (59, 13, 78, 38),
    "bridge_vertical_a": (109, 1, 171, 88),
    "bridge_vertical_b": (205, 5, 267, 96),
    "water_reeds_a": (393, 14, 414, 35),
    "water_reeds_b": (393, 59, 413, 86),
    "muck_a": (428, 72, 450, 94),
    "muck_b": (495, 63, 512, 82),
    "muck_c": (508, 1, 525, 31),
}
for name, box in PROPS.items():
    sheet.crop(box).save(out / f"{name}.png")

# Repeatable strips (texture_repeat in Godot): vertical = 8 planks of bridge B,
# horizontal = upper horizontal bridge piece.
sheet.crop((205, 14, 267, 86)).save(out / "bridge_strip_vertical.png")    # 62 x 72
sheet.crop((284, 0, 380, 48)).save(out / "bridge_strip_horizontal.png")   # 96 x 48
print("props written to", out)
