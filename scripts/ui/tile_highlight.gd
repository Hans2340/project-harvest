class_name TileHighlight
extends Node2D
## Outline of the tile the player is facing. Drawn in code, so it fits any tile size.

@export var size := 48.0
@export var color := Color(1.0, 0.94, 0.78, 0.8)


func _draw() -> void:
	var r := Rect2(-size / 2.0, -size / 2.0, size, size)
	draw_rect(r, color, false, 1.0)
	draw_rect(r.grow(-1), Color(color, color.a * 0.35), false, 1.0)
