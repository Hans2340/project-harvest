#!/usr/bin/env python3
"""Contact sheet of PNGs (numbered) on a grass-coloured background.
Usage: python3 tools/contact_sheet.py "<glob>" out.png [scale] [cols]"""
import glob, sys
from PIL import Image, ImageDraw
fs = sorted(glob.glob(sys.argv[1])); out = sys.argv[2]
scale = int(sys.argv[3]) if len(sys.argv) > 3 else 3; cols = int(sys.argv[4]) if len(sys.argv) > 4 else 10
ims = [Image.open(f).convert("RGBA") for f in fs]
cw = max(i.width for i in ims) + 4; ch = max(i.height for i in ims) + 4
rows = (len(ims) + cols - 1) // cols
c = Image.new("RGBA", (cols * cw, rows * ch), (78, 62, 46, 255)); d = ImageDraw.Draw(c)
for k, im in enumerate(ims):
    x, y = (k % cols) * cw, (k // cols) * ch
    c.alpha_composite(im, (x + 2, y + 2)); d.text((x + 2, y + 1), str(k), fill=(255, 255, 255))
c.resize((c.width * scale, c.height * scale), Image.NEAREST).save(out)
