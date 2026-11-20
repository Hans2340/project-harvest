class_name SunShadows
extends CanvasGroup
## Cast shadows that move with the sun. Trees, rocks and the player get a black copy of their own
## sprite laid on the ground away from the sun (their silhouette). Houses get a solid box shadow:
## their footprint pulled towards the shadow direction, short and hard-edged. At night, things
## near a pelita lamp cast a short shadow away from it.
##
## All copies are drawn inside this CanvasGroup and the group is faded as a whole, so where two
## shadows overlap the ground does not get darker.
##
## A zone adds one under its Shadows node, then calls add_caster() for each sprite and add_box()
## for each building.

signal asar_started

## Darkness of a full-strength shadow.
const ALPHA := 0.45
## Shadows on a rainy (overcast) day.
const RAIN_FACTOR := 0.2
## Pelita lamps: reach, height of the flame above the ground, and how strong their shadows get.
const LAMP_RADIUS := 260.0
const LAMP_HEIGHT := 90.0
const LAMP_ALPHA := 0.8
## The foot shadow stays at least this strong (a little less at night), so things never float.
const FOOT_MIN := 0.6
## How far an oval-only shadow slides per unit of shadow vector (world px): about 30 px at
## 8:30, a few px at noon.
const OVAL_SHIFT := 50.0
## Silhouette shadows keep at least this much depth down (or up) the screen, so a shadow thrown
## straight east or west still reads as a flattened shape, not a line.
const SILHOUETTE_MIN_Y := 0.3
## The Asar message only shows if you are about when it starts (not hours later on a zone change).
const ASAR_WINDOW := 60

## The last day the Asar message was shown, shared across zones.
static var asar_day := -1

## Each entry: [source Sprite2D, pivot Node2D, shadow Sprite2D, foot shadow Polygon2D or null,
## oval only]
var _casters: Array = []
## Each entry: [footprint corners on the ground, height, roof overhang, Polygon2D]
var _boxes: Array = []
var _lamps: Array[Vector2] = []


func _init() -> void:
	self_modulate = Color(1, 1, 1, ALPHA)


## Ground points under the pelita lamps (night shadows fall away from these).
func set_lamps(points: Array) -> void:
	_lamps.clear()
	for p in points:
		_lamps.append(p)


## Gives `src` a silhouette shadow, hinged on its lowest drawn pixel (its feet). `foot` (world px)
## adds an oval shadow under it as well, drawn in the same group so the two merge into one shape.
## With `oval_only` there is no silhouette: just the oval, sliding a little away from the sun.
## That suits sprites too complex to lay flat, like the fruit trees' wide canopy and roots.
func add_caster(src: Sprite2D, foot := Vector2.ZERO, oval_only := false) -> void:
	var pivot := Node2D.new()
	var sh := Sprite2D.new()
	sh.modulate = Color(0, 0, 0, 1)
	pivot.add_child(sh)
	add_child(pivot)
	var oval: Polygon2D = null
	if foot != Vector2.ZERO:
		oval = Polygon2D.new()
		oval.color = Color(0, 0, 0, 1)
		oval.polygon = foot_oval(foot)
		add_child(oval)
	_casters.append([src, pivot, sh, oval, oval_only and oval != null])
	_sync(src, sh)


## Gives a building a solid box shadow. `footprint` is its floor plan on the ground (the corner
## stilts' feet, world px, in order around it), `height` how tall it stands to the eaves and
## `overhang` how far the roof sticks out past the walls.
func add_box(footprint: PackedVector2Array, height: float, overhang := 0.0) -> void:
	var poly := Polygon2D.new()
	poly.color = Color(0, 0, 0, 1)
	add_child(poly)
	_boxes.append([footprint, height, overhang, poly])


func box_count() -> int:
	return _boxes.size()


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
		var foot := _sync(src, c[2]) * src.scale
		var pivot: Node2D = c[1]
		var ground := (src.global_position + foot).round()
		pivot.transform = ground_transform(vec, ground)
		pivot.visible = str_ > 0.01 and src.is_visible_in_tree() and not c[4]
		(c[2] as Sprite2D).modulate.a = str_
		var oval: Polygon2D = c[3]
		if oval != null:
			oval.position = (ground + vec * OVAL_SHIFT * str_).round() if c[4] else ground
			oval.color.a = maxf(str_, FOOT_MIN * (1.0 - 0.4 * night))
			oval.visible = src.is_visible_in_tree()
	for b in _boxes:
		var fp: PackedVector2Array = b[0]
		var vec := sun_vec
		var str_ := sun_str
		if night > 0.0:
			var lamp := _lamp_shadow(_centre(fp), night)
			if lamp[1] > str_:
				vec = lamp[0]
				str_ = lamp[1]
		var poly: Polygon2D = b[3]
		poly.polygon = box_polygon(fp, b[1], b[2], vec)
		poly.color.a = str_
		poly.visible = str_ > 0.01
	_check_asar()


## The shadow of a box standing on `footprint`: the floor plan joined to the roof outline (the
## plan grown by the overhang) moved `height * vec` across the ground, rounded to whole pixels.
static func box_polygon(footprint: PackedVector2Array, height: float, overhang: float, vec: Vector2) -> PackedVector2Array:
	var c := _centre(footprint)
	var off := vec * height
	var pts := PackedVector2Array()
	for p in footprint:
		pts.append(p.round())
		var out := (p - c).normalized() * overhang
		out.y *= Sun.GROUND_Y
		pts.append((p + out + off).round())
	return Geometry2D.convex_hull(pts)


static func _centre(points: PackedVector2Array) -> Vector2:
	var c := Vector2.ZERO
	for p in points:
		c += p
	return c / maxf(points.size(), 1)

## A hard-edged oval `size` wide and tall, its bottom edge a little below the ground point so it
## sits under the feet rather than in front of them.
static func foot_oval(size: Vector2) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var centre := Vector2(0, -size.y * 0.2)
	for i in 20:
		var a := TAU * i / 20.0
		pts.append((centre + Vector2(cos(a) * size.x / 2.0, sin(a) * size.y / 2.0)).round())
	return pts


## Lays a front-view sprite on the ground: a pixel `z` above its base (local y = -z) lands z * vec
## away, while its width stays left-to-right. The sprite is drawn from the front, so turning its
## width to lie across the light (as a 3D object would) makes a tree look like it fell over;
## skewing and flattening it is how 2D games keep the shadow reading as that tree.
static func ground_transform(vec: Vector2, origin: Vector2) -> Transform2D:
	var v := vec
	if absf(v.y) < SILHOUETTE_MIN_Y:
		v.y = SILHOUETTE_MIN_Y if v.y >= 0.0 else -SILHOUETTE_MIN_Y
	return Transform2D(Vector2(1, 0), -v, origin)


## Where the sprite meets the ground, in its local (unscaled) coordinates: the lowest opaque row,
## at the middle of the opaque pixels in its bottom few rows (a leaning palm's trunk base is not
## under the middle of the picture). Cached per texture and frame.
static func foot_point(src: Sprite2D) -> Vector2:
	var tex := src.texture
	if tex == null:
		return Vector2.ZERO
	var key := "%d:%d:%s:%s" % [tex.get_rid().get_id(), src.frame, src.region_enabled, src.region_rect]
	var rect := src.get_rect()
	var foot: Vector2
	if _foot_cache.has(key):
		foot = _foot_cache[key]
	else:
		var cell := _cell(src)
		var img: Image = _image_cache.get(tex.get_rid().get_id())
		if img == null:
			img = tex.get_image()
			if img != null and img.is_compressed():
				img.decompress()
			_image_cache[tex.get_rid().get_id()] = img
		var bottom := cell.size.y - 1
		var sum_x := 0.0
		var n := 0
		if img != null:
			var found := -1
			for row in range(cell.size.y - 1, -1, -1):
				for x in cell.size.x:
					if img.get_pixel(cell.position.x + x, cell.position.y + row).a > 0.5:
						if found < 0:
							found = row
						sum_x += x + 0.5
						n += 1
				if found >= 0 and row <= found - 3:
					break
			if found >= 0:
				bottom = found
		# x from the cell's left edge, y as rows above the cell's bottom (flip-independent).
		foot = Vector2(sum_x / n if n > 0 else cell.size.x / 2.0, cell.size.y - 1 - bottom)
		_foot_cache[key] = foot
	var fx := foot.x if not src.flip_h else rect.size.x - foot.x
	return Vector2(rect.position.x + fx, rect.end.y - foot.y)


## Local y (unscaled) of the sprite's lowest opaque pixel row.
static func foot_y(src: Sprite2D) -> float:
	return foot_point(src).y


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
## hinged on its base. Returns the base point in the source's local (unscaled) coordinates.
func _sync(src: Sprite2D, sh: Sprite2D) -> Vector2:
	sh.texture = src.texture
	if src.texture == null:
		return Vector2.ZERO
	var rect := src.get_rect()
	var foot := foot_point(src)
	var hinge := foot.y
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
	sh.position = -foot * src.scale
	return foot


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
		var v := dir * clampf(d / LAMP_HEIGHT, 0.25, Sun.MAX_LENGTH)
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

