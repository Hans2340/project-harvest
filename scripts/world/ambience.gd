class_name Ambience
extends Node2D
## Environment life for a zone. A zone creates one after building its map and calls setup().
##
## - Wind: a shared sway shader on trees, grass, reeds and crops (stronger in rain).
## - Water glints (this node, drawn above the ground, below the y-sorted sprites).
## - Sky node (above sprites): drifting cloud shadows, birds, falling leaves.
## - Night: warm pelita lamp lights at houses.
## - FX layer (world space, NOT darkened by the night tint): fireflies, dust motes, rain.

const SWAY_SHADER := preload("res://assets/shaders/wind_sway.gdshader")

static var sway_material: ShaderMaterial

var tile := 48.0
var map_size := Vector2.ZERO
var water_cells: Array = []
var firefly_cells: Array = []

var _glints: Array = []        # [pos, age, life, length]
var _sky := SkyLayer.new()
var _fx := CanvasLayer.new()
var _fx_draw := FxDraw.new()
var _lamps: Array[PointLight2D] = []
var _rng := RandomNumberGenerator.new()


## Shared material for swaying sprites.
static func get_sway_material() -> ShaderMaterial:
	if sway_material == null:
		sway_material = ShaderMaterial.new()
		sway_material.shader = SWAY_SHADER
	return sway_material


## cfg keys: tile, map_size, water_cells, firefly_cells, lamps (Array[Vector2]),
## sway (Array[CanvasItem]), leaf_trees (Array[Node2D]).
func setup(zone: Node2D, cfg: Dictionary) -> void:
	_rng.randomize()
	tile = cfg.get("tile", 48.0)
	map_size = cfg.get("map_size", Vector2.ZERO)
	water_cells = cfg.get("water_cells", [])
	firefly_cells = cfg.get("firefly_cells", [])
	for item in cfg.get("sway", []):
		(item as CanvasItem).material = get_sway_material()
	_sky.ambience = self
	_sky.z_index = 10
	zone.add_child(_sky)
	for t in cfg.get("leaf_trees", []):
		_sky.add_child(_make_leaves(t))
	_sky.make_clouds(map_size)
	for p in cfg.get("lamps", []):
		_lamps.append(_make_lamp(p))
	_fx.layer = 1
	_fx.follow_viewport_enabled = true
	_fx_draw.ambience = self
	_fx.add_child(_fx_draw)
	zone.add_child(_fx)
	GameState.weather_changed.connect(func(_w): _apply_weather())
	_apply_weather()


func _apply_weather() -> void:
	get_sway_material().set_shader_parameter("gust", 1.4 if GameState.is_raining() else 0.0)


# ---------------------------------------------------------------- time helpers

static func hours() -> float:
	return GameState.minutes / 60.0


## 0 by day, 1 at night (fades 18:00-19:30).
static func night_factor() -> float:
	return clampf((hours() - 18.0) / 1.5, 0.0, 1.0)


static func day_factor() -> float:
	return 1.0 - night_factor()


## World rect currently on screen (with a margin).
func view_rect(margin := 32.0) -> Rect2:
	var vp := get_viewport()
	var inv := vp.get_canvas_transform().affine_inverse()
	var r := Rect2(inv * Vector2.ZERO, vp.get_visible_rect().size / vp.get_canvas_transform().get_scale())
	return r.grow(margin)


func random_point_in(cells: Array) -> Vector2:
	if cells.is_empty():
		return Vector2(-999, -999)
	var c: Vector2i = cells[_rng.randi() % cells.size()]
	return Vector2(c) * tile + Vector2(_rng.randf() * tile, _rng.randf() * tile)


# ---------------------------------------------------------------- water glints

func _process(delta: float) -> void:
	var target := mini(48, water_cells.size() / 5)
	while _glints.size() < target:
		_glints.append([random_point_in(water_cells), 0.0, _rng.randf_range(1.2, 2.6), _rng.randi_range(2, 5)])
	for g in _glints:
		g[1] += delta
	_glints = _glints.filter(func(g): return g[1] < g[2])
	for l in _lamps:
		l.energy = night_factor() * 1.6
		l.visible = l.energy > 0.01
	queue_redraw()


func _draw() -> void:
	var dim := 0.35 + 0.65 * day_factor()
	for g in _glints:
		var a := sin(PI * g[1] / g[2]) * 0.55 * dim
		var p: Vector2 = (g[0] as Vector2).floor()
		draw_rect(Rect2(p, Vector2(g[3] * 2, 2)), Color(0.78, 0.88, 0.9, a))


# ---------------------------------------------------------------- lamps & leaves

func _make_lamp(p: Vector2) -> PointLight2D:
	var light := PointLight2D.new()
	var grad := GradientTexture2D.new()
	grad.fill = GradientTexture2D.FILL_RADIAL
	grad.fill_from = Vector2(0.5, 0.5)
	grad.fill_to = Vector2(1.0, 0.5)
	grad.width = 320
	grad.height = 320
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(1, 1, 1, 0))
	grad.gradient = g
	light.texture = grad
	light.color = Color(1.0, 0.68, 0.32)
	light.energy = 0.0
	light.position = p
	add_child(light)
	return light


func _make_leaves(tree: Node2D) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.amount = 3
	p.lifetime = 6.0
	p.preprocess = 6.0
	p.position = tree.position + Vector2(0, -88)
	p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	p.emission_rect_extents = Vector2(44, 20)
	p.direction = Vector2(0.4, 1)
	p.spread = 25.0
	p.initial_velocity_min = 4.0
	p.initial_velocity_max = 10.0
	p.gravity = Vector2(6, 9)
	p.scale_amount_min = 2.0
	p.scale_amount_max = 2.0
	var ramp := Gradient.new()
	ramp.set_color(0, Color(0.36, 0.42, 0.18))
	ramp.set_color(1, Color(0.55, 0.42, 0.2))
	p.color_initial_ramp = ramp
	var fade := Gradient.new()
	fade.set_color(0, Color(1, 1, 1, 0.9))
	fade.set_color(1, Color(1, 1, 1, 0))
	p.color_ramp = fade
	return p


# ================================================================= sky (above sprites)

class SkyLayer:
	extends Node2D
	var ambience: Ambience
	var _clouds: Array[Sprite2D] = []
	var _birds: Array = []      # [pos, vel, flap_phase]
	var _bird_timer := 6.0
	var _rng := RandomNumberGenerator.new()

	func make_clouds(map_size: Vector2) -> void:
		_rng.randomize()
		for i in 4:
			var s := Sprite2D.new()
			s.texture = _cloud_texture(i)
			s.scale = Vector2(4, 4)
			s.position = Vector2(_rng.randf() * map_size.x, _rng.randf() * map_size.y)
			add_child(s)
			_clouds.append(s)

	func _cloud_texture(seed_i: int) -> Texture2D:
		var rng := RandomNumberGenerator.new()
		rng.seed = 99 + seed_i
		var img := Image.create(80, 40, false, Image.FORMAT_RGBA8)
		var blobs := []
		for k in 6:
			blobs.append([Vector2(rng.randf_range(16, 64), rng.randf_range(12, 28)), rng.randf_range(9, 16)])
		for y in 40:
			for x in 80:
				var best := 9.0
				for b in blobs:
					best = minf(best, Vector2(x, y).distance_to(b[0]) / b[1])
				var a := 0.0
				if best < 0.7:
					a = 0.11
				elif best < 1.0:
					a = 0.06
				img.set_pixel(x, y, Color(0.02, 0.04, 0.05, a))
		return ImageTexture.create_from_image(img)

	func _process(delta: float) -> void:
		var wind := 14.0 if GameState.is_raining() else 7.0
		var size := ambience.map_size
		var cloud_alpha := ambience.day_factor() * (0.4 if GameState.is_raining() else 1.0)
		for c in _clouds:
			c.position.x += wind * delta
			if c.position.x > size.x + 200:
				c.position = Vector2(-200, _rng.randf() * size.y)
			c.modulate.a = cloud_alpha
		# birds: a small flock now and then, by day, not in rain
		_bird_timer -= delta
		if _bird_timer <= 0.0:
			_bird_timer = _rng.randf_range(14.0, 30.0)
			if ambience.day_factor() > 0.5 and not GameState.is_raining():
				var view := ambience.view_rect(0)
				var start := Vector2(view.position.x - 20, view.position.y + _rng.randf_range(20, view.size.y * 0.6))
				var vel := Vector2(_rng.randf_range(38, 55), _rng.randf_range(-6, 6))
				for k in _rng.randi_range(3, 5):
					_birds.append([start + Vector2(-k * 12, (k % 2) * 8 + k * 3), vel, _rng.randf() * TAU])
		for b in _birds:
			b[0] += b[1] * delta
			b[2] += delta * 9.0
		var view_r := ambience.view_rect(80)
		_birds = _birds.filter(func(b): return view_r.has_point(b[0]))
		queue_redraw()

	func _draw() -> void:
		for b in _birds:
			var p: Vector2 = (b[0] as Vector2).floor()
			var up := sin(b[2]) > 0.0
			var col := Color(0.12, 0.11, 0.1)
			draw_rect(Rect2(p, Vector2(2, 2)), col)
			var wy := -2 if up else 2
			draw_rect(Rect2(p + Vector2(-4, wy), Vector2(4, 2)), col)
			draw_rect(Rect2(p + Vector2(2, wy), Vector2(4, 2)), col)


# ================================================================= FX (unaffected by night tint)

class FxDraw:
	extends Node2D
	var ambience: Ambience
	var _flies: Array = []     # [pos, target, phase]
	var _dust: Array = []      # [pos, vel]
	var _drops: Array = []     # [pos, speed]
	var _splashes: Array = []  # [pos, age]
	var _rng := RandomNumberGenerator.new()

	func _ready() -> void:
		_rng.randomize()
		for i in 70:
			var p := ambience.random_point_in(ambience.firefly_cells)
			_flies.append([p, p, _rng.randf() * TAU])

	func _process(delta: float) -> void:
		var view := ambience.view_rect(16)
		# fireflies wander between random points
		for f in _flies:
			var to: Vector2 = f[1] - f[0]
			if to.length() < 4.0:
				f[1] = f[0] + Vector2(_rng.randf_range(-40, 40), _rng.randf_range(-30, 30))
			else:
				f[0] += to.normalized() * 10.0 * delta
			f[2] += delta * 3.0
		# dust motes near the camera by day
		while _dust.size() < 14:
			_dust.append([view.position + Vector2(_rng.randf() * view.size.x, _rng.randf() * view.size.y),
				Vector2(_rng.randf_range(2, 6), _rng.randf_range(-3, 1))])
		for d in _dust:
			d[0] += d[1] * delta
			if not view.has_point(d[0]):
				d[0] = view.position + Vector2(_rng.randf() * view.size.x, _rng.randf() * view.size.y)
		# rain
		var want := 160 if GameState.is_raining() else 0
		while _drops.size() < want:
			_drops.append([view.position + Vector2(_rng.randf() * view.size.x, _rng.randf() * view.size.y), _rng.randf_range(260, 340)])
		if _drops.size() > want:
			_drops.resize(want)
		for d in _drops:
			d[0] += Vector2(-0.35, 1.0) * d[1] * delta
			if d[0].y > view.end.y or _rng.randf() < 0.012:
				_splashes.append([d[0], 0.0])
				d[0] = Vector2(view.position.x + _rng.randf() * (view.size.x + 60), view.position.y - _rng.randf() * 40)
		for s in _splashes:
			s[1] += delta
		_splashes = _splashes.filter(func(s): return s[1] < 0.3)
		queue_redraw()

	func _draw() -> void:
		var night := Ambience.night_factor()
		var day := 1.0 - night
		if night > 0.0:
			for f in _flies:
				var blink := 0.5 + 0.5 * sin(f[2])
				var a: float = night * blink * (0.4 if GameState.is_raining() else 1.0)
				var p: Vector2 = (f[0] as Vector2).floor()
				draw_rect(Rect2(p - Vector2(1, 1), Vector2(4, 4)), Color(0.85, 1.0, 0.4, a * 0.25))
				draw_rect(Rect2(p, Vector2(2, 2)), Color(0.95, 1.0, 0.55, a))
		if day > 0.0 and not GameState.is_raining():
			for d in _dust:
				draw_rect(Rect2((d[0] as Vector2).floor(), Vector2(2, 2)), Color(1.0, 0.95, 0.8, 0.22 * day))
		if not _drops.is_empty():
			var rc := Color(0.7, 0.78, 0.88, 0.5).lerp(Color(0.35, 0.42, 0.55, 0.45), night)
			for d in _drops:
				var p: Vector2 = (d[0] as Vector2).floor()
				draw_line(p, p + Vector2(-2, 7), rc, 1.0)
			for s in _splashes:
				var r: float = 1.0 + s[1] * 10.0
				draw_rect(Rect2((s[0] as Vector2).floor() - Vector2(r, 0), Vector2(r * 2, 1)), Color(rc, rc.a * (1.0 - s[1] / 0.3)))
