class_name ZoneExit
extends Area2D
## Walk into this area to travel to another zone.
## `target_spawn` must match the name of a Marker2D under the target zone's "Spawns" node.

@export_file("*.tscn") var target_scene: String
@export var target_spawn: String = ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		Zones.travel(target_scene, target_spawn)
