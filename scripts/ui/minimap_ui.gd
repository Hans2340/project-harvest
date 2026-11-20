class_name MinimapUI
extends Control
## Small map in the top-left corner (toggle with M). Built from the current zone's Ground tiles:
## each tile becomes one pixel coloured by the tile's average colour, then houses and trees
## (sprites tagged with meta "minimap") are marked, and a dot follows the player.

const BOX := Vector2(104, 72)     ## outer frame size
const INNER := Vector2(92, 64)    ## max map area inside the frame
const COLORS := {"building": Color(0.42, 0.3, 0.2), "tree": Color(0.12, 0.24, 0.12)}

var _zone: Node2D
var _ground: TileMapLayer
var _player: Node2D
var _scale := 1
var _map_rect := TextureRect.new()
var _dot := Dot.new()
static var _tile_colors := {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	offset_left = 4
	offset_right = 4 + BOX.x
	offset_top = 4
	offset_bottom = 4 + BOX.y
	var frame := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	frame.size = BOX
	add_child(frame)
	_map_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(_map_rect)
	_dot.minimap = self
	add_child(_dot)
	build.call_deferred()   # after the zone has painted its tiles


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("minimap"):
		visible = not visible


func build() -> void:
	_zone = get_parent().get_parent() as Node2D   # HUD -> zone
	if _zone == null or not _zone.has_node("Ground"):
		visible = false
		return
	_ground = _zone.get_node("Ground")
	_player = _zone.get_node_or_null("YSort/Player")
	var used := _ground.get_used_rect()
	var w := used.end.x
	var h := used.end.y
	_scale = maxi(1, mini(int(INNER.x / w), int(INNER.y / h)))
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	for cell in _ground.get_used_cells():
		img.set_pixelv(cell, tile_color(_ground, cell))
	var tile := float(_ground.tile_set.tile_size.x)
	for s in _zone.get_node("YSort").get_children():
		if s is Node2D and s.has_meta("minimap"):
			var col: Color = COLORS.get(s.get_meta("minimap"), Color.BLACK)
			var c := Vector2i((s as Node2D).position / tile)
			var r := 2 if s.get_meta("minimap") == "building" else 0
			for dy in range(-r, 1):
				for dx in range(-r, r + 1):
					var p := c + Vector2i(dx, dy - (1 if r > 0 else 0))
					if p.x >= 0 and p.y >= 0 and p.x < w and p.y < h:
						img.set_pixelv(p, col)
	img.resize(w * _scale, h * _scale, Image.INTERPOLATE_NEAREST)
	_map_rect.texture = ImageTexture.create_from_image(img)
	_map_rect.size = Vector2(img.get_width(), img.get_height())
	_map_rect.position = (BOX - _map_rect.size) / 2.0
	_dot.position = _map_rect.position
	_dot.size = _map_rect.size


## Average colour of a tile's art (cached per source + atlas coords).
static func tile_color(ground: TileMapLayer, cell: Vector2i) -> Color:
	var src_id := ground.get_cell_source_id(cell)
	var coords := ground.get_cell_atlas_coords(cell)
	var key := "%d:%s" % [src_id, coords]
	if _tile_colors.has(key):
		return _tile_colors[key]
	var src := ground.tile_set.get_source(src_id) as TileSetAtlasSource
	var region := src.get_tile_texture_region(coords)
	var img := src.texture.get_image().get_region(region)
	img.resize(1, 1, Image.INTERPOLATE_BILINEAR)
	var col := img.get_pixel(0, 0)
	col.a = 1.0
	_tile_colors[key] = col
	return col


## Player position in minimap pixels (relative to the map image).
func player_point() -> Vector2:
	if _player == null or _ground == null:
		return Vector2(-100, -100)
	return _player.global_position / float(_ground.tile_set.tile_size.x) * _scale


class Dot:
	extends Control
	var minimap: MinimapUI
	var _t := 0.0

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

	func _draw() -> void:
		var p := minimap.player_point()
		var on := fmod(_t, 1.0) < 0.75
		draw_rect(Rect2(p - Vector2(2, 2), Vector2(4, 4)), Color(0.08, 0.07, 0.06))
		draw_rect(Rect2(p - Vector2(1, 1), Vector2(2, 2)), Color(1.0, 0.92, 0.55) if on else Color(0.95, 0.6, 0.3))
