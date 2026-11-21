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
## Feet of each house's corner stilts in its 144 px picture: front, left, right (the back one is
## hidden; it completes the parallelogram). Used for the sun shadow's floor plan.
const HOUSE_FEET := [
	[Vector2(67, 135), Vector2(30, 119), Vector2(117, 110)],
	[Vector2(47, 135), Vector2(12, 120), Vector2(112, 100)],
	[Vector2(64, 138), Vector2(26, 118), Vector2(119, 112)],
	[Vector2(74, 138), Vector2(14, 108), Vector2(133, 113)],
]
## Height of the houses to the eaves, and how far the roof sticks out (world px).
const HOUSE_EAVES := 120.0
const HOUSE_OVERHANG := 12.0
## Cells you can face to sleep (front of the home house).
const HOME_DOOR := Rect2i(9, 8, 5, 3)
## Who lives in each house (same order as HOUSES) and what you hear at the door (E).
## Story rules: docs/lore.md (the kampung is still at peace in the prologue; no jampi, incense or
## superstition shown as true). Mak Som and Pak Hamid are minor neighbours, not in the lore yet.
const HOUSE_PEOPLE := [
	{"name": "Rumah kamu", "lines": []},
	{"name": "Rumah Mak Som", "lines": [
		"Mak Som calls from inside: \"Padi growing well, nak? Tell Awang I said thank you.\"",
		"Someone is pounding chillies inside. It smells of sambal.",
		"Mak Som: \"Mind the wild boar after Maghrib. They dig up the batas at night.\""]},
	{"name": "Rumah Pak Hamid", "lines": [
		"The door is shut. You hear a parang being sharpened.",
		"Pak Hamid: \"Salt costs more this month. The traders say the Kuala is closed.\"",
		"A fishing net hangs drying by the stairs."]},
	{"name": "Rumah Tok Senik", "lines": [
		"Bundles of roots and leaves hang drying under the eaves. It smells of bitter herbs.",
		"Tok Senik, without looking up: \"Come back later, child. This ramuan won't brew itself.\"",
		"Someone is grinding something in a stone mortar inside."]},
]
const SENIK_HOUSE := 3   ## index in HOUSES: Tok Senik, the old healer (docs/lore.md)
## North path out of the kampung, toward Hutan Pinggir (not built yet).
const FOREST_PATH_X := 18

## Kampung details (PixelLab, drawn at 1x: the same pixel size as the Pendekar).
const KPROPS_DIR := "res://assets/sprites/kampung/props/"
## Fence lines along the sawah bunds: [row, first cell, last cell] (two segments per cell).
const FENCE_LINES := [[3, 34, 44], [11, 34, 44], [13, 34, 44], [21, 34, 44]]
## [file prefix, variant count, cells]
const KAMPUNG_PROPS := [
	["kayu_api", 8, [Vector2i(8, 9), Vector2i(21, 9), Vector2i(8, 18), Vector2i(27, 18), Vector2i(16, 3)]],
	["tempayan", 8, [Vector2i(14, 10), Vector2i(27, 10), Vector2i(14, 19), Vector2i(28, 19), Vector2i(16, 9)]],
	["batu", 7, [Vector2i(12, 25), Vector2i(23, 25), Vector2i(36, 25), Vector2i(5, 25), Vector2i(31, 3)]],
]
## Ground cover (PixelLab, 1x): name -> variant count. Flat pieces lie under the shadows;
## standing ones (grass, flowers) are y-sorted and sway. Puddles only show in the rain.
const GROUND_DIR := "res://assets/sprites/kampung/ground/"
const GROUND_SETS := {"serpihan": 10, "rumput": 12, "rumput_kering": 4, "bunga": 12, "kerikil": 10,
	"lopak": 8, "lumpur": 6, "daun": 10, "lumut": 10, "tanah": 10, "batu_tepi_h": 12, "batu_tepi_v": 10,
	"renek": 14, "pelepah": 10, "kelapa_jatuh": 10}
const STANDING_SETS := ["rumput", "rumput_kering", "bunga", "renek", "kelapa_jatuh"]
## Stone edging along the paths (world px): [from, to, vertical?]. Gaps are left so it looks worn.
const PATH_EDGES := [
	[Vector2(852, 4), Vector2(852, 186), true], [Vector2(924, 4), Vector2(924, 186), true],       # north path
	[Vector2(8, 516), Vector2(282, 516), false], [Vector2(8, 636), Vector2(282, 636), false],    # west path
	[Vector2(1452, 516), Vector2(1590, 516), false], [Vector2(1452, 636), Vector2(1590, 636), false],  # to the sawah
	[Vector2(806, 980), Vector2(806, 1100), true], [Vector2(922, 980), Vector2(922, 1100), true],  # to the jetty
]
var birds := GroundBirds.new()
const GROUND_ALPHA := {"tanah": 0.5, "lumpur": 0.8}
## Cells kept clear of scattered cover: paths people walk on (x, y, w, h in cells).
const PATH_RECTS := [Rect2i(17, 0, 4, 4), Rect2i(0, 10, 7, 4), Rect2i(30, 10, 4, 4),
	Rect2i(34, 12, 11, 2), Rect2i(16, 19, 5, 6), Rect2i(17, 24, 3, 7)]

## Tall reeds at the jetty and along the bank (sway in the wind).
const BANK_REEDS := [Vector2i(16, 26), Vector2i(20, 26), Vector2i(17, 27), Vector2i(19, 27),
	Vector2i(14, 26), Vector2i(22, 26), Vector2i(6, 26), Vector2i(41, 26)]

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
## Patung latihan for the silat combo, in the yard beside the home house.
const DUMMY_CELL := Vector2i(15, 11)
const REEDS := [Vector2i(4, 29), Vector2i(11, 30), Vector2i(25, 29), Vector2i(33, 30), Vector2i(42, 29)]

const VERTICES := [
	"ggggggggggggggggggddggggggggggggggggggggggggggg",
	"ggggggggggggggggggddggggggggggggggggggggggggggg",
	"ggggggggggggggggggddggggggggggggggggggggggggggg",
	"ggggggdddddddddddddddddddddddddgggggggggggggggg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"ggggggdddddddddddddddddddddddddgggsssssssssssgg",
	"dddddddddddddddddddddddddddddddddgsssssssssssgg",
	"dddddddddddddddddddddddddddddddddgggggggggggggg",
	"dddddddddddddddddddddddddddddddddgggggggggggggg",
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
var _door_visits := {}    ## house index -> times you've knocked
var _ground_rng := RandomNumberGenerator.new()
var _ground_cover := Node2D.new()   ## flat ground pieces, drawn under the shadows
var _puddles: Array[Sprite2D] = []
var ambience := Ambience.new()
var sun_shadows := SunShadows.new()
var dummy := TrainingDummy.new()

@onready var ground: TileMapLayer = $Ground
@onready var decor: Node2D = $Decor
@onready var shadows: Node2D = $Shadows
@onready var ysort: Node2D = $YSort
@onready var crops_root: Node2D = $YSort/Crops
@onready var player: Player = $YSort/Player
@onready var night: CanvasModulate = $Night
@onready var hud: Hud = $HUD


func _ready() -> void:
	shadows.add_child(sun_shadows)
	_ground_rng.seed = 2026
	add_child(_ground_cover)
	move_child(_ground_cover, ground.get_index() + 1)
	_build_ground()
	_build_jetty()
	_build_props()
	_build_details()
	_build_ground_cover()
	_build_birds()
	_sync_crops()
	_build_ambience()
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


## Click-to-move asks this: should a left click on `cell` walk over and use `tool` on it?
## Ripe padi (harvest) with any tool, or an empty sawah plot with the seeds.
func is_click_use_target(tool: int, cell: Vector2i) -> bool:
	if FarmState.is_ripe(cell):
		return true
	return tool == Player.Tool.SEEDS and is_sawah(cell) and not FarmState.plots.has(cell)


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
		s.set_meta("minimap", "building")
		ysort.add_child(s)
		sun_shadows.add_box(_house_footprint(s, HOUSE_FEET[h[0]]), HOUSE_EAVES, HOUSE_OVERHANG)
		ZoneUtil.add_blocker(self, base + Vector2(0, -40), Vector2(200, 72))
	for t in PALMS:
		_add_tree("kelapa_%02d.png" % t[0], t[1], Vector2(16, 10), Vector2.ZERO).set_meta("tree_kind", "palm")
	for t in FRUIT_TREES:
		_add_tree("pokok_buah_%02d.png" % t[0], t[1], Vector2(28, 14), Vector2(124, 60), true).set_meta("tree_kind", "fruit")
	for c in TUFTS:
		_standing_prop(c, "grass_tuft_small.png", Vector2.ZERO)
	for c in ROCKS:
		_standing_prop(c, "rock.png", Vector2(28, 12))
	dummy.position = Vector2(DUMMY_CELL.x * TILE + TILE / 2.0, DUMMY_CELL.y * TILE + TILE - 8)
	ysort.add_child(dummy)
	sun_shadows.add_caster(dummy.sprite)
	ZoneUtil.add_blocker(self, dummy.position + Vector2(0, -5), Vector2(22, 10))
	for c in REEDS:
		var r := Sprite2D.new()
		r.texture = load(PROPS_DIR + ("water_reeds_a.png" if c.x % 2 == 0 else "water_reeds_b.png"))
		r.position = Vector2(c.x * TILE + TILE / 2.0, c.y * TILE + TILE / 2.0)
		r.set_meta("sway", true)
		decor.add_child(r)


## The ground plan of a house sprite, from its corner stilts' feet (picture px) to world px.
func _house_footprint(s: Sprite2D, feet: Array) -> PackedVector2Array:
	var top_left := s.get_rect().position
	var front: Vector2 = feet[0]
	var left: Vector2 = feet[1]
	var right: Vector2 = feet[2]
	var pts := PackedVector2Array()
	for p in [front, right, left + right - front, left]:
		pts.append(s.position + (top_left + p) * s.scale)
	return pts


## A tree standing on `cell`: sprite base at the cell's bottom, trunk blocks movement.
func _add_tree(file: String, cell: Vector2i, trunk: Vector2, shadow: Vector2, oval_only := false) -> Sprite2D:
	var tex: Texture2D = load(TREE_DIR + file)
	var base := Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE - 6)
	var s := Sprite2D.new()
	s.texture = tex
	s.scale = Vector2(TREE_SCALE, TREE_SCALE)
	s.offset = Vector2(0, -tex.get_height() / 2.0 + 1)
	s.position = base
	s.set_meta("tree", true)
	s.set_meta("minimap", "tree")
	s.set_meta("sway", true)
	ysort.add_child(s)
	sun_shadows.add_caster(s, shadow, oval_only)
	ZoneUtil.add_blocker(self, base + Vector2(0, -trunk.y / 2.0), trunk)
	return s


func _standing_prop(cell: Vector2i, file: String, blocker: Vector2) -> void:
	var tex: Texture2D = load(PROPS_DIR + file)
	var base := Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 8)
	var s := Sprite2D.new()
	s.texture = tex
	s.offset = Vector2(0, -tex.get_height() / 2.0)
	s.position = base
	if file.contains("tuft"):
		s.set_meta("sway", true)
	ysort.add_child(s)
	if not file.contains("tuft"):
		sun_shadows.add_caster(s)
	if blocker != Vector2.ZERO:
		ZoneUtil.add_blocker(self, base + Vector2(0, -blocker.y / 2.0), blocker)


## Wind, water glints, clouds, birds, leaves, pelita lamps, fireflies, dust and rain.
func _build_ambience() -> void:
	var water := []
	var flies := []
	for y in _height():
		for x in _width():
			var c := _corner(x, y) + _corner(x + 1, y) + _corner(x, y + 1) + _corner(x + 1, y + 1)
			if c.contains("w"):
				water.append(Vector2i(x, y))
			elif c.contains("s") or (c == "gggg" and y > 20):
				flies.append(Vector2i(x, y))
	var sway := []
	var fruit := []
	for n in ysort.get_children() + decor.get_children():
		if n.has_meta("sway"):
			sway.append(n)
		if n.get_meta("tree_kind", "") == "fruit":
			fruit.append(n)
	var lamps := []
	var lamp_ground := []
	for h in HOUSES:
		var cell: Vector2i = h[1]
		lamps.append(Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE - 100))
		lamp_ground.append(Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE + 8))
	for n in ysort.get_children():
		if n.has_meta("lamp_point"):
			lamps.append(n.get_meta("lamp_point"))
			lamp_ground.append(n.position + Vector2(0, 6))
	sun_shadows.set_lamps(lamp_ground)
	sun_shadows.add_caster(player.sprite)
	sun_shadows.asar_started.connect(func(): hud.show_message(SunShadows.asar_message()))
	add_child(ambience)
	move_child(ambience, decor.get_index() + 1)
	ambience.setup(self, {"tile": TILE, "map_size": Vector2(_width(), _height()) * TILE,
		"water_cells": water, "firefly_cells": flies, "sway": sway, "leaf_trees": fruit, "lamps": lamps})


# ---------------------------------------------------------------- kampung details

## Fences, firewood, water jars, stones, bank reeds, Tok Senik's sign and lamp, north path.
func _build_details() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for line in FENCE_LINES:
		var y: int = line[0]
		for x in range(line[1], line[2] + 1):
			for half in 2:
				var pos := Vector2(x * TILE + 12 + half * 24, (y + 1) * TILE - 12)
				_detail("pagar_%d.png" % rng.randi_range(0, 6), pos, Vector2(24, 6), false)
				_dress(pos, "fence")
	for group in KAMPUNG_PROPS:
		for i in (group[2] as Array).size():
			var c: Vector2i = group[2][i]
			var ppos := Vector2(c.x * TILE + TILE / 2.0, (c.y + 1) * TILE - 8)
			_detail("%s_%d.png" % [group[0], (i * 3 + c.x) % group[1]], ppos, Vector2(20, 8), false)
			_dress(ppos, group[0])
	for i in BANK_REEDS.size():
		var c: Vector2i = BANK_REEDS[i]
		_detail("rumput_air_%d.png" % (i % 8), Vector2(c.x * TILE + TILE / 2.0, (c.y + 1) * TILE - 6), Vector2.ZERO, true)
	_build_senik_details()
	_build_forest_path()


## Tok Senik's house (the healer): a small, easy-to-miss sign by the grass, and a pelita on a post.
func _build_senik_details() -> void:
	var cell: Vector2i = HOUSES[SENIK_HOUSE][1]
	var base := Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE)
	_detail("rumput_air_1.png", base + Vector2(-100, 2), Vector2.ZERO, true)   # grass just behind it
	_detail("papan_tanda.png", base + Vector2(-124, 8), Vector2.ZERO, false)
	var lamp := _detail("pelita.png", base + Vector2(96, 10), Vector2(8, 6), false)
	_dress(lamp.position, "post")
	lamp.set_meta("lamp_point", lamp.position + Vector2(-12 + 17, -46 + 29))  # flame pixel (17, 29)


## North exit path toward Hutan Pinggir (not built yet; Awang takes you hunting there in the prologue).
func _build_forest_path() -> void:
	var area := Area2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(TILE * 2, 24)
	shape.shape = rect
	area.add_child(shape)
	area.position = Vector2((FOREST_PATH_X + 1) * TILE, 14)
	area.body_entered.connect(func(body):
		if body is Player:
			hud.show_message("The path leads north to Hutan Pinggir. Awang said not to go in alone yet."))
	add_child(area)


## A small kampung prop at 1x, bottom-centre at `pos`. `blocker` = collision at its foot.
func _detail(file: String, pos: Vector2, blocker: Vector2, sway: bool) -> Sprite2D:
	var tex: Texture2D = load(KPROPS_DIR + file)
	var s := Sprite2D.new()
	s.texture = tex
	s.offset = Vector2(0, -tex.get_height() / 2.0)
	s.position = pos.round()
	if sway:
		s.set_meta("sway", true)
	ysort.add_child(s)
	if not sway:
		sun_shadows.add_caster(s)   # cast shadow only (leoxent: foot ovals are for fruit trees only)
	if blocker != Vector2.ZERO:
		ZoneUtil.add_blocker(self, pos + Vector2(0, -blocker.y / 2.0), blocker)
	return s


## Index of the house whose door area contains `cell`, or -1.
func house_at_door(cell: Vector2i) -> int:
	for i in HOUSES.size():
		var c: Vector2i = HOUSES[i][1]
		if Rect2i(c.x - 2, c.y - 1, 5, 3).has_point(cell):
			return i
	return -1


# ---------------------------------------------------------------- ground cover

## Base dressing for everything standing, then terrain-based scatter, then puddles for rain.
func _build_ground_cover() -> void:
	for n in ysort.get_children():
		if n.has_meta("tree"):
			_dress(n.position, "fruit_tree" if n.get_meta("tree_kind", "") == "fruit" else "palm")
		elif n.has_meta("minimap") and n.get_meta("minimap") == "building":
			_dress(n.position, "house")
	_dress(dummy.position, "trampled")
	for c in ROCKS:
		_dress(Vector2(c.x * TILE + TILE / 2.0, c.y * TILE + TILE - 8), "batu")
	_scatter()
	_build_path_edges()
	GameState.weather_changed.connect(func(_w): _show_puddles())
	_show_puddles()


## Small things around an object's foot so it sits in the ground, not on it.
func _dress(pos: Vector2, kind: String) -> void:
	var r := _ground_rng
	match kind:
		"kayu_api":
			_ground("tanah", pos + Vector2(0, -3))
			for i in r.randi_range(2, 3):
				_ground("serpihan", pos + Vector2(r.randf_range(-24, 24), r.randf_range(-2, 9)))
			_ground("rumput", pos + Vector2(r.randf_range(14, 20) * (1 if r.randf() < 0.5 else -1), 2))
		"tempayan":
			_ground("lumut", pos + Vector2(0, 1))
			if r.randf() < 0.6:
				_ground("rumput", pos + Vector2(r.randf_range(10, 15) * (1 if r.randf() < 0.5 else -1), 3))
		"batu":
			for i in 2:
				_ground("kerikil", pos + Vector2(r.randf_range(-26, 26), r.randf_range(0, 10)))
			_ground("rumput", pos + Vector2(r.randf_range(-16, 16), 3))
		"fence":
			if r.randf() < 0.4:
				_ground("rumput", pos + Vector2(r.randf_range(-10, 10), 3))
			elif r.randf() < 0.2:
				_ground("bunga", pos + Vector2(r.randf_range(-10, 10), 4))
		"post":
			_ground("lumut", pos + Vector2(0, 1))
			_ground("rumput", pos + Vector2(-9, 3))
		"fruit_tree":
			for i in r.randi_range(3, 5):
				_ground("daun", pos + Vector2(r.randf_range(-56, 56), r.randf_range(-14, 22)))
			for i in 2:
				_ground("rumput", pos + Vector2(r.randf_range(-22, 22), r.randf_range(2, 8)))
		"palm":
			_ground("rumput", pos + Vector2(r.randf_range(-14, 14), 4))
			if r.randf() < 0.7:
				_ground("pelepah", pos + Vector2(r.randf_range(-40, 40), r.randf_range(4, 18)))
			if r.randf() < 0.55:
				_ground("kelapa_jatuh", pos + Vector2(r.randf_range(-24, 24), r.randf_range(6, 14)))
		"house":
			for i in 4:   # weeds along the front stilts
				_ground("rumput", pos + Vector2(r.randf_range(-96, 96), r.randf_range(-6, 4)))
			for i in 2:
				_ground("kerikil", pos + Vector2(r.randf_range(-90, 90), r.randf_range(4, 14)))
		"trampled":
			_ground("tanah", pos + Vector2(0, -2))
			_ground("tanah", pos + Vector2(r.randf_range(-12, 12), 6))


## One ground piece from `group` at `pos` (a random variant). Paths stay clear (except edging).
func _ground(group: String, pos: Vector2) -> Sprite2D:
	if not group.begins_with("batu_tepi") and _on_path(Vector2i(pos / float(TILE))):
		return null
	var tex: Texture2D = load(GROUND_DIR + "%s_%d.png" % [group, _ground_rng.randi_range(0, GROUND_SETS[group] - 1)])
	var s := Sprite2D.new()
	s.texture = tex
	s.position = pos.round()
	s.flip_h = _ground_rng.randf() < 0.5
	s.modulate.a = GROUND_ALPHA.get(group, 1.0)
	s.set_meta("ground", group)
	if group in STANDING_SETS:
		s.offset = Vector2(0, -tex.get_height() / 2.0)
		s.set_meta("sway", true)
		ysort.add_child(s)
	else:
		_ground_cover.add_child(s)
	if group == "lopak":
		_puddles.append(s)
	return s


func _on_path(cell: Vector2i) -> bool:
	for r in PATH_RECTS:
		if r.has_point(cell):
			return true
	return false


## Cells next to houses and props are left to the base dressing.
func _crowded(cell: Vector2i) -> bool:
	for h in HOUSES:
		var c: Vector2i = h[1]
		if Rect2i(c.x - 3, c.y - 4, 7, 5).has_point(cell):
			return true
	for group in KAMPUNG_PROPS:
		if cell in group[2]:
			return true
	return cell == DUMMY_CELL


## Fixed-seed scatter by terrain: grass gets weeds and flowers, edges grow thicker, the dirt yard
## gets pebbles, chips, mud and the odd tuft, sand gets pebbles. Paths, sawah and water stay clear.
func _scatter() -> void:
	var r := _ground_rng
	for y in _height():
		for x in _width():
			var cell := Vector2i(x, y)
			if _on_path(cell) or _crowded(cell):
				continue
			var c := _corner(x, y) + _corner(x + 1, y) + _corner(x, y + 1) + _corner(x + 1, y + 1)
			if c.contains("w") or c == "ssss":
				continue
			var at := func(): return Vector2(x * TILE + r.randf_range(6, TILE - 6), y * TILE + r.randf_range(10, TILE - 4))
			if c == "gggg":
				if r.randf() < 0.06:
					_bush(at.call())
				if r.randf() < 0.32:
					var p: Vector2 = at.call()
					_ground("rumput", p)
					if r.randf() < 0.45:   # clumps, not single tufts
						_ground("rumput" if r.randf() < 0.8 else "rumput_kering", p + Vector2(r.randf_range(-14, 14), r.randf_range(-6, 6)))
				if r.randf() < 0.13:
					_ground("bunga", at.call())
				if r.randf() < 0.05:
					_ground("kerikil", at.call())
			elif c.contains("g"):   # edges of yard, sawah and bank: thicker growth
				if r.randf() < 0.42:
					_ground("rumput", at.call())
				if r.randf() < 0.08:
					_ground("bunga", at.call())
			elif c == "dddd":
				var roll := r.randf()
				if roll < 0.13:
					_ground("kerikil", at.call())
				elif roll < 0.18:
					_ground("serpihan", at.call())
				elif roll < 0.25:
					_ground("lumpur", at.call())
				elif roll < 0.33:
					_ground("tanah", at.call())
				elif roll < 0.39:
					_ground("rumput", at.call())
				if r.randf() < 0.11:
					_ground("lopak", at.call())
			elif c == "bbbb" and r.randf() < 0.1:
				_ground("kerikil", at.call())


## A bush (renek): y-sorted, sways, has a foot shadow and blocks a little at its foot.
func _bush(pos: Vector2) -> void:
	var b := _ground("renek", pos)
	if b == null:
		return
	b.set_meta("sway", true)
	sun_shadows.add_caster(b)
	ZoneUtil.add_blocker(self, pos + Vector2(0, -4), Vector2(b.texture.get_width() * 0.6, 8))


## Half-sunk stones along the edges of the main paths, with a few gaps.
func _build_path_edges() -> void:
	var r := _ground_rng
	for e in PATH_EDGES:
		var from: Vector2 = e[0]
		var to: Vector2 = e[1]
		var vertical: bool = e[2]
		var step := 22.0 if vertical else 32.0
		var n := int(from.distance_to(to) / step)
		for i in n + 1:
			if r.randf() < 0.25:   # worn gaps
				continue
			var p := from.lerp(to, float(i) / maxf(n, 1)) + Vector2(r.randf_range(-2, 2), r.randf_range(-2, 2))
			_ground("batu_tepi_v" if vertical else "batu_tepi_h", p)


## Burung tiung on grass and the yard by day (they fly off when you come close).
func _build_birds() -> void:
	var spots := []
	for y in range(2, 24):
		for x in range(1, 45):
			var c := _corner(x, y) + _corner(x + 1, y + 1)
			if not _on_path(Vector2i(x, y)) and not _crowded(Vector2i(x, y)) and (c == "gg" or c == "dd"):
				spots.append(Vector2(x * TILE + TILE / 2.0, y * TILE + TILE / 2.0))
	ysort.add_child(birds)
	birds.setup(player, spots, 7)


## Puddles are there only when it rains.
func _show_puddles() -> void:
	for pud in _puddles:
		pud.visible = GameState.is_raining()


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
			sprite.material = Ambience.get_sway_material()
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
	var house := house_at_door(cell)
	if house > 0:
		var lines: Array = HOUSE_PEOPLE[house].lines
		var n: int = _door_visits.get(house, 0)
		_door_visits[house] = n + 1
		hud.show_message(lines[n % lines.size()])
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
