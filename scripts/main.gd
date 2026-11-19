extends Node2D
## Entry scene. Replace with the title screen / farm once those exist.


func _ready() -> void:
	print("Project Harvest started. Day %d" % GameState.day)
