#!/usr/bin/env python3
"""Turn a PixelLab tileset JSON (GET /v2/tilesets/{id}) into our Wang tile sheets + a demo.
Usage: python3 tools/pixellab_wang_demo.py <tileset.json> <name>
Writes assets/tilesets/kampung/raw/<name>_24.png (index = corner mask NW1 NE2 SW4 SE8, 4 per row)
and assets/tilesets/kampung/<name>_48.png (2x, matches the swamp pack's pixel size)."""
import json, base64, io, sys
from PIL import Image

src, name = sys.argv[1], sys.argv[2]
d = json.load(open(src))["tileset"]
T = d["tile_size"]["width"]
bit = {"NW": 1, "NE": 2, "SW": 4, "SE": 8}
tiles = {}
for t in d["tiles"]:
    m = sum(b for k, b in bit.items() if t["corners"][k] == "upper")
    tiles[m] = Image.open(io.BytesIO(base64.b64decode(t["image"]["base64"]))).convert("RGBA")
sheet = Image.new("RGBA", (4 * T, 4 * T))
for m, im in tiles.items():
    sheet.paste(im, ((m % 4) * T, (m // 4) * T))
sheet.save(f"assets/tilesets/kampung/raw/{name}_{T}.png")
sheet.resize((8 * T, 8 * T), Image.NEAREST).save(f"assets/tilesets/kampung/{name}_{2 * T}.png")


def demo(V):
    H, W = len(V) - 1, len(V[0]) - 1
    img = Image.new("RGBA", (W * T, H * T))
    for y in range(H):
        for x in range(W):
            m = V[y][x] + V[y][x + 1] * 2 + V[y + 1][x] * 4 + V[y + 1][x + 1] * 8
            img.paste(tiles[m], (x * T, y * T))
    return img.resize((W * T * 2, H * T * 2), Image.NEAREST)


if __name__ == "__main__":
    W, H = 12, 8
    V = [[0] * (W + 1) for _ in range(H + 1)]
    for y in range(2, 7):
        for x in range(3, 9):
            V[y][x] = 1
    for x in range(W + 1):
        V[4][x] = 1
    for y in range(0, 3):
        V[y][6] = V[y][7] = 1
    demo(V).save(f"docs/references/concept/{name}-demo.png")
    print("ok", len(tiles), "tiles")
