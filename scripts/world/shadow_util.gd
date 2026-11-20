class_name ShadowUtil
extends RefCounted
## Soft pixel-art ground shadows (stepped ellipse, drawn at half resolution and scaled 2x so
## the pixel size matches the 2x art). Put them on a layer under the y-sorted sprites.

const INNER_ALPHA := 0.34
const OUTER_ALPHA := 0.18

static var _cache := {}


## A shadow sprite `size` (screen px) wide/tall, centred on `center`.
static func make(center: Vector2, size: Vector2) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = _texture(Vector2i(maxi(2, int(size.x / 2.0)), maxi(2, int(size.y / 2.0))))
	s.scale = Vector2(2, 2)
	s.position = center
	return s


static func _texture(half: Vector2i) -> Texture2D:
	if _cache.has(half):
		return _cache[half]
	var img := Image.create(half.x, half.y, false, Image.FORMAT_RGBA8)
	var c := Vector2(half) / 2.0
	for y in half.y:
		for x in half.x:
			var d := Vector2((x + 0.5 - c.x) / c.x, (y + 0.5 - c.y) / c.y).length()
			var a := 0.0
			if d <= 0.6:
				a = INNER_ALPHA
			elif d <= 1.0:
				a = OUTER_ALPHA
			img.set_pixel(x, y, Color(0.02, 0.03, 0.02, a))
	var tex := ImageTexture.create_from_image(img)
	_cache[half] = tex
	return tex
