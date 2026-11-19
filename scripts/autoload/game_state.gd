extends Node
## Global game state (autoloaded as `GameState`).
## Keep this small: time, money, and save/load hooks.

signal day_changed(new_day: int)

var day: int = 1
var gold: int = 0


func advance_day() -> void:
	day += 1
	day_changed.emit(day)
