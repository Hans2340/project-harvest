class_name TrainingDummy
extends Node2D
## Patung latihan: a straw dummy on a post to try the silat combo on. It rocks away from the
## blow, flashes and shows the damage. It never breaks. The node's position is its feet.

const TEX := preload("res://assets/sprites/props/patung_latihan.png")
const CENTRE := Vector2(0, -24)   ## middle of the straw body, from the feet
const RADIUS := 10.0

var hits := 0
var total_damage := 0
var sprite := Sprite2D.new()
var _tween: Tween


func _init() -> void:
	add_to_group("hittable")
	sprite.texture = TEX
	sprite.offset = Vector2(0, -TEX.get_height() / 2.0 + 1)   # feet on the node, so it rocks on its base
	add_child(sprite)


func hit_center() -> Vector2:
	return global_position + CENTRE


func hit_radius() -> float:
	return RADIUS


func take_hit(damage: int, from_dir: Vector2, heavy: bool) -> void:
	hits += 1
	total_damage += damage
	if _tween:
		_tween.kill()
	_tween = create_tween()
	# Rock away from the blow; a blow from above or below squashes instead.
	var lean := (0.32 if heavy else 0.18) * signf(from_dir.x)
	var squash := Vector2(1.12, 0.88) if from_dir.x == 0.0 else Vector2.ONE
	sprite.rotation = lean
	sprite.scale = squash
	sprite.modulate = Color(1.0, 0.55, 0.5)
	_tween.set_parallel()
	_tween.tween_property(sprite, "rotation", 0.0, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)
	_pop_number(damage, heavy)


func _pop_number(damage: int, heavy: bool) -> void:
	var l := UiSkin.label(str(damage), 10 if heavy else 8, Color(1, 0.85, 0.4) if heavy else Color(1, 0.95, 0.85))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.size = Vector2(24, 12)
	l.position = Vector2(-12 + randf_range(-5, 5), -50)
	l.z_index = 10
	add_child(l)
	var t := l.create_tween()
	t.set_parallel()
	t.tween_property(l, "position:y", l.position.y - 14, 0.6).set_ease(Tween.EASE_OUT)
	t.tween_property(l, "modulate:a", 0.0, 0.6).set_delay(0.25)
	t.chain().tween_callback(l.queue_free)
