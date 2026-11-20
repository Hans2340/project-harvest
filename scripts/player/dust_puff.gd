class_name DustPuff
extends Node2D
## A small kick of dust at the feet: a few pixel blobs that drift back from the step, grow a little
## and fade. Spawned by the player on running footsteps and when a run starts or stops.

const LIFE := 0.35
const COLOUR := Color(0.86, 0.79, 0.66, 0.75)

## Blobs as [offset, radius]; drawn as hard-edged circles so they read as pixel art.
var _blobs: Array = []


## Adds a puff to `parent` at `pos` (world px). `away` is the direction the dust drifts.
static func spawn(parent: Node, pos: Vector2, away: Vector2, size := 1.0) -> DustPuff:
	var p := DustPuff.new()
	p.position = pos.round()
	for i in 3:
		var off := Vector2(randf_range(-4.0, 4.0), randf_range(-2.0, 1.0)) * size
		p._blobs.append([off, randf_range(1.5, 2.5) * size])
	parent.add_child(p)
	var t := p.create_tween().set_parallel()
	t.tween_property(p, "position", p.position + away * 6.0 * size + Vector2(0, -3), LIFE)
	t.tween_property(p, "scale", Vector2(1.6, 1.6), LIFE)
	t.tween_property(p, "modulate:a", 0.0, LIFE)
	t.chain().tween_callback(p.queue_free)
	return p


func _draw() -> void:
	for b in _blobs:
		draw_circle(b[0], b[1], COLOUR)
