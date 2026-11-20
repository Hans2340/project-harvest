class_name Kampung
extends Node2D
## The main kampung, east of the farm. 48 px tiles (PixelLab tilesets in the Dark Swamp style).
##
## Terrain is painted on tile CORNERS (VERTICES below, one char per corner), which is how the
## PixelLab Wang tilesets join up. Each cell looks at its 4 corners and picks the tile whose
## corners match. A cell may only mix these pairs: grass/dirt, grass/sawah, grass/sand,
## water/sand (tests check this).
##
## Corner legend:  g grass   d dirt   s sawah (padi field)   b sand (riverbank)   w river water

const TILE := 48
const SAND_WATER_WALKABLE := 4  ## same art as source 3 but no collision (under the jetty)
const JETTY_X := 15
const JETTY_ROWS := Vector2i(18, 22)  ## first and last cell row of the jetty
const KAMPUNG_TINT := Color(0.96, 0.97, 0.93)
const HOUSE_DIR := "res://assets/sprites/kampung/raw/"
const PROPS_DIR := "res://assets/tilesets/dark_swamp/generated/props/"

## terrain pair -> [atlas source, "upper" terrain char] (upper = the terrain whose corners set the mask bits)
const SETS := {
	"dg": [0, "d"], "gs": [1, "s"], "bg": [2, "b"], "bw": [3, "b"],
}
## a cell that is all one terrain -> [source, mask]
const SOLID := {"g": [0, 0], "d": [0, 15], "s": [1, 15], "b": [2, 15], "w": [3, 0]}

## [house variant, bottom-centre cell]
const HOUSES := [
	[0, Vector2i(11, 9)], [1, Vector2i(19, 9)], [3, Vector2i(19, 13)], [2, Vector2i(5, 8)],
]
const TUFTS := [Vector2i(3, 3), Vector2i(7, 15), Vector2i(23, 2), Vector2i(24, 12), Vector2i(31, 16), Vector2i(2, 16), Vector2i(12, 16)]
const ROCKS := [Vector2i(9, 17), Vector2i(26, 17), Vector2i(33, 1)]
const REEDS := [Vector2i(4, 21), Vector2i(10, 22), Vector2i(21, 20), Vector2i(29, 22), Vector2i(33, 20)]

const VERTICES := [
	"ggggggggggggggggggggggggggggggggggg",
	"ggggggggggggggggggggggggggggggggggg",
	"gggggggggggggggddgggggggggggggggggg",
	"gggggggggggggggddggggggggssssssssgg",
	"gggggggggggggggddggggggggssssssssgg",
	"gggggggggddddddddddddddggssssssssgg",
	"gggggggggddddddddddddddggssssssssgg",
	"gggggggggddddddddddddddggssssssssgg",
	"gggggggggddddddddddddddggssssssssgg",
	"gggggggggddddddddddddddggssssssssgg",
	"gggggggggddddddddddddddgggggggggggg",
	"dddddddddddddddddddddddgggssssssggg",
	"dddddddddddddddddddddddgggssssssggg",
	"dddddddddddddddddddddddgggssssssggg",
	"gggggggggddddddddddddddgggssssssggg",
	"gggggggggggggggddgggggggggssssssggg",
	"ggggggggggggggggggggggggggggggggggg",
	"gggggggggggggbbbbbgggggggggggggggbb",
	"bbbgggggbbbbbbbbbbbbbbbgggggbbbbbbb",
	"bbbbbbbbbbbbbwwwwwbbbbbbbbbbbbbbbww",
	"wwwbbbbbwwwwwwwwwwwwwwwbbbbbwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
	"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
]

@onready var ground: TileMapLayer = $Ground
@onready var decor: Node2D = $Decor
@onready var ysort: Node2D = $YSort
@onready var player: Player = $YSort/Player
@onready var night: CanvasModulate = $Night
@onready var hud: Hud = $HUD


func _ready() -> void:
	_build_ground()
	_build_jetty()
	_build_props()
	var w := _width() * TILE
	var h := _height() * TILE
	var exit: Area2D = $ExitToFarm
	ZoneUtil.build_bounds(self, w, h, Rect2(0, exit.position.y - TILE, 0, TILE * 2))
	player.tile_size = TILE
	Zones.place_player(self, player, $Spawns/from_farm.global_position)
	var cam: Camera2D = player.get_node("Camera")
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = w
	cam.limit_bottom = h
	cam.reset_smoothing()
	player.use_requested.connect(_on_use_requested)
	player.tool_changed.connect(hud.set_tool)
	hud.set_tool(player.current_tool)
	GameState.time_changed.connect(_update_lighting)
	_update_lighting(int(GameState.minutes))
	hud.show_message("Kampung")


func _width() -> int:
	return (VERTICES[0] as String).length() - 1


func _height() -> int:
	return VERTICES.size() - 1


func _corner(x: int, y: int) -> String:
	return (VERTICES[y] as String)[x]


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
	var rows := JETTY_ROWS.y - JETTY_ROWS.x + 1
	strip.region_rect = Rect2(0, 0, 62, rows * TILE)
	strip.position = Vector2(JETTY_X * TILE + TILE / 2.0 - 31, JETTY_ROWS.x * TILE + 12)
	decor.add_child(strip)


func _build_props() -> void:
	for h in HOUSES:
		var tex: Texture2D = load(HOUSE_DIR + "rumah_kampung_%02d.png" % h[0])
		var cell: Vector2i = h[1]
		var base := Vector2(cell.x * TILE + TILE / 2.0, (cell.y + 1) * TILE)
		var s := Sprite2D.new()
		s.texture = tex
		s.offset = Vector2(0, -tex.get_height() / 2.0 + 6)
		s.position = base
		ysort.add_child(s)
		ZoneUtil.add_blocker(self, base + Vector2(0, -22), Vector2(100, 34))
	for c in TUFTS:
		_standing_prop(c, "grass_tuft_small.png", Vector2.ZERO)
	for c in ROCKS:
		_standing_prop(c, "rock.png", Vector2(28, 12))
	for c in REEDS:
		var r := Sprite2D.new()
		r.texture = load(PROPS_DIR + ("water_reeds_a.png" if c.x % 2 == 0 else "water_reeds_b.png"))
		r.position = Vector2(c.x * TILE + TILE / 2.0, c.y * TILE + TILE / 2.0)
		decor.add_child(r)


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


func _on_use_requested(_tool: int, cell: Vector2i) -> void:
	if cell.y >= 0 and cell.y < _height() and cell.x >= 0 and cell.x < _width():
		var c := _corner(cell.x, cell.y) + _corner(cell.x + 1, cell.y + 1)
		if c.contains("s"):
			hud.show_message("Sawah. Farming here comes later.")
			return
		if c.contains("w"):
			hud.show_message("The river runs slow and brown.")
			return
	hud.show_message("The kampung is quiet.")


func _update_lighting(minutes: int) -> void:
	night.color = DayNight.tint(minutes, KAMPUNG_TINT)
