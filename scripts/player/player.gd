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

## Sprite sheet: one row per facing (down, up, side), column 0 = standing,
## columns 1..RUN_FRAMES = run cycle.
const RUN_FRAMES := 8
## Run-cycle frames per second at walking speed (scaled up while running).
@export var anim_fps: float = 10.0

var facing := Vector2.DOWN
var current_tool: int = Tool.HOE
var can_move := true
var _anim_time := 0.0

@onready var sprite: Sprite2D = $Sprite


func _physics_process(delta: float) -> void:
	var input := Vector2.ZERO
	if can_move:
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var running := Input.is_action_pressed("run")
	velocity = input * (run_speed if running else speed)
	move_and_slide()
	if input != Vector2.ZERO:
		_update_facing(input)
		_anim_time += delta * anim_fps * (run_speed / speed if running else 1.0)
	else:
		_anim_time = 0.0
	_update_frame(input != Vector2.ZERO)


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


func _update_frame(moving: bool) -> void:
	var row := 0
	match facing:
		Vector2.DOWN:
			row = 0
		Vector2.UP:
			row = 1
		_:
			row = 2
	var col := 0
	if moving:
		col = 1 + int(_anim_time) % RUN_FRAMES
	sprite.frame_coords = Vector2i(col, row)
