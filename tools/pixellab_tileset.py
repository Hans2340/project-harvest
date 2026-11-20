#!/usr/bin/env python3
"""Create a 2-terrain Wang tileset with PixelLab (standard mode, ~1 generation) and save
the raw JSON, then build our sheets with tools/pixellab_wang_demo.py.

The token is added by our cloud environment's proxy; locally set PIXELLAB_TOKEN.
Usage:
  python3 tools/pixellab_tileset.py --name kampung_grass_sand \
     --lower "dark mossy grass" --upper "pale river sand" \
     --lower-ref docs/references/pixellab/tileset/grass_ref_24.png \
     --upper-ref docs/references/pixellab/tileset/sand_ref_24.png
"""
import argparse, base64, json, os, subprocess, sys, time, urllib.request
from pathlib import Path

API = "https://api.pixellab.ai/v2"


def call(method, path, body=None):
    req = urllib.request.Request(API + path, method=method,
                                 data=json.dumps(body).encode() if body is not None else None,
                                 headers={"Content-Type": "application/json"})
    if os.environ.get("PIXELLAB_TOKEN"):
        req.add_header("Authorization", "Bearer " + os.environ["PIXELLAB_TOKEN"])
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            return json.loads(r.read() or b"{}")
    except urllib.error.HTTPError as e:
        sys.exit(f"HTTP {e.code}: {e.read().decode()[:800]}")


def ref(p):
    return {"type": "base64", "base64": base64.b64encode(Path(p).read_bytes()).decode(), "format": "png"}


ap = argparse.ArgumentParser()
ap.add_argument("--name", required=True)
ap.add_argument("--lower", required=True)
ap.add_argument("--upper", required=True)
ap.add_argument("--transition", default="")
ap.add_argument("--lower-ref")
ap.add_argument("--upper-ref")
ap.add_argument("--lower-walkable", default="true")
ap.add_argument("--upper-walkable", default="true")
ap.add_argument("--tile", type=int, default=24)
a = ap.parse_args()

body = {"lower_description": a.lower, "upper_description": a.upper, "transition_description": a.transition,
        "tile_size": {"width": a.tile, "height": a.tile}, "mode": "standard", "view": "high top-down",
        "transition_size": 0.0, "detail": "medium detail", "shading": "basic shading",
        "lower_walkable": a.lower_walkable == "true", "upper_walkable": a.upper_walkable == "true"}
if a.lower_ref:
    body["lower_reference_image"] = ref(a.lower_ref)
if a.upper_ref:
    body["upper_reference_image"] = ref(a.upper_ref)
job = call("POST", "/create-tileset", body)
print("submitted", job.get("tileset_id"))
while True:
    time.sleep(8)
    st = call("GET", f"/background-jobs/{job['background_job_id']}")
    if st.get("status") in ("completed", "failed", "error"):
        break
if st.get("status") != "completed":
    sys.exit(json.dumps(st)[:1500])
ts = call("GET", f"/tilesets/{job['tileset_id']}")
raw = Path("assets/tilesets/kampung/raw"); raw.mkdir(parents=True, exist_ok=True)
(raw / f"{a.name}.json").write_text(json.dumps(ts))
print("cost:", (st.get("usage") or {}).get("generations"), "generation(s)")
subprocess.run([sys.executable, "tools/pixellab_wang_demo.py", str(raw / f"{a.name}.json"), a.name], check=True)
