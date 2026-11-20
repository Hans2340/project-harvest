class_name Player
extends CharacterBody2D
## Top-down player: 4-direction movement, tool selection, and using the tile in front.
## The zone decides what a tool does; the player only says "use tool X on cell Y",
## which keeps it easy to sync over the network for co-op later.

signal tool_changed(tool: int)
signal use_requested(tool: int, cell: Vector2i)
## A strike reached its hit frame. `step` is 0..2 in the combo; `hit` says whether it landed.
signal struck(step: int, hit: bool)

enum Tool { HOE, SEEDS, WATER }
const TOOL_NAMES := ["Cangkul (hoe)", "Benih padi (seeds)", "Air (watering)"]

@export var speed: float = 90.0
## Speed while holding Shift.
@export var run_speed: float = 160.0
## Grid size of the current zone (48 px for kampung and swamp). Set by the zone.
@export var tile_size: float = 32.0

## Sprite sheet: 8 columns, 18 rows. Rows come in blocks of three facings
## (down, up, side; left = side flipped), one block per animation below.
enum Anim { IDLE, WALK, RUN, ATK1, ATK2, ATK3 }
const ANIM_FRAMES := [4, 8, 8, 3, 6, 7]
const ANIM_FPS := [5.0, 10.0, 14.0, 12.0, 16.0, 14.0]
## Silat combo (attack: J, or left click on a target): jab, cross, kick. Pressing attack again during a
## strike queues the next one; the combo resets after the kick or when you stop pressing.
const COMBO := [Anim.ATK1, Anim.ATK2, Anim.ATK3]
const HIT_FRAME := [1, 5, 4]           ## frame where the fist or foot is furthest out
const HIT_DAMAGE := [1, 1, 2]
const HOLD := [0.06, 0.14, 0.1]        ## extra seconds on the last frame before the next strike
const LUNGE := [35.0, 50.0, 70.0]      ## px/s forward until the hit frame
const HIT_REACH := 24.0                ## centre of the hit circle, in front of the body
const HIT_RADIUS := 16.0
const HITSTOP := 0.07                  ## the strike freezes this long when it lands
## Auto-target (langkah): a strike turns to the best target within AUTO_RANGE and steps in
## (at most half a tile) to punching distance before it lands. Targets in front (or in the held direction) win over
## nearer ones behind. Nothing in range: the strike goes the way you face.
const AUTO_RANGE := HIT_REACH + 24.0   ## from the body: punching distance plus half a tile of step
const FRONT_BIAS := 0.55               ## a target in front counts as this much nearer
const DASH_SPEED := 280.0
const DASH_MAX := 0.35                 ## seconds of stepping in per strike, at most
## Running feel: the body lifts 1 px in the airborne half of each stride, and dust kicks up on
## each footfall (run frames 0 and 4) and when a run starts or stops.
const RUN_LIFT_FRAMES := [1, 2, 5, 6]
const RUN_STEP_FRAMES := [0, 4]
## Sprite offset as set in the scene (feet at the node's origin).
const SPRITE_OFFSET := Vector2(0, -18)

var facing := Vector2.DOWN
var current_tool: int = Tool.HOE
var can_move := true
var _anim: int = Anim.IDLE
var _anim_time := 0.0
var _last_col := -1
var _combo := -1        ## index into COMBO while attacking, -1 otherwise
var _queued := false
var _hit_done := false
var _hitstop := 0.0
var _target: Node2D = null   ## the strike's auto-target, if any
var _dash_time := 0.0

## Click-to-move (left click). On the ground: walk there, round houses and trees (hold the
## button to keep following the cursor). On something hittable: walk up to it and strike. On a
## cell the zone wants a tool used on (sawah, ripe padi): walk next to it and use the tool.
## Any movement key takes control back.
enum Click { NONE, WALK, ATTACK, USE }
const ARRIVE := 2.0
const FOLLOW_REPATH := 0.15        ## seconds between re-paths while holding the button
const STUCK_TIME := 0.5
var nav: NavGrid = null            ## built on the first click (the zone sets camera limits first)
var cursor := ClickCursor.new()
var _path := PackedVector2Array()
var _click: int = Click.NONE
var _click_target: Node2D = null
var _click_cell := Vector2i.ZERO
var _following := false
var _repath := 0.0
var _stuck := 0.0

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	cursor.player = self
	add_child(cursor)
	var gs := get_node_or_null("/root/GameState")
	if gs:
		_apply_character(gs.character)
		gs.character_changed.connect(_apply_character)


## Swap to another character's sheet (same 8x18 layout), keeping the current frame.
func _apply_character(id: String) -> void:
	var tex: Texture2D = GameState.character_sheet(id)
	if tex:
		sprite.texture = tex


func _physics_process(delta: float) -> void:
	if _combo >= 0:
		_attack_process(delta)
		return
	var input := Vector2.ZERO
	if can_move:
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var running := Input.is_action_pressed("run")
	var spd := run_speed if running else speed
	if input != Vector2.ZERO or not can_move:
		cancel_click()
		velocity = input * spd
	else:
		velocity = _follow_path(delta, spd)
	move_and_slide()
	var moving := velocity.length() > 1.0
	var anim: int = Anim.IDLE
	if moving:
		_update_facing(velocity)
		anim = Anim.RUN if running else Anim.WALK
	if anim != _anim:
		if anim == Anim.RUN or _anim == Anim.RUN:
			_puff(1.3)   # pushing off into a run, or skidding out of one
		_anim = anim
		_anim_time = 0.0
		_last_col = -1
	_anim_time += delta * ANIM_FPS[_anim]
	_update_frame()


func _unhandled_input(event: InputEvent) -> void:
	if not can_move:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			click_at(get_global_mouse_position())
			_following = _click == Click.WALK
		else:
			_following = false
		get_viewport().set_input_as_handled()
		return
	for i in 3:
		if event.is_action_pressed("tool_%d" % (i + 1)):
			current_tool = i
			tool_changed.emit(current_tool)
	if event.is_action_pressed("interact"):
		use_requested.emit(current_tool, target_cell())
	if event.is_action_pressed("attack"):
		attack()


## What a left click at world point `p` does (see Click).
func click_at(p: Vector2) -> void:
	if not can_move:
		return
	var t := hittable_at(p)
	if t:
		_set_click(Click.ATTACK)
		_click_target = t
		if is_attacking() or _in_strike_range(t):
			_path.clear()
			attack()
			_click = Click.NONE
		else:
			_path_to(t.global_position)
		return
	var cell := Vector2i(floori(p.x / tile_size), floori(p.y / tile_size))
	if is_use_target(cell):
		_set_click(Click.USE)
		_click_cell = cell
		_path_to_use(cell)
		return
	_set_click(Click.WALK)
	_path_to(p)
	cursor.mark(p)


func cancel_click() -> void:
	_path.clear()
	_click = Click.NONE
	_click_target = null
	_following = false


func is_walking_path() -> bool:
	return not _path.is_empty()


## The hittable whose body is under the point (a little forgiving), or null.
func hittable_at(p: Vector2) -> Node2D:
	for n in get_tree().get_nodes_in_group("hittable"):
		if n.hit_center().distance_to(p) <= n.hit_radius() + 10.0:
			return n
	return null


## The zone wants the current tool used on this cell when clicked (sawah, ripe padi...).
func is_use_target(cell: Vector2i) -> bool:
	var zone := get_tree().current_scene
	return zone != null and zone.has_method("is_click_use_target") and zone.is_click_use_target(current_tool, cell)


func _set_click(kind: int) -> void:
	cancel_click()
	_click = kind
	_stuck = 0.0


func _ensure_nav() -> void:
	if nav:
		return
	var cam := get_node_or_null("Camera") as Camera2D
	var area := Rect2(0, 0, 4096, 4096)
	if cam and cam.limit_right < 1000000:
		area = Rect2(cam.limit_left, cam.limit_top, cam.limit_right - cam.limit_left, cam.limit_bottom - cam.limit_top)
	nav = NavGrid.new()
	var ex: Array[RID] = [get_rid()]
	nav.build(get_world_2d(), area, collision_mask, ex)


func _path_to(p: Vector2) -> void:
	_ensure_nav()
	_path = nav.find_path(global_position, p)


## Stand on the neighbouring tile nearest to us, facing the cell.
func _path_to_use(cell: Vector2i) -> void:
	_ensure_nav()
	var c := (Vector2(cell) + Vector2(0.5, 0.5)) * tile_size
	var best := PackedVector2Array()
	var best_len := INF
	for d in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		var stand: Vector2 = c + d * tile_size
		if not nav.is_walkable(nav.cell_of(stand)):
			continue
		var path := nav.find_path(global_position, stand)
		if path.is_empty() and global_position.distance_to(stand) > ARRIVE:
			continue
		var length := _path_length(path)
		if length < best_len:
			best_len = length
			best = path
	if best_len == INF:
		cancel_click()
		return
	_path = best
	if _path.is_empty():
		_arrive()


func _path_length(path: PackedVector2Array) -> float:
	var length := 0.0
	var prev := global_position
	for q in path:
		length += prev.distance_to(q)
		prev = q
	return length


func _in_strike_range(t: Node2D) -> bool:
	return t.hit_center().distance_to(_body_centre()) <= AUTO_RANGE


## Velocity along the click path this frame (zero when there's none). Also handles following
## the held button, striking a target once in range, and giving up when stuck.
func _follow_path(delta: float, spd: float) -> Vector2:
	if _following and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_repath -= delta
		if _repath <= 0.0:
			_repath = FOLLOW_REPATH
			_path_to(get_global_mouse_position())
	if _click == Click.ATTACK and is_instance_valid(_click_target) and _in_strike_range(_click_target):
		_path.clear()
		_click = Click.NONE
		attack()
		return Vector2.ZERO
	if _path.is_empty():
		return Vector2.ZERO
	var to := _path[0] - global_position
	if to.length() <= ARRIVE:
		_path.remove_at(0)
		if _path.is_empty():
			_arrive()
			return Vector2.ZERO
		to = _path[0] - global_position
	# Stuck against something the grid missed: give up.
	_stuck = _stuck + delta if get_real_velocity().length() < spd * 0.2 else 0.0
	if _stuck > STUCK_TIME:
		cancel_click()
		return Vector2.ZERO
	return to.normalized() * minf(spd, to.length() / delta)


func _arrive() -> void:
	if _click == Click.USE:
		var c := (Vector2(_click_cell) + Vector2(0.5, 0.5)) * tile_size
		_update_facing(c - global_position)
		if target_cell() == _click_cell:
			use_requested.emit(current_tool, _click_cell)
	_click = Click.NONE
	_click_target = null


func is_attacking() -> bool:
	return _combo >= 0


## Start the combo, or queue the next strike if one is already playing.
func attack() -> void:
	if not can_move:
		return
	if _combo < 0:
		_start_strike(0)
	else:
		_queued = true


func _start_strike(step: int) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input != Vector2.ZERO:
		_update_facing(input)   # each strike can turn to a new target
	_target = pick_target(facing if input == Vector2.ZERO else input.normalized())
	if _target:
		_update_facing(_target.hit_center() - _body_centre())
	_dash_time = 0.0
	_combo = step
	_queued = false
	_hit_done = false
	_anim = COMBO[step]
	_anim_time = 0.0
	_last_col = -1
	_puff(0.7)


func _attack_process(delta: float) -> void:
	if _hitstop > 0.0:
		_hitstop -= delta
		return
	if _step_in(delta):
		return
	var a: int = COMBO[_combo]
	_anim_time += delta * ANIM_FPS[a]
	var lunging: bool = _target == null and _anim_time < HIT_FRAME[_combo] and not _target_in_reach()
	velocity = facing * LUNGE[_combo] if lunging else Vector2.ZERO
	move_and_slide()
	if not _hit_done and _anim_time >= HIT_FRAME[_combo]:
		_hit_done = true
		_strike()
	if _anim_time >= ANIM_FRAMES[a] + HOLD[_combo] * ANIM_FPS[a]:
		if _queued and _combo < COMBO.size() - 1:
			_start_strike(_combo + 1)
		else:
			_combo = -1
			_anim = Anim.IDLE
			_anim_time = 0.0
			_last_col = -1
	_update_frame()


## The best hittable within AUTO_RANGE: nearest, with the ones in the `front` direction
## counted nearer. Null when nothing is in range.
func pick_target(front: Vector2) -> Node2D:
	var best: Node2D = null
	var best_score := INF
	var me := _body_centre()
	for n in get_tree().get_nodes_in_group("hittable"):
		var to: Vector2 = n.hit_center() - me
		var d := to.length()
		if d > AUTO_RANGE:
			continue
		var score := d * (FRONT_BIAS if d > 0.0 and to.normalized().dot(front) > 0.5 else 1.0)
		if score < best_score:
			best_score = score
			best = n
	return best


## Step in toward the target until its centre sits in our hit circle, holding the wind-up
## frame. Returns true while stepping (the strike waits). Follows a moving target.
func _step_in(delta: float) -> bool:
	if _target == null or _dash_time >= DASH_MAX:
		return false
	if not is_instance_valid(_target):
		_target = null
		return false
	var to := _stand_point() - global_position
	if to.length() <= 3.0:
		_dash_time = DASH_MAX   # in place: no more stepping this strike
		return false
	_dash_time += delta
	velocity = to.normalized() * minf(DASH_SPEED, to.length() / delta)
	move_and_slide()
	_update_frame()
	return true


## Where to stand so the target's centre is the middle of our hit circle (lines us up on the
## axis we face, since the sprite only faces four ways).
func _stand_point() -> Vector2:
	return _target.hit_center() - Vector2(0, -16) - facing * HIT_REACH


func _body_centre() -> Vector2:
	return global_position + Vector2(0, -16)


## The hit circle in front of the body: where fists and feet land.
func _hit_circle_centre() -> Vector2:
	return _body_centre() + facing * HIT_REACH


## Something is already close enough to hit: stop the lunge so we don't walk into it.
func _target_in_reach() -> bool:
	var centre := _hit_circle_centre()
	for n in get_tree().get_nodes_in_group("hittable"):
		if n.hit_center().distance_to(centre) <= n.hit_radius():
			return true
	return false


## Hit everything in the "hittable" group whose hit circle overlaps the one in front of us.
## A hittable node has `hit_center() -> Vector2`, `hit_radius() -> float` and
## `take_hit(damage: int, from_dir: Vector2, heavy: bool)`.
func _strike() -> void:
	var centre := _hit_circle_centre()
	var landed := false
	for n in get_tree().get_nodes_in_group("hittable"):
		if n.hit_center().distance_to(centre) <= HIT_RADIUS + n.hit_radius():
			n.take_hit(HIT_DAMAGE[_combo], facing, _combo == COMBO.size() - 1)
			landed = true
	if landed:
		_hitstop = HITSTOP
		_shake(2.0 if _combo == COMBO.size() - 1 else 1.0)
	struck.emit(_combo, landed)


func _shake(strength: float) -> void:
	var cam := get_node_or_null("Camera") as Camera2D
	if cam == null:
		return
	var t := create_tween()
	for i in 4:
		t.tween_property(cam, "offset", Vector2(randf_range(-1, 1), randf_range(-1, 1)) * strength, 0.025)
	t.tween_property(cam, "offset", Vector2.ZERO, 0.03)


## The tile in front of the player's feet.
func target_cell() -> Vector2i:
	var p := global_position + facing * (tile_size * 0.7)
	return Vector2i(floori(p.x / tile_size), floori(p.y / tile_size))


func _update_facing(dir: Vector2) -> void:
	if absf(dir.x) > absf(dir.y):
		facing = Vector2.RIGHT if dir.x > 0 else Vector2.LEFT
	else:
		facing = Vector2.DOWN if dir.y > 0 else Vector2.UP
	sprite.flip_h = facing == Vector2.LEFT


func _update_frame() -> void:
	var face := 0
	match facing:
		Vector2.DOWN:
			face = 0
		Vector2.UP:
			face = 1
		_:
			face = 2
	var col := int(_anim_time) % int(ANIM_FRAMES[_anim])
	if _anim >= Anim.ATK1:
		col = mini(int(_anim_time), ANIM_FRAMES[_anim] - 1)   # strikes play once
	sprite.frame_coords = Vector2i(col, _anim * 3 + face)
	var running := _anim == Anim.RUN
	sprite.offset = SPRITE_OFFSET + (Vector2(0, -1) if running and col in RUN_LIFT_FRAMES else Vector2.ZERO)
	if running and col != _last_col and col in RUN_STEP_FRAMES:
		_puff(1.0)
	_last_col = col


## Dust at the feet, drifting back from the way the player faces. It goes on the zone (the
## player's parent) so it stays where the foot landed.
func _puff(size: float) -> void:
	if get_parent() == null:
		return
	DustPuff.spawn(get_parent(), global_position + Vector2(0, -1), -facing, size)
