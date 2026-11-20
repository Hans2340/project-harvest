class_name Kampung
extends Node2D
## The main kampung: home, neighbours' houses, sawah and the river. The game starts here.
## 48 px tiles (PixelLab tilesets in the Dark Swamp style). West path -> Paya Bakau (swamp).
##
## Terrain is painted on tile CORNERS (VERTICES below, one char per corner), which is how the
## PixelLab Wang tilesets join up. Each cell picks the tile whose 4 corners match. A cell may
## only mix these pairs: grass/dirt, grass/sawah, grass/sand, water/sand (tests check this).
##
## Corner legend:  g grass   d dirt   s sawah (padi field)   b sand (riverbank)   w river water
##
## Farming: plant padi (tool 2) in the sawah; it is flooded, so it grows every night without
## watering. Press E on ripe padi to harvest. Face your house (the first one) and press E to sleep.

const TILE := 48
const HOUSE_SCALE := 2.0                ## PixelLab houses are 144 px; 2x matches the pack's pixel size
const SAND_WATER_WALKABLE := 4          ## same art as source 3 but no collision (under the jetty)
const JETTY_X := 18
const JETTY_ROWS := Vector2i(25, 30)    ## first and last cell row of the jetty
const KAMPUNG_TINT := Color(0.96, 0.97, 0.93)
const HOUSE_DIR := "res://assets/sprites/kampung/raw/"
const PROPS_DIR := "res://assets/tilesets/dark_swamp/generated/props/"

## terrain pair -> [atlas source, "upper" terrain char] (upper = the terrain whose corners set the mask bits)
const SETS := {"dg": [0, "d"], "gs": [1, "s"], "bg": [2, "b"], "bw": [3, "b"]}
## a cell that is all one terrain -> [source, mask]
const SOLID := {"g": [0, 0], "d": [0, 15], "s": [1, 15], "b": [2, 15], "w": [3, 0]}

## [house variant, bottom-centre cell]. The first one is the player's home.
const HOUSES := [
	[0, Vector2i(11, 9)], [1, Vector2i(24, 9)], [3, Vector2i(11, 18)], [2, Vector2i(24, 18)],
]
## Cells you can face to sleep (front of the home house).
const HOME_DOOR := Rect2i(9, 8, 5, 3)

## Trees (PixelLab, 64 px, drawn at 2x like the houses). [variant, trunk cell].
const TREE_DIR := "res://assets/sprites/trees/"
const TREE_SCALE := 2.0
const PALMS := [   # pokok kelapa: riverbank and yard corners
	[0, Vector2i(3, 24)], [3, Vector2i(9, 24)], [6, Vector2i(13, 23)], [9, Vector2i(23, 24)],
	[12, Vector2i(28, 23)], [1, Vector2i(33, 24)], [5, Vector2i(39, 24)], [14, Vector2i(44, 23)],
	[2, Vector2i(7, 4)], [8, Vector2i(29, 4)], [11, Vector2i(7, 20)], [15, Vector2i(29, 20)],
]
const FRUIT_TREES := [   # pokok buah (durian / rambutan): kampung edges
	[0, Vector2i(2, 3)], [6, Vector2i(14, 1)], [10, Vector2i(21, 1)], [1, Vector2i(27, 1)],
	[13, Vector2i(37, 2)], [4, Vector2i(42, 2)], [7, Vector2i(2, 8)], [3, Vector2i(3, 17)],
	[12, Vector2i(32, 7)], [9, Vector2i(32, 18)], [14, Vector2i(45, 12)], [2, Vector2i(45, 20)],
]

const TUFTS := [Vector2i(3, 3), Vector2i(2, 17), Vector2i(32, 2), Vector2i(32, 13), Vector2i(45, 24),
	Vector2i(8, 23), Vector2i(26, 23), Vector2i(40, 23)]
const ROCKS := [Vector2i(10, 25), Vector2i(29, 25), Vector2i(44, 1), Vector2i(1, 22)]
const REEDS := [Vector2i(4, 29), Vector2i(11, 30), Vector2i(25, 29), Vector2i(33, 30), Vector2i(42, 29)]

const VERTICES := [
	"ggggggggggggggggggggggggggggggggggggggggggggggg",
	"ggggggggggggggggggggggggggggggggggggggggggggggg",
	"ggggggggggggggggggggggggggggggggggggggggggggggg",
	"ggggggdddddddddddddddddddddddddgggggggggggggggg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"dddddddddddddddddddddddddddddddgggsssssssssssgg",
	"dddddddddddddddddddddddddddddddgggggggggggggggg",
	"dddddddddddddddddddddddddddddddgggggggggggggggg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"gggggggggggggggggdddggggggggggggggsssssssssssgg",
	"gggggggggggggggggdddggggggggggggggggggggggggggg",
	"gggggggggggggggggdddggggggggggggggggggggggggggg",
	"ggggggggggggggggggggggggggggggggggggggggggggggg",
	"gggggggggggggbbbbbbbgggggggggggggggbbbbbbgggggg",
	"bbbggggggbbbbbbbbbbbbbbbgggggggbbbbbbbbbbbbbbgg",
	"bbbbbbbbbbbbbwwwwwwwbbbbbbbbbbbbbbbwwwwwwbbbbbb",
	"wwwbbbbbbwwwwwwwwwwwwwwwbbbbbbbwwwwwwwwwwwwwwbb",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
]

var _crop_sprites := {}   ## Vector2i -> Sprite2D

@onready var ground: TileMapLayer = $Ground
@onready var decor: Node2D = $Decor
@onready var ysort: Node2D = $YSort
@onready var crops_root: Node2D = $YSort/Crops
@onready var player: Player = $YSort/Player
@onready var night: CanvasModulate = $Night
@onready var hud: Hud = $HUD


func _ready() -> void:
	_build_ground()
	_build_jetty()
	_build_props()
	_sync_crops()
	var w := _width() * TILE
	var h := _height() * TILE
	var exit: Area2D = $ExitToMangrove
	ZoneUtil.build_bounds(self, w, h, Rect2(0, exit.position.y - TILE, 0, TILE * 2))
	player.tile_size = TILE
	Zones.place_player(self, player, $Spawns/home.global_position)
	var cam: Camera2D = player.get_node("Camera")
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = w
	cam.limit_bottom = h
	cam.reset_smoothing()
	player.use_requested.connect(_on_use_requested)
	player.tool_changed.connect(hud.set_tool)
	hud.set_tool(player.current_tool)
	FarmState.plots_changed.connect(_sync_crops)
	GameState.day_changed.connect(_on_day_changed)
	GameState.time_changed.connect(_update_lighting)
	_update_lighting(int(GameState.minutes))
	if GameState.day == 1 and FarmState.plots.is_empty():
		hud.show_message("Kampung. Plant padi in the sawah (2 + E). Shift = run.")


func _width() -> int:
	return (VERTICES[0] as String).length() - 1


func _height() -> int:
	return VERTICES.size() - 1


func _corner(x: int, y: int) -> String:
	return (VERTICES[y] as String)[x]


func _in_map(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < _width() and cell.y < _height()


## True if all 4 corners of the cell are sawah (a full paddy tile).
func is_sawah(cell: Vector2i) -> bool:
	if not _in_map(cell):
		return false
	for d in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]:
		if _corner(cell.x + d.x, cell.y + d.y) != "s":
			return false
	return true


## Returns [source, atlas coords] for a cell, or [] if its corners mix an unsupported pair.
func tile_for(cell: Vector2i) -> Array:
	var c := [_corner(cell.x, cell.y), _corner(cell.x + 1, cell.y),
		_corner(cell.x, cell.y + 1), _corner(cell.x + 1, cell.y + 1)]   # NW NE SW SE
	var kinds := {}
	for k in c:
		kinds[k] = true
	if kinds.size() == 1:
		var s: Array = SOLID[c[0]]
		return [s[0], Vector2i(s[1] % 4, s[1] / 4)]
	var key_chars := kinds.keys()
	key_chars.sort()
	var key := "".join(key_chars)
	if kinds.size() != 2 or not SETS.has(key):
		return []
	var source: int = SETS[key][0]
	var upper: String = SETS[key][1]
	var mask := 0
	for i in 4:
		if c[i] == upper:
			mask |= 1 << i
	return [source, Vector2i(mask % 4, mask / 4)]


# ---------------------------------------------------------------- building

func _build_ground() -> void:
	for y in _height():
		for x in _width():
			var t := tile_for(Vector2i(x, y))
			if t.is_empty():
				push_error("Kampung: unsupported terrain mix at %s" % Vector2i(x, y))
				continue
			ground.set_cell(Vector2i(x, y), t[0], t[1])


## Wooden jetty from the sand out over the river (walkable water underneath).
func _build_jetty() -> void:
	for y in range(JETTY_ROWS.x, JETTY_ROWS.y + 1):
		var cell := Vector2i(JETTY_X, y)
		var t := tile_for(cell)
		if t[0] == 3:
			ground.set_cell(cell, SAND_WATER_WALKABLE, t[1])
	var strip := Sprite2D.new()
	strip.texture = load(PROPS_DIR + "bridge_strip_vertical.png")
	strip.centered = false
	strip.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	strip.region_enabled = true
	strip.region_rect = Rect2(0, 0, 62, (JETTY_ROWS.y - JETTY_ROWS.x + 1) * TILE)
	strip.position = Vector2(JETTY_X * TILE + TILE / 2.0 - 31, JETTY_ROWS.x * TILE + 24)
	decor.add_child(strip)


func _build_props() -> void:
	for h in HOUSES:
		var tex: Texture2D = load(HOUSE_DIR + "rumah_kampung_%02d.png" % h[0])
		var cell: Vector2i = h[1]
		var base := Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE)
		var s := Sprite2D.new()
		s.texture = tex
		s.scale = Vector2(HOUSE_SCALE, HOUSE_SCALE)
		s.offset = Vector2(0, -tex.get_height() / 2.0 + 4)
		s.position = base
		ysort.add_child(s)
		ZoneUtil.add_blocker(self, base + Vector2(0, -40), Vector2(200, 72))
	for t in PALMS:
		_add_tree("kelapa_%02d.png" % t[0], t[1], Vector2(16, 10))
	for t in FRUIT_TREES:
		_add_tree("pokok_buah_%02d.png" % t[0], t[1], Vector2(28, 14))
	for c in TUFTS:
		_standing_prop(c, "grass_tuft_small.png", Vector2.ZERO)
	for c in ROCKS:
		_standing_prop(c, "rock.png", Vector2(28, 12))
	for c in REEDS:
		var r := Sprite2D.new()
		r.texture = load(PROPS_DIR + ("water_reeds_a.png" if c.x % 2 == 0 else "water_reeds_b.png"))
		r.position = Vector2(c.x * TILE + TILE / 2.0, c.y * TILE + TILE / 2.0)
		decor.add_child(r)


## A tree standing on `cell`: sprite base at the cell's bottom, trunk blocks movement.
func _add_tree(file: String, cell: Vector2i, trunk: Vector2) -> void:
	var tex: Texture2D = load(TREE_DIR + file)
	var base := Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE - 6)
	var s := Sprite2D.new()
	s.texture = tex
	s.scale = Vector2(TREE_SCALE, TREE_SCALE)
	s.offset = Vector2(0, -tex.get_height() / 2.0 + 1)
	s.position = base
	s.set_meta("tree", true)
	ysort.add_child(s)
	ZoneUtil.add_blocker(self, base + Vector2(0, -trunk.y / 2.0), trunk)


func _standing_prop(cell: Vector2i, file: String, blocker: Vector2) -> void:
	var tex: Texture2D = load(PROPS_DIR + file)
	var base := Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 8)
	var s := Sprite2D.new()
	s.texture = tex
	s.offset = Vector2(0, -tex.get_height() / 2.0)
	s.position = base
	ysort.add_child(s)
	if blocker != Vector2.ZERO:
		ZoneUtil.add_blocker(self, base + Vector2(0, -blocker.y / 2.0), blocker)


# ---------------------------------------------------------------- farming

## Redraw padi sprites from FarmState.
func _sync_crops() -> void:
	for cell in _crop_sprites.keys():
		if not FarmState.plots.has(cell) or FarmState.plots[cell].crop == "":
			_crop_sprites[cell].queue_free()
			_crop_sprites.erase(cell)
	for cell in FarmState.plots:
		var plot: Dictionary = FarmState.plots[cell]
		var crop := FarmState.crop_data(plot.crop)
		if crop == null:
			continue
		var sprite: Sprite2D = _crop_sprites.get(cell)
		if sprite == null:
			sprite = Sprite2D.new()
			sprite.offset = Vector2(0, -16)
			sprite.position = Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 6)
			crops_root.add_child(sprite)
			_crop_sprites[cell] = sprite
		sprite.texture = crop.texture
		sprite.hframes = crop.stage_count
		sprite.frame = plot.stage


func _on_use_requested(tool: int, cell: Vector2i) -> void:
	if HOME_DOOR.has_point(cell):
		hud.show_message("You sleep until morning...")
		GameState.advance_day()
		return
	if FarmState.is_ripe(cell):
		var crop := FarmState.crop_data(FarmState.plots[cell].crop)
		FarmState.harvest(cell)
		GameState.add_item(crop.harvest_item, crop.harvest_amount)
		hud.show_message("Harvested %d %s!" % [crop.harvest_amount, crop.display_name])
		return
	if is_sawah(cell):
		match tool:
			Player.Tool.SEEDS:
				_plant(cell, "padi")
			_:
				hud.show_message("The sawah is already flooded and ready. Use seeds (2).")
		return
	if _in_map(cell) and (_corner(cell.x, cell.y) + _corner(cell.x + 1, cell.y + 1)).contains("w"):
		hud.show_message("The river runs slow and brown.")
	elif tool == Player.Tool.SEEDS:
		hud.show_message("Padi grows in the sawah, east of the houses.")


func _plant(cell: Vector2i, crop_id: String) -> void:
	if FarmState.plots.has(cell) and FarmState.plots[cell].crop != "":
		return
	var crop := FarmState.crop_data(crop_id)
	if not GameState.take_item(crop.seed_item):
		hud.show_message("No %s seeds left." % crop.display_name)
		return
	if not FarmState.plots.has(cell):
		FarmState.till(cell, true)
	FarmState.plant(cell, crop_id)


# ---------------------------------------------------------------- day cycle

func _on_day_changed(new_day: int) -> void:
	player.global_position = $Spawns/home.global_position
	player.get_node("Camera").reset_smoothing()
	hud.show_message("Day %d begins." % new_day)


func _update_lighting(minutes: int) -> void:
	night.color = DayNight.tint(minutes, KAMPUNG_TINT)
