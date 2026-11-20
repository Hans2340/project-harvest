class_name SunShadows
extends CanvasGroup
## Cast shadows: each tall sprite (tree, house, rock, player) gets a black copy of itself laid on
## the ground and stretched away from the sun, so the shadow has the object's own shape and moves
## with the time of day. At night, objects near a pelita lamp cast a short shadow away from it.
##
## All copies are drawn inside this CanvasGroup and the group is faded as a whole, so where two
## shadows overlap the ground does not get darker. The round contact shadows from ShadowUtil stay
## under everything.
##
## A zone adds one under its Shadows node, then calls add_caster() for each sprite.

signal asar_started

## Darkness of a full-strength shadow.
const ALPHA := 0.3
## Shadows on a rainy (overcast) day.
const RAIN_FACTOR := 0.2
## Pelita lamps: reach, height of the flame above the ground, and how strong their shadows get.
const LAMP_RADIUS := 260.0
const LAMP_HEIGHT := 90.0
const LAMP_ALPHA := 0.8
## The Asar message only shows if you are about when it starts (not hours later on a zone change).
const ASAR_WINDOW := 60

## The last day the Asar message was shown, shared across zones.
static var asar_day := -1

## Each entry: [source Sprite2D, pivot Node2D, shadow Sprite2D, ground depth]
var _casters: Array = []
var _lamps: Array[Vector2] = []


func _init() -> void:
	self_modulate = Color(1, 1, 1, ALPHA)


## Ground points under the pelita lamps (night shadows fall away from these).
func set_lamps(points: Array) -> void:
	_lamps.clear()
	for p in points:
		_lamps.append(p)


## Gives `src` a cast shadow, hinged on its lowest drawn pixel (its feet). `ground_depth`
## (world px) is for things drawn with a floor plan, like a house in this 3/4 view: the bottom
## of the picture is the front of the footprint, so the shadow hinges that far up (mid-footprint)
## instead, and the part of the picture below the hinge casts nothing.
func add_caster(src: Sprite2D, ground_depth := 0.0) -> void:
	var pivot := Node2D.new()
	var sh := Sprite2D.new()
	sh.modulate = Color(0, 0, 0, 1)
	pivot.add_child(sh)
	add_child(pivot)
	_casters.append([src, pivot, sh, ground_depth])
	_sync(src, sh, ground_depth)


func caster_count() -> int:
	return _casters.size()


func _process(_delta: float) -> void:
	var hours: float = GameState.minutes / 60.0
	var season: int = GameState.season_index()
	var sun_vec := _snap(Sun.shadow_vector(hours, season))
	var sun_str: float = Sun.strength(hours, season) * (RAIN_FACTOR if GameState.is_raining() else 1.0)
	var night := Ambience.night_factor()
	for c in _casters:
		var src: Sprite2D = c[0]
		if not is_instance_valid(src):
			continue
		var vec := sun_vec
		var str_ := sun_str
		if night > 0.0:
			var lamp := _lamp_shadow(src.global_position, night)
			if lamp[1] > str_:
				vec = lamp[0]
				str_ = lamp[1]
		var hinge := _sync(src, c[2], c[3]) * src.scale.y
		var pivot: Node2D = c[1]
		pivot.transform = ground_transform(vec, (src.global_position + Vector2(0, hinge)).round())
		pivot.visible = str_ > 0.01 and src.is_visible_in_tree()
		(c[2] as Sprite2D).modulate.a = str_
	_check_asar()


## Lays a sprite on the ground: a pixel `z` above the feet (local y = -z) lands z * vec away,
## and the sprite's width turns to lie across the shadow (foreshortened like the ground), so a
## shadow thrown east or west stays as wide as the body instead of thinning to a line.
static func ground_transform(vec: Vector2, origin: Vector2) -> Transform2D:
	var n := vec.normalized()
	var across := Vector2(n.y, -n.x)
	across.y *= Sun.GROUND_Y
	return Transform2D(across, -vec, origin)


## Local y (unscaled) of the lowest opaque pixel row the sprite draws right now: where it meets
## the ground. Cached per texture and frame.
static func foot_y(src: Sprite2D) -> float:
	var tex := src.texture
	if tex == null:
		return 0.0
	var key := "%d:%d:%s:%s" % [tex.get_rid().get_id(), src.frame, src.region_enabled, src.region_rect]
	if _foot_cache.has(key):
		return _foot_cache[key]
	var rect := src.get_rect()
	var cell := _cell(src)
	var inset := 0
	var img: Image = _image_cache.get(tex.get_rid().get_id())
	if img == null:
		img = tex.get_image()
		if img != null and img.is_compressed():
			img.decompress()
		_image_cache[tex.get_rid().get_id()] = img
	if img != null:
		var found := false
		for row in range(cell.size.y - 1, -1, -1):
			for x in cell.size.x:
				if img.get_pixel(cell.position.x + x, cell.position.y + row).a > 0.5:
					found = true
					break
			if found:
				inset = cell.size.y - 1 - row
				break
	var foot := rect.end.y - inset
	_foot_cache[key] = foot
	return foot


static var _foot_cache := {}
static var _image_cache := {}


## The part of the texture the sprite draws right now.
static func _cell(src: Sprite2D) -> Rect2i:
	if src.region_enabled:
		return Rect2i(src.region_rect)
	var w := src.texture.get_width() / src.hframes
	var h := src.texture.get_height() / src.vframes
	return Rect2i((src.frame % src.hframes) * w, (src.frame / src.hframes) * h, w, h)


## Copies what the source shows right now (frame, flip), so animated sprites keep their shadow,
## cut off below the hinge line. Returns the hinge's local y (unscaled) in the source.
func _sync(src: Sprite2D, sh: Sprite2D, ground_depth: float) -> float:
	sh.texture = src.texture
	if src.texture == null:
		return 0.0
	var rect := src.get_rect()
	var hinge := foot_y(src) - ground_depth / maxf(src.scale.y, 0.001)
	var cell := _cell(src)
	cell.size.y = clampi(ceili(hinge - rect.position.y), 0, cell.size.y)
	sh.region_enabled = true
	sh.region_rect = Rect2(cell)
	sh.hframes = 1
	sh.vframes = 1
	sh.frame = 0
	sh.centered = false
	sh.offset = rect.position
	sh.scale = src.scale
	sh.flip_h = src.flip_h
	sh.flip_v = src.flip_v
	sh.position = Vector2(0, -hinge * src.scale.y)
	return hinge


## [vector, strength] of the shadow from the nearest pelita at `pos`.
func _lamp_shadow(pos: Vector2, night: float) -> Array:
	var best := [Vector2.ZERO, 0.0]
	for l in _lamps:
		var d := pos.distance_to(l)
		if d < 24.0 or d > LAMP_RADIUS:
			continue   # too close: this is the lamp's own house
		var s := night * LAMP_ALPHA * (1.0 - d / LAMP_RADIUS)
		if s <= best[1]:
			continue
		var dir := (pos - l) / d
		var v := dir * clampf(d / LAMP_HEIGHT, 0.35, 2.0)
		v.y *= Sun.GROUND_Y
		if absf(v.y) < Sun.MIN_Y:
			v.y = Sun.MIN_Y if v.y >= 0.0 else -Sun.MIN_Y
		best = [_snap(v), s]
	return best


## Rounds the vector so shadows step instead of shimmering by sub-pixels every frame.
static func _snap(v: Vector2) -> Vector2:
	return (v * 50.0).round() / 50.0


## What the HUD says when Asar starts: read from the shadow on a clear day.
static func asar_message() -> String:
	if GameState.is_raining():
		return "Waktu Asar. (No shadow to read under the rain clouds.)"
	return "Your shadow is now as long as you are tall. Waktu Asar."


func _check_asar() -> void:
	var day_min: int = int(GameState.minutes)
	var asar: int = Sun.asar_minutes(GameState.season_index())
	if asar_day != GameState.day and day_min >= asar and day_min < asar + ASAR_WINDOW:
		asar_day = GameState.day
		asar_started.emit()

