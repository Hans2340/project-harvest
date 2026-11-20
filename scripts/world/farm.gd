class_name Farm
extends Node2D
## The player's farm zone. Applies tool actions to FarmState (the persistent
## plot data) and draws it. All rules run here, not in the player, so co-op
## can sync them later.
##
## PROTOTYPE NOTE: the map is built from the ASCII LAYOUT below so we can
## iterate without art. Later it will be painted by hand in the TileMap editor.

enum T { GRASS, PATH, TILLED, WATERED, WATER, TREE, WALL, FLOOR, BED }

const LEGEND := {
	".": T.GRASS, "=": T.PATH, "~": T.WATER, "T": T.TREE,
	"W": T.WALL, "F": T.FLOOR, "B": T.BED,
}
const TILE := 32
const START_CELL := Vector2i(6, 9)  ## just outside the door (first launch)

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
	"TT....==================================",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TT....=..............................T.T",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TT....=..............................T.T",
	"T.....=................................T",
	"T.T...=...............................TT",
	"TTTTTT=TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT",
]

@export var default_crop_id: String = "padi"

var _crop_sprites := {}  ## Vector2i -> Sprite2D

@onready var ground: TileMapLayer = $Ground
@onready var crops_root: Node2D = $YSort/Crops
@onready var player: Player = $YSort/Player
@onready var highlight: Sprite2D = $Highlight
@onready var night: CanvasModulate = $Night
@onready var hud: Hud = $HUD


func _ready() -> void:
	_build_map()
	_sync_plots()
	player.tile_size = TILE
	Zones.place_player(self, player, _cell_feet(START_CELL))
	var cam: Camera2D = player.get_node("Camera")
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = LAYOUT[0].length() * TILE
	cam.limit_bottom = LAYOUT.size() * TILE
	cam.reset_smoothing()
	player.use_requested.connect(_on_use_requested)
	player.tool_changed.connect(hud.set_tool)
	hud.set_tool(player.current_tool)
	FarmState.plots_changed.connect(_sync_plots)
	GameState.day_changed.connect(_on_day_changed)
	GameState.time_changed.connect(_update_lighting)
	_update_lighting(int(GameState.minutes))
	if GameState.day == 1 and FarmState.plots.is_empty():
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


## Redraw soil tiles and crop sprites from FarmState.
func _sync_plots() -> void:
	for cell in FarmState.plots:
		var plot: Dictionary = FarmState.plots[cell]
		_set_tile(cell, T.WATERED if plot.watered else T.TILLED)
		var crop := FarmState.crop_data(plot.crop)
		var sprite: Sprite2D = _crop_sprites.get(cell)
		if crop == null:
			if sprite:
				sprite.queue_free()
				_crop_sprites.erase(cell)
			continue
		if sprite == null:
			sprite = Sprite2D.new()
			sprite.offset = Vector2(0, -TILE / 2.0)
			sprite.position = Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 1)
			crops_root.add_child(sprite)
			_crop_sprites[cell] = sprite
		sprite.texture = crop.texture
		sprite.hframes = crop.stage_count
		sprite.frame = plot.stage


# ---------------------------------------------------------------- actions

func _on_use_requested(tool: int, cell: Vector2i) -> void:
	if _tile(cell) == T.BED:
		_sleep()
		return
	if FarmState.is_ripe(cell):
		var crop := FarmState.crop_data(FarmState.plots[cell].crop)
		FarmState.harvest(cell)
		GameState.add_item(crop.harvest_item, crop.harvest_amount)
		hud.show_message("Harvested %d %s!" % [crop.harvest_amount, crop.display_name])
		return
	match tool:
		Player.Tool.HOE:
			_hoe(cell)
		Player.Tool.SEEDS:
			_plant(cell, default_crop_id)
		Player.Tool.WATER:
			_water(cell)


func _hoe(cell: Vector2i) -> void:
	if FarmState.plots.has(cell) or _tile(cell) != T.GRASS:
		hud.show_message("You can only hoe grass.")
		return
	FarmState.till(cell)


func _plant(cell: Vector2i, crop_id: String) -> void:
	if not FarmState.plots.has(cell):
		hud.show_message("Hoe the ground first.")
		return
	if FarmState.plots[cell].crop != "":
		return
	var crop := FarmState.crop_data(crop_id)
	if not GameState.take_item(crop.seed_item):
		hud.show_message("No %s seeds left." % crop.display_name)
		return
	FarmState.plant(cell, crop_id)


func _water(cell: Vector2i) -> void:
	if not FarmState.plots.has(cell):
		hud.show_message("Nothing to water here.")
		return
	FarmState.water(cell)


func _sleep() -> void:
	hud.show_message("You sleep until morning...")
	GameState.advance_day()


# ---------------------------------------------------------------- day cycle

func _on_day_changed(new_day: int) -> void:
	player.global_position = $Spawns/bed.global_position
	player.get_node("Camera").reset_smoothing()
	hud.show_message("Day %d begins." % new_day)


func _update_lighting(minutes: int) -> void:
	night.color = DayNight.tint(minutes)
