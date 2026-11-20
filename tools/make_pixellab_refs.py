#!/usr/bin/env python3
"""Cut small style-reference images (<= 256 px) from our asset packs for PixelLab.
PixelLab doesn't store references; they are sent (base64) with each request.
Usage (from repo root): python3 tools/make_pixellab_refs.py   (requires Pillow)
Output: docs/references/pixellab/<group>/*.png and palettes.json
"""
import json
from pathlib import Path
from PIL import Image

OUT = Path("docs/references/pixellab")
SWAMP = Path("assets/tilesets/dark_swamp")
UI = Path("assets/ui/dark_ages/ui_tilesheet.png")


def save(img, group, name):
    (OUT / group).mkdir(parents=True, exist_ok=True)
    assert img.width <= 256 and img.height <= 256, name
    img.save(OUT / group / f"{name}.png")


def palette(paths, n=24):
    """Most common opaque colours across images, as hex."""
    counts = {}
    for p in paths:
        for c, rgba in Image.open(p).convert("RGBA").getcolors(1 << 20):
            if rgba[3] > 200:
                counts[rgba[:3]] = counts.get(rgba[:3], 0) + c
    top = sorted(counts, key=counts.get, reverse=True)[:n]
    return ["#%02x%02x%02x" % c for c in top]


# --- swamp environment
water = Image.open(SWAMP / "generated/swamp_water_blob.png").convert("RGBA")
ground = Image.open(SWAMP / "generated/swamp_ground_blob.png").convert("RGBA")
save(Image.open(SWAMP / "raw/WaterAnimation.png").convert("RGBA").crop((0, 0, 96, 144)), "swamp", "water_autotile")
save(Image.open(SWAMP / "raw/GroundTileset.png").convert("RGBA").crop((0, 0, 96, 144)), "swamp", "leafy_grass_autotile")
props = SWAMP / "generated/props"
for name in ("rock", "stone_mushroom", "grass_tuft_small", "bridge_vertical_a", "water_reeds_a"):
    save(Image.open(props / f"{name}.png").convert("RGBA"), "swamp", name)
save(Image.open(SWAMP / "raw/Altar0.png").convert("RGBA"), "swamp", "altar")
# a 4x3 tile scene sample (water edge + grass) for tilesets / mood
scene = Image.new("RGBA", (192, 144))
scene.paste(Image.open(SWAMP / "raw/WaterAnimation.png").convert("RGBA").crop((0, 0, 96, 144)), (0, 0))
scene.paste(Image.open(SWAMP / "raw/GroundTileset.png").convert("RGBA").crop((0, 0, 96, 144)), (96, 0))
save(scene, "swamp", "scene_sample")

# --- UI
ui = Image.open(UI).convert("RGBA")
for name, box in {"window_frame": (0, 0, 96, 96), "slot": (192, 96, 224, 128),
                  "slot_selected": (256, 96, 288, 128), "banner": (128, 96, 192, 128),
                  "icons_row": (0, 224, 128, 256), "bars": (192, 128, 384, 192)}.items():
    save(ui.crop(box), "ui", name)

pal = {
    "swamp": palette(sorted((OUT / "swamp").glob("*.png"))),
    "ui": ["#dcc47c", "#9f8873", "#c19149", "#2e322a", "#406c91", "#15202f"],  # from the pack README
}
(OUT / "palettes.json").write_text(json.dumps(pal, indent=2) + "\n")
print("refs:", sorted(str(p.relative_to(OUT)) for p in OUT.rglob("*.png")))
print("swamp palette:", pal["swamp"][:8], "...")
