# Clock: "kayu ukir" style

Top-right clock in carved wood and gold, with a keris as the hand. Made 2026-11-21 from
leoxent's mockup: text and icons painted out, then each piece converted with PixelLab
`image_to_pixelart` (faithful, strength 200; the bar at 300), and the dial split into layers.

| File | Size | What |
|---|---|---|
| panel.png | 112x56 | date / weather / time panel (left edge sits under the dial) |
| bar.png | 112x22 | money bar |
| dial_ring.png | 64x64 | gold ring with stars, transparent inside |
| dial_hills.png | 64x64 | hills and house silhouette (the sky is drawn in code) |

Switch styles in the dev tools (F1): "Jam: lama / kayu ukir". Saved in `user://settings.cfg`.
The hand is a keris drawn in code with plain lines (`ClockUI.Dial._draw_keris`): a rotated sprite was too blurry at 30x9.
