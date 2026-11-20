class_name ZoneUtil
extends RefCounted
## Small helpers shared by zone scripts.


static func add_blocker(parent: Node, center: Vector2, size: Vector2) -> StaticBody2D:
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.position = center
	body.add_child(shape)
	parent.add_child(body)
	return body


## Invisible walls round a w x h map. `gaps` = Rect2s on the edges to leave open (exits).
static func build_bounds(parent: Node, w: float, h: float, left_gap := Rect2(), right_gap := Rect2()) -> void:
	add_blocker(parent, Vector2(w / 2.0, -8), Vector2(w, 16))
	add_blocker(parent, Vector2(w / 2.0, h + 8), Vector2(w, 16))
	_side(parent, -8, h, left_gap)
	_side(parent, w + 8, h, right_gap)


static func _side(parent: Node, x: float, h: float, gap: Rect2) -> void:
	if gap.size == Vector2.ZERO:
		add_blocker(parent, Vector2(x, h / 2.0), Vector2(16, h))
		return
	var top := gap.position.y
	var bottom := gap.end.y
	add_blocker(parent, Vector2(x, top / 2.0), Vector2(16, top))
	add_blocker(parent, Vector2(x, (bottom + h) / 2.0), Vector2(16, h - bottom))
