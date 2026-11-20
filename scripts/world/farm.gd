class_name Farm
extends Node2D
## The player's farm zone. Owns the farm state (tilled / watered / crops) and
## applies tool actions. Keeping all rules here (not in the player) makes it
## the single source of truth, which co-op can sync later.
##
## PROTOTYPE NOTE: the map is built from the ASCII LAYOUT below so we can
## iterate without art. Later it will be painted by hand in the TileMap editor.

enum T { GRASS, PATH, TILLED, WATERED, WATER, TREE, WALL, FLOOR, BED }

const LEGEND := {
	".": T.GRASS, "=": T.PATH, "~": T.WATER, "T": T.TREE,
	"W": T.WALL, "F": T.FLOOR, "B": T.BED,
}
const TILE := 32
const WAKE_CELL := Vector2i(4, 4)   ## floor tile next to the bed
const START_CELL := Vector2i(6, 9)  ## just outside the door

const LAYOUT := [
	"TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT",
	"T.T...................................TT",
	"TT.WWWWWWWW..........................T.T",
	"T..WBFFFFFW............................T",
	"T.TWFFFFFFW.................~~~~~~~...TT",
	"TT.WFFFFFFW................~~~~~~~~~.T.T",
	"T..WFFFFFFW...............~~~~~~~~~~~..T",
	"T.TWWWFWWWW...............~~~~~~~~~~~.TT",
	"TT....=....................~~~~~~~~~.T.T",
	"T.....=.....................~~~~~~~....T",
	"T.T...=...............................TT",
	"TT....=..............................T.T",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TT....==============.................T.T",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TT....=..............................T.T",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TT....=..............................T.T",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT",]

@export var default_crop: CropData = preload("res://resources/crops/padi.tres")

## Vector2i -> { "crop": CropData, "stage": int, "growth": int, "watered": bool, "sprite": Sprite2D }
var plots := {}

@onready var ground: TileMapLayer = $Ground
@onready var crops_root: Node2D = $YSort/Crops
@onready var player: Player = $YSort/Player
@onready var highlight: Sprite2D = $Highlight
@onready var night: CanvasModulate = $Night
@onready var hud: Hud = $HUD


func _ready() -> void:
	_build_map()
	player.position = _cell_feet(START_CELL)
	var cam: Camera2D = player.get_node("Camera")
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = LAYOUT[0].length() * TILE
	cam.limit_bottom = LAYOUT.size() * TILE
	cam.reset_smoothing()
	player.use_requested.connect(_on_use_requested)
	player.tool_changed.connect(hud.set_tool)
	hud.set_tool(player.current_tool)
	GameState.day_changed.connect(_on_day_changed)
	GameState.time_changed.connect(_update_lighting)
	_update_lighting(int(GameState.minutes))
	hud.show_message("Welcome to your farm. 1/2/3 = tools, E = use.")


func _process(_delta: float) -> void:
	var c := player.target_cell()
	highlight.position = Vector2(c * TILE) + Vector2(TILE, TILE) / 2.0


# ---------------------------------------------------------------- map

func _build_map() -> void:
	for y in LAYOUT.size():
		var row: String = LAYOUT[y]
		for x in row.length():
			_set_tile(Vector2i(x, y), LEGEND.get(row[x], T.GRASS))


func _set_tile(cell: Vector2i, t: int) -> void:
	ground.set_cell(cell, 0, Vector2i(t, 0))


func _tile(cell: Vector2i) -> int:
	return ground.get_cell_atlas_coords(cell).x


func _cell_feet(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 6)


# ---------------------------------------------------------------- actions

func _on_use_requested(tool: int, cell: Vector2i) -> void:
	if _tile(cell) == T.BED:
		_sleep()
		return
	if _try_harvest(cell):
		return
	match tool:
		Player.Tool.HOE:
			_hoe(cell)
		Player.Tool.SEEDS:
			_plant(cell, default_crop)
		Player.Tool.WATER:
			_water(cell)


func _hoe(cell: Vector2i) -> void:
	if _tile(cell) != T.GRASS:
		hud.show_message("You can only hoe grass.")
		return
	_set_tile(cell, T.TILLED)
	plots[cell] = {"crop": null, "stage": 0, "growth": 0, "watered": false, "sprite": null}


func _plant(cell: Vector2i, crop: CropData) -> void:
	if not plots.has(cell):
		hud.show_message("Hoe the ground first.")
		return
	var plot: Dictionary = plots[cell]
	if plot.crop != null:
		return
	if not GameState.take_item(crop.seed_item):
		hud.show_message("No %s seeds left." % crop.display_name)
		return
	var s := Sprite2D.new()
	s.texture = crop.texture
	s.hframes = crop.stage_count
	s.offset = Vector2(0, -TILE / 2.0)
	s.position = Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 1)
	crops_root.add_child(s)
	plot.crop = crop
	plot.sprite = s


func _water(cell: Vector2i) -> void:
	if not plots.has(cell):
		hud.show_message("Nothing to water here.")
		return
	plots[cell].watered = true
	_set_tile(cell, T.WATERED)


func _try_harvest(cell: Vector2i) -> bool:
	if not plots.has(cell):
		return false
	var plot: Dictionary = plots[cell]
	var crop: CropData = plot.crop
	if crop == null or plot.stage < crop.stage_count - 1:
		return false
	GameState.add_item(crop.harvest_item, crop.harvest_amount)
	hud.show_message("Harvested %d %s!" % [crop.harvest_amount, crop.display_name])
	plot.sprite.queue_free()
	plot.crop = null
	plot.sprite = null
	plot.stage = 0
	plot.growth = 0
	return true


func _sleep() -> void:
	hud.show_message("You sleep until morning...")
	GameState.advance_day()


# ---------------------------------------------------------------- day cycle

func _on_day_changed(new_day: int) -> void:
	for cell in plots:
		var plot: Dictionary = plots[cell]
		var crop: CropData = plot.crop
		if crop != null and plot.watered and plot.stage < crop.stage_count - 1:
			plot.growth += 1
			if plot.growth >= crop.days_per_stage:
				plot.growth = 0
				plot.stage += 1
				plot.sprite.frame = plot.stage
		plot.watered = false
		_set_tile(cell, T.TILLED)
	player.position = _cell_feet(WAKE_CELL)
	player.get_node("Camera").reset_smoothing()
	hud.show_message("Day %d begins." % new_day)


## Tint the world by time of day.
func _update_lighting(minutes: int) -> void:
	var h := minutes / 60.0
	var day_col := Color(1, 1, 1)
	var dusk_col := Color(1.0, 0.82, 0.68)
	var night_col := Color(0.32, 0.36, 0.55)
	var c := day_col
	if h < 7.0:
		c = dusk_col.lerp(day_col, h - 6.0)
	elif h < 17.0:
		c = day_col
	elif h < 19.0:
		c = day_col.lerp(dusk_col, (h - 17.0) / 2.0)
	elif h < 21.0:
		c = dusk_col.lerp(night_col, (h - 19.0) / 2.0)
	else:
		c = night_col
	night.color = c
