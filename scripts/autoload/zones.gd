extends Node
## Zone travel (autoloaded as `Zones`). Remembers which spawn point to use
## after a scene change, and sends the player home to bed on a new day.

const FARM_SCENE := "res://scenes/world/farm.tscn"
const BED_SPAWN := "bed"

var next_spawn: String = ""
var _travelling := false


func _ready() -> void:
	GameState.day_changed.connect(_on_day_changed)


func travel(scene_path: String, spawn: String) -> void:
	if _travelling:
		return
	_travelling = true
	next_spawn = spawn
	get_tree().change_scene_to_file.call_deferred(scene_path)
	_finish_travel.call_deferred()


func _finish_travel() -> void:
	_travelling = false


## Place `player` at the pending spawn point of `zone` (or `fallback`), then clear it.
func place_player(zone: Node, player: Node2D, fallback: Vector2) -> void:
	var spawns := zone.get_node_or_null("Spawns")
	var marker: Node2D = spawns.get_node_or_null(next_spawn) if spawns and next_spawn != "" else null
	player.global_position = marker.global_position if marker else fallback
	next_spawn = ""


## Passing out or sleeping always wakes you in your bed on the farm.
func _on_day_changed(_day: int) -> void:
	var scene := get_tree().current_scene
	if scene and scene.scene_file_path != FARM_SCENE:
		travel(FARM_SCENE, BED_SPAWN)
