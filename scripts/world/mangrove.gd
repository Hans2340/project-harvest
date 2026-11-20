class_name Mangrove
extends Node2D
## Mangrove / swamp zone west of the kampung (Bujang Senang's river, later).
## Uses the Dark Swamp pack (by Hypnobius) at its native 48 px tile size.
##
## PROTOTYPE NOTE: built from the ASCII LAYOUT below; water and leafy grass
## pick their edge tiles automatically (BlobAutotile). Can be replaced by a
## hand-painted map later.
##
## Legend:  . ground   , leafy grass   ~ water   | vertical boardwalk
##          = horizontal boardwalk   R rock   M stone mushroom   g grass tuft
##          r reeds (water)   k muck (water)   A altar (bottom-left of 2x3)

const TILE := 48
const SRC_GROUND := 0
const SRC_WATER := 1           ## blocks movement
const SRC_WATER_WALKABLE := 2  ## same art, no collision (under boardwalks)
const WATER_CHARS := "~|=rk"
const SWAMP_TINT := Color(0.78, 0.86, 0.82)
const PROPS_DIR := "res://assets/tilesets/dark_swamp/generated/props/"

const LAYOUT := [
	",,,,,...,,,.,,,,,,,.......,,,...",
	",,,,,..,,,,,,,,,,,,...R..,,,,,g.",
	",,,,,..g,,,,,M,,,,,......,,,,,..",
	",,,,...,,,R,.,,,~~.g.....,g,,,..",
	",,,.....,,,..~~~~~~~~.....,,,...",
	"~~........~~~~~~~~~~~~~~........",
	"~~~~|..~~~~~k~~~~~~~~~~~~~~..~~~",
	"~r~~|~~~~~~~~~~~..~~r~~~~~~~~~~~",
	"~~~~|~~~r~~~~........~~~~~~~~~~~",
	",,~~|~~~~~...,,,.......,~~~~~~~~",
	",,,,,~~.....,,,,,.....,,,,,~~,,,",
	",,,,,,.....g,,,,,.....,,,,,,R,,,",
	",,,,,,......,,,,,R....,,M,,,,,,,",
	",,R,,........,,,....g,,,,,,,,,,,",
	".,,,,.....~~~~~~~~~~~~~~~~~~~~~~",
	".,,,,,...~~~~~~~~~~~~~~~~~~~~r~~",
	".,,,,,...~~~~~k~~~~,,,,g~~~~~~~~",
	".,,,,,...=========,,,,,,,~~~~~~~",
	"..,g,.~~.~~~~~~~~~.gA,,,.~r~~~~~",
	"......~~~~~~~~~~k~..,,,..~~~~~~~",
	"......~~~~~r~~~~~~~~...~~~~~~~~~",
	"......~~~~~~~~~~~~~~~~~~~~~~~~~~",
]

@onready var ground: TileMapLayer = $Ground
@onready var decor: Node2D = $Decor
@onready var shadows: Node2D = $Shadows
@onready var ysort: Node2D = $YSort
@onready var player: Player = $YSort/Player
@onready var night: CanvasModulate = $Night
@onready var hud: Hud = $HUD

var _altar_cells: Array[Vector2i] = []
var ambience := Ambience.new()
var sun_shadows := SunShadows.new()
var _altar_sprite: Sprite2D


func _ready() -> void:
	shadows.add_child(sun_shadows)
	_build_ground()
	_build_props()
	_build_bounds()
	_build_ambience()
	player.tile_size = TILE
	Zones.place_player(self, player, $Spawns/from_kampung.global_position)
	var cam: Camera2D = player.get_node("Camera")
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = _width() * TILE
	cam.limit_bottom = LAYOUT.size() * TILE
	cam.reset_smoothing()
	player.use_requested.connect(_on_use_requested)
	player.tool_changed.connect(hud.set_tool)
	hud.set_tool(player.current_tool)
	GameState.time_changed.connect(_update_lighting)
	_update_lighting(int(GameState.minutes))
	hud.show_message("Paya Bakau - the mangrove swamp")


func _width() -> int:
	return (LAYOUT[0] as String).length()


func _char(cell: Vector2i) -> String:
	if cell.y < 0 or cell.y >= LAYOUT.size() or cell.x < 0 or cell.x >= _width():
		return ""
	return (LAYOUT[cell.y] as String)[cell.x]


## Out-of-bounds counts as "same" so terrain continues past the map edge.
func _is_water(cell: Vector2i) -> bool:
	var c := _char(cell)
	return c == "" or WATER_CHARS.contains(c)


func _is_leafy(cell: Vector2i) -> bool:
	var c := _char(cell)
	return c == "" or c == ","


# ---------------------------------------------------------------- tiles

func _build_ground() -> void:
	for y in LAYOUT.size():
		for x in _width():
			var cell := Vector2i(x, y)
			var c := _char(cell)
			if WATER_CHARS.contains(c):
				var i: int = BlobAutotile.TABLE[BlobAutotile.mask_at(cell, _is_water)]
				var src := SRC_WATER_WALKABLE if c == "|" or c == "=" else SRC_WATER
				ground.set_cell(cell, src, Vector2i((i % BlobAutotile.PER_ROW) * 4, i / BlobAutotile.PER_ROW))
			elif c == ",":
				var j: int = BlobAutotile.TABLE[BlobAutotile.mask_at(cell, _is_leafy)] + 1
				ground.set_cell(cell, SRC_GROUND, Vector2i(j % BlobAutotile.PER_ROW, j / BlobAutotile.PER_ROW))
			else:
				ground.set_cell(cell, SRC_GROUND, Vector2i(0, 0))


# ---------------------------------------------------------------- props

func _build_props() -> void:
	_build_boardwalks()
	for y in LAYOUT.size():
		for x in _width():
			var cell := Vector2i(x, y)
			match _char(cell):
				"R":
					_add_standing_prop(cell, "rock.png", Vector2(28, 12))
				"M":
					_add_standing_prop(cell, "stone_mushroom.png", Vector2(14, 8))
				"g":
					_add_standing_prop(cell, "grass_tuft_small.png", Vector2.ZERO)
				"r":
					_add_flat_prop(cell, "water_reeds_%s.png" % ("a" if (x + y) % 2 == 0 else "b"))
				"k":
					_add_flat_prop(cell, "muck_%s.png" % ["a", "b", "c"][(x * 3 + y) % 3])
				"A":
					_add_altar(cell)


## Stretches of | and = become one repeating boardwalk sprite each.
func _build_boardwalks() -> void:
	var vtex: Texture2D = load(PROPS_DIR + "bridge_strip_vertical.png")
	var htex: Texture2D = load(PROPS_DIR + "bridge_strip_horizontal.png")
	for x in _width():
		var y := 0
		while y < LAYOUT.size():
			if _char(Vector2i(x, y)) == "|":
				var y0 := y
				while _char(Vector2i(x, y)) == "|":
					y += 1
				_add_strip(vtex, Rect2(x * TILE + TILE / 2.0 - 31, y0 * TILE - 12, 62, (y - y0) * TILE + 24))
			y += 1
	for y in LAYOUT.size():
		var x := 0
		while x < _width():
			if _char(Vector2i(x, y)) == "=":
				var x0 := x
				while _char(Vector2i(x, y)) == "=":
					x += 1
				_add_strip(htex, Rect2(x0 * TILE - 12, y * TILE, (x - x0) * TILE + 24, 48))
			x += 1


func _add_strip(tex: Texture2D, rect: Rect2) -> void:
	var s := Sprite2D.new()
	s.texture = tex
	s.centered = false
	s.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	s.region_enabled = true
	s.region_rect = Rect2(Vector2.ZERO, rect.size)
	s.position = rect.position
	decor.add_child(s)


## Props that stand up (y-sorted with the player). `blocker` = collision size at the base.
func _add_standing_prop(cell: Vector2i, file: String, blocker: Vector2) -> void:
	var tex: Texture2D = load(PROPS_DIR + file)
	var base := Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE - 8)
	var s := Sprite2D.new()
	s.texture = tex
	s.offset = Vector2(0, -tex.get_height() / 2.0)
	s.position = base
	if file.contains("tuft"):
		s.set_meta("sway", true)
	ysort.add_child(s)
	shadows.add_child(ShadowUtil.make(base + Vector2(0, -1), Vector2(tex.get_width() + 6, 10)))
	if not file.contains("tuft"):
		sun_shadows.add_caster(s)
	if blocker != Vector2.ZERO:
		_add_blocker(base + Vector2(0, -blocker.y / 2.0), blocker)


## Flat details drawn under everything.
func _add_flat_prop(cell: Vector2i, file: String) -> void:
	var s := Sprite2D.new()
	s.texture = load(PROPS_DIR + file)
	if file.contains("reeds"):
		s.set_meta("sway", true)
	s.position = Vector2(cell.x * TILE + TILE / 2.0, cell.y * TILE + TILE / 2.0)
	decor.add_child(s)


func _add_blocker(center: Vector2, size: Vector2) -> void:
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.position = center
	body.add_child(shape)
	add_child(body)


## The corrupted keramat: animated altar with a red flame light.
func _add_altar(cell: Vector2i) -> void:
	var base := Vector2(cell.x * TILE + TILE, cell.y * TILE + TILE)
	_altar_sprite = Sprite2D.new()
	_altar_sprite.texture = load("res://assets/tilesets/dark_swamp/raw/AltarSpritesheet.png")
	_altar_sprite.hframes = 4
	_altar_sprite.offset = Vector2(0, -145 / 2.0)
	_altar_sprite.position = base
	_altar_sprite.set_meta("minimap", "building")
	ysort.add_child(_altar_sprite)
	shadows.add_child(ShadowUtil.make(base + Vector2(0, -10), Vector2(108, 34)))
	sun_shadows.add_caster(_altar_sprite)
	_add_blocker(base + Vector2(0, -30), Vector2(88, 56))
	var timer := Timer.new()
	timer.wait_time = 0.18
	timer.autostart = true
	timer.timeout.connect(func(): _altar_sprite.frame = (_altar_sprite.frame + 1) % 4)
	add_child(timer)
	var light := PointLight2D.new()
	var grad := GradientTexture2D.new()
	grad.fill = GradientTexture2D.FILL_RADIAL
	grad.fill_from = Vector2(0.5, 0.5)
	grad.fill_to = Vector2(1.0, 0.5)
	grad.width = 256
	grad.height = 256
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(1, 1, 1, 0))
	grad.gradient = g
	light.texture = grad
	light.color = Color(1.0, 0.18, 0.12)
	light.energy = 0.9
	light.position = base + Vector2(0, -90)
	add_child(light)
	for dx in 2:
		for dy in 3:
			_altar_cells.append(Vector2i(cell.x + dx, cell.y - dy))


## Invisible walls around the map, with a gap at the top exit.
func _build_bounds() -> void:
	var w := _width() * TILE
	var h := LAYOUT.size() * TILE
	var gap: Area2D = $ExitToKampung
	var gap_left := gap.position.x - TILE / 2.0
	var gap_right := gap.position.x + TILE / 2.0
	_add_blocker(Vector2(gap_left / 2.0, -8), Vector2(gap_left, 16))
	_add_blocker(Vector2((gap_right + w) / 2.0, -8), Vector2(w - gap_right, 16))
	_add_blocker(Vector2(w / 2.0, h + 8), Vector2(w, 16))
	_add_blocker(Vector2(-8, h / 2.0), Vector2(16, h))
	_add_blocker(Vector2(w + 8, h / 2.0), Vector2(16, h))


## Wind, water glints, clouds, birds, fireflies, dust and rain (no lamps out here).
func _build_ambience() -> void:
	var water := []
	var land := []
	for y in LAYOUT.size():
		for x in _width():
			var c := _char(Vector2i(x, y))
			if c == "~" or c == "r" or c == "k":
				water.append(Vector2i(x, y))
			elif c == "." or c == ",":
				land.append(Vector2i(x, y))
	var sway := []
	for n in ysort.get_children() + decor.get_children():
		if n.has_meta("sway"):
			sway.append(n)
	add_child(ambience)
	move_child(ambience, decor.get_index() + 1)
	ambience.setup(self, {"tile": TILE, "map_size": Vector2(_width(), LAYOUT.size()) * TILE,
		"water_cells": water, "firefly_cells": land, "sway": sway})
	sun_shadows.add_caster(player.sprite)
	sun_shadows.asar_started.connect(func(): hud.show_message(SunShadows.asar_message()))


# ---------------------------------------------------------------- interaction

func _on_use_requested(_tool: int, cell: Vector2i) -> void:
	if cell in _altar_cells:
		hud.show_message("A keramat, defiled. A black seal burns on the stone...")
	elif _is_water(cell):
		hud.show_message("Dark water. Something big moves beneath it.")
	else:
		hud.show_message("You can't farm in the swamp.")


func _update_lighting(minutes: int) -> void:
	night.color = DayNight.tint(minutes, SWAMP_TINT)
