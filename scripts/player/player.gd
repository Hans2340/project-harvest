class_name Player
extends CharacterBody2D
## Top-down player: 4-direction movement, tool selection, and using the tile in front.
## The zone decides what a tool does; the player only says "use tool X on cell Y",
## which keeps it easy to sync over the network for co-op later.

signal tool_changed(tool: int)
signal use_requested(tool: int, cell: Vector2i)

enum Tool { HOE, SEEDS, WATER }
const TOOL_NAMES := ["Cangkul (hoe)", "Benih padi (seeds)", "Air (watering)"]

@export var speed: float = 90.0
## Speed while holding Shift.
@export var run_speed: float = 160.0
## Grid size of the current zone (48 px for kampung and swamp). Set by the zone.
@export var tile_size: float = 32.0

## Sprite sheet: 8 columns, 9 rows. Rows come in blocks of three facings
## (down, up, side; left = side flipped), one block per animation below.
enum Anim { IDLE, WALK, RUN }
const ANIM_FRAMES := [4, 8, 8]
const ANIM_FPS := [5.0, 10.0, 14.0]
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

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	var gs := get_node_or_null("/root/GameState")
	if gs:
		_apply_character(gs.character)
		gs.character_changed.connect(_apply_character)


## Swap to another character's sheet (same 8x9 layout), keeping the current frame.
func _apply_character(id: String) -> void:
	var tex: Texture2D = GameState.character_sheet(id)
	if tex:
		sprite.texture = tex


func _physics_process(delta: float) -> void:
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
