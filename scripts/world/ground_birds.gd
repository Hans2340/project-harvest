class_name GroundBirds
extends Node2D
## Burung tiung (mynahs) on the ground: they peck, hop a little, and fly off when the player gets
## close, coming back somewhere else later. Out by day only, not in rain.
## Sprites: assets/sprites/kampung/ground/tiung_diri_* (standing), tiung_patuk_* (pecking).

const DIR := "res://assets/sprites/kampung/ground/"
const SCARE_DIST := 64.0
const RETURN_TIME := Vector2(18.0, 40.0)

var spots: Array = []      ## world positions birds may land on
var player: Node2D
var _birds: Array = []     ## [sprite, state, timer, velocity, variant]
var _rng := RandomNumberGenerator.new()


func setup(p_player: Node2D, p_spots: Array, count: int) -> void:
	player = p_player
	spots = p_spots
	_rng.seed = 77
	for i in count:
		var s := Sprite2D.new()
		s.offset = Vector2(0, -8)
		get_parent().add_child(s)   # in the YSort, so birds sort with everything else
		var b := [s, "ground", _rng.randf_range(0.5, 2.0), Vector2.ZERO, i % 4]
		_birds.append(b)
		_land(b)


func _land(b: Array) -> void:
	var s: Sprite2D = b[0]
	for tries in 10:
		var p: Vector2 = spots[_rng.randi() % spots.size()]
		if player == null or p.distance_to(player.global_position) > SCARE_DIST * 3:
			s.position = p
			break
	s.texture = load(DIR + "tiung_diri_%d.png" % b[4])
	s.flip_h = _rng.randf() < 0.5
	s.modulate.a = 1.0
	s.scale = Vector2.ONE
	s.z_index = 0
	b[1] = "ground"
	b[2] = _rng.randf_range(0.6, 2.4)


func _process(delta: float) -> void:
	var out := Ambience.day_factor() > 0.6 and not GameState.is_raining()
	for b in _birds:
		var s: Sprite2D = b[0]
		match b[1]:
			"ground":
				s.visible = out
				b[2] -= delta
				if b[2] <= 0.0:
					var roll := _rng.randf()
					if roll < 0.55:   # peck
						var pecking: bool = s.texture.resource_path.contains("patuk")
						s.texture = load(DIR + ("tiung_diri_%d.png" if pecking else "tiung_patuk_%d.png") % b[4])
					elif roll < 0.85:   # hop
						var hop := Vector2(_rng.randf_range(4, 10) * (-1 if s.flip_h else 1), _rng.randf_range(-3, 3))
						s.position += hop.round()
					else:   # turn round
						s.flip_h = not s.flip_h
					b[2] = _rng.randf_range(0.4, 1.6)
				if out and player and s.position.distance_to(player.global_position) < SCARE_DIST:
					var away := (s.position - player.global_position).normalized()
					b[3] = Vector2(away.x * 70, -60 + away.y * 20)
					s.flip_h = away.x < 0
					s.z_index = 20
					b[1] = "flying"
					b[2] = 2.5
			"flying":
				s.position += b[3] * delta
				b[3].y -= 30 * delta
				s.scale.y = 1.0 if fmod(b[2] * 12.0, 2.0) < 1.0 else 0.6   # wing flap
				b[2] -= delta
				s.modulate.a = clampf(b[2], 0.0, 1.0)
				if b[2] <= 0.0:
					s.visible = false
					b[1] = "away"
					b[2] = _rng.randf_range(RETURN_TIME.x, RETURN_TIME.y)
			"away":
				b[2] -= delta
				if b[2] <= 0.0:
					_land(b)
					s.visible = out


## Birds currently on the ground (for tests).
func on_ground() -> int:
	return _birds.filter(func(b): return b[1] == "ground").size()


func flying() -> int:
	return _birds.filter(func(b): return b[1] == "flying").size()
