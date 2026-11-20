#!/usr/bin/env python3
"""Generate pixel art in our style with PixelLab's "generate with style" (v2) API.

The API token is NOT read here: in our cloud environment a proxy adds it to requests
for api.pixellab.ai. To run this locally, set PIXELLAB_TOKEN in your environment.

Usage (from repo root):
  python3 tools/pixellab_style.py --name house \
      --refs docs/references/pixellab/swamp/altar.png docs/references/pixellab/swamp/rock.png \
      --desc "traditional Malay kampung house on stilts" --out assets/sprites/kampung/raw

Output size = largest side of the reference images (PixelLab rule); smaller refs give
more variations per call (e.g. ~145 px -> 4 images, ~64 px -> 16 images).
"""
import argparse, base64, json, os, sys, time, urllib.request
from pathlib import Path

API = "https://api.pixellab.ai/v2"


def call(method, path, body=None):
    req = urllib.request.Request(API + path, method=method,
                                 data=json.dumps(body).encode() if body is not None else None)
    req.add_header("Content-Type", "application/json")
    if os.environ.get("PIXELLAB_TOKEN"):
        req.add_header("Authorization", "Bearer " + os.environ["PIXELLAB_TOKEN"])
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            return json.loads(r.read() or b"{}")
    except urllib.error.HTTPError as e:
        sys.exit(f"HTTP {e.code}: {e.read().decode()[:800]}")


def style_image(path):
    from PIL import Image
    w, h = Image.open(path).size
    return {"image": {"type": "base64", "base64": base64.b64encode(Path(path).read_bytes()).decode(), "format": "png"},
            "width": w, "height": h}


def find_images(obj):
    """Collect base64 images from a job response, whatever its exact shape."""
    out = []
    if isinstance(obj, dict):
        if obj.get("type") == "base64" and "base64" in obj:
            out.append(obj["base64"])
        else:
            for v in obj.values():
                out += find_images(v)
    elif isinstance(obj, list):
        for v in obj:
            out += find_images(v)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--name", required=True)
    ap.add_argument("--refs", nargs="+", required=True)
    ap.add_argument("--desc", required=True)
    ap.add_argument("--style", default="Dark gritty top-down 3/4 RPG pixel art, muted earthy colours, dark outlines, "
                                       "same shading, detail level and pixel size as the references.")
    ap.add_argument("--out", required=True)
    ap.add_argument("--seed", type=int)
    a = ap.parse_args()

    body = {"style_images": [style_image(p) for p in a.refs], "description": a.desc,
            "style_description": a.style, "no_background": True}
    if a.seed is not None:
        body["seed"] = a.seed
    job = call("POST", "/generate-with-style-v2", body)
    print("submitted:", {k: v for k, v in job.items() if k != "images"})
    job_id = job.get("background_job_id") or job.get("job_id") or job.get("id")
    while True:
        time.sleep(8)
        st = call("GET", f"/background-jobs/{job_id}")
        status = st.get("status")
        print("status:", status)
        if status in ("completed", "failed", "error", "cancelled"):
            break
    if status != "completed":
        sys.exit(json.dumps(st)[:1500])
    imgs = list(dict.fromkeys(find_images(st.get("last_response", st))))  # API repeats images; dedupe
    out = Path(a.out); out.mkdir(parents=True, exist_ok=True)
    for i, b in enumerate(imgs):
        (out / f"{a.name}_{i:02d}.png").write_bytes(base64.b64decode(b))
    meta = {k: v for k, v in st.items() if k != "last_response"}
    meta["usage"] = (st.get("last_response") or {}).get("usage")
    print("saved", len(imgs), "images to", out, "| job meta:", json.dumps(meta)[:500])


if __name__ == "__main__":
    main()
