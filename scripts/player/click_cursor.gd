class_name ClickCursor
extends Node2D
## What the mouse is pointing at, drawn in the world: a box on a tile the current tool can be
## used on, corner brackets round something you can hit, and a ring where you clicked to walk.
## Hidden while you play with the keyboard; it comes back when the mouse moves.

const TOOL_COLOR := Color(1.0, 0.86, 0.45, 0.9)
const HIT_COLOR := Color(1.0, 0.45, 0.35, 0.9)
const MARK_TIME := 0.45

var player: Node2D
var mouse_active := false
var _hover_cell := Vector2i(-999, -999)
var _hover_target: Node2D = null
var _mark := Vector2.ZERO
var _mark_t := 0.0


func _ready() -> void:
	top_level = true   # world coordinates, not the player's
	z_index = 20


func mark(p: Vector2) -> void:
	_mark = p
	_mark_t = MARK_TIME


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		mouse_active = true
	elif event is InputEventKey and event.pressed:
		mouse_active = false


func _process(delta: float) -> void:
	_mark_t = maxf(_mark_t - delta, 0.0)
	_hover_target = null
	_hover_cell = Vector2i(-999, -999)
	if mouse_active and player and player.can_move:
		var p := get_global_mouse_position()
		_hover_target = player.hittable_at(p)
		if _hover_target == null:
			var c := Vector2i(floori(p.x / player.tile_size), floori(p.y / player.tile_size))
			if player.is_use_target(c):
				_hover_cell = c
	queue_redraw()


func _draw() -> void:
	if _hover_cell.x > -999:
		var ts: float = player.tile_size
		var r := Rect2(Vector2(_hover_cell) * ts, Vector2(ts, ts)).grow(-1)
		draw_rect(r, TOOL_COLOR, false, 1.0)
		draw_rect(r.grow(-2), Color(TOOL_COLOR, 0.25), false, 1.0)
	if _hover_target:
		var c: Vector2 = _hover_target.hit_center()
		var h: float = _hover_target.hit_radius() + 8.0
		var arm := 4.0
		for sx in [-1.0, 1.0]:
			for sy in [-1.0, 1.0]:
				var corner := c + Vector2(sx * h, sy * h * 1.6)
				draw_line(corner, corner - Vector2(sx * arm, 0), HIT_COLOR, 1.0)
				draw_line(corner, corner - Vector2(0, sy * arm), HIT_COLOR, 1.0)
	if _mark_t > 0.0:
		var k := _mark_t / MARK_TIME
		draw_arc(_mark, 3.0 + (1.0 - k) * 6.0, 0, TAU, 16, Color(1, 1, 1, 0.8 * k), 1.0)
