class_name Player
extends CharacterBody2D
## Top-down player: 4-direction movement, tool selection, and using the tile in front.
## The farm decides what a tool does; the player only says "use tool X on cell Y",
## which keeps it easy to sync over the network for co-op later.

signal tool_changed(tool: int)
signal use_requested(tool: int, cell: Vector2i)

enum Tool { HOE, SEEDS, WATER }
const TOOL_NAMES := ["Cangkul (hoe)", "Benih padi (seeds)", "Air (watering)"]

@export var speed: float = 90.0
## Grid size of the current zone (farm = 32, swamp = 48). Set by the zone.
@export var tile_size: float = 32.0

var facing := Vector2.DOWN
var current_tool: int = Tool.HOE
var can_move := true

@onready var sprite: Sprite2D = $Sprite


func _physics_process(_delta: float) -> void:
	var input := Vector2.ZERO
	if can_move:
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	if input != Vector2.ZERO:
		_update_facing(input)


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
	match facing:
		Vector2.DOWN:
			sprite.frame = 0
		Vector2.UP:
			sprite.frame = 1
		_:
			sprite.frame = 2
	sprite.flip_h = facing == Vector2.LEFT
