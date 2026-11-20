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
## Silat combo (attack: J or left click): jab, cross, kick. Pressing attack again during a
## strike queues the next one; the combo resets after the kick or when you stop pressing.
const COMBO := [Anim.ATK1, Anim.ATK2, Anim.ATK3]
const HIT_FRAME := [1, 5, 4]           ## frame where the fist or foot is furthest out
const HIT_DAMAGE := [1, 1, 2]
const HOLD := [0.06, 0.14, 0.1]        ## extra seconds on the last frame before the next strike
const LUNGE := [35.0, 50.0, 70.0]      ## px/s forward until the hit frame
const HIT_REACH := 24.0                ## centre of the hit circle, in front of the body
const HIT_RADIUS := 16.0
const HITSTOP := 0.07                  ## the strike freezes this long when it lands
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

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
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
	velocity = input * (run_speed if running else speed)
	move_and_slide()
	var anim: int = Anim.IDLE
	if input != Vector2.ZERO:
		_update_facing(input)
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
	for i in 3:
		if event.is_action_pressed("tool_%d" % (i + 1)):
			current_tool = i
			tool_changed.emit(current_tool)
	if event.is_action_pressed("interact"):
		use_requested.emit(current_tool, target_cell())
	if event.is_action_pressed("attack"):
		attack()


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
	var a: int = COMBO[_combo]
	_anim_time += delta * ANIM_FPS[a]
	var lunging: bool = _anim_time < HIT_FRAME[_combo] and not _target_in_reach()
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


## The hit circle in front of the body: where fists and feet land.
func _hit_circle_centre() -> Vector2:
	return global_position + Vector2(0, -16) + facing * HIT_REACH


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
