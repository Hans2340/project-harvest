extends Node
## Global game state (autoloaded as `GameState`).
## Holds time, day and the player's items. Keep gameplay rules elsewhere.

signal day_changed(new_day: int)
signal time_changed(minutes: int)
signal items_changed

const DAY_START_MINUTES := 6 * 60   ## 06:00
const DAY_END_MINUTES := 26 * 60    ## 02:00 next day: pass out
const GAME_MINUTES_PER_SECOND := 0.4  ## 1 real hour = 24 in-game hours (06:00-02:00 day = 50 real minutes)

var day: int = 1
var minutes: float = DAY_START_MINUTES
var gold: int = 0
var items := {
	"padi_seed": 10,
	"padi": 0,
}
var clock_running := true


func _process(delta: float) -> void:
	if not clock_running:
		return
	var before := int(minutes) / 10
	minutes += delta * GAME_MINUTES_PER_SECOND
	if int(minutes) / 10 != before:
		time_changed.emit(int(minutes))
	if minutes >= DAY_END_MINUTES:
		advance_day()


func advance_day() -> void:
	day += 1
	minutes = DAY_START_MINUTES
	day_changed.emit(day)
	time_changed.emit(int(minutes))


func time_text() -> String:
	var m := int(minutes) % (24 * 60)
	return "%02d:%02d" % [m / 60, m % 60]


func add_item(id: String, amount: int) -> void:
	items[id] = items.get(id, 0) + amount
	items_changed.emit()


func take_item(id: String, amount: int = 1) -> bool:
	if items.get(id, 0) < amount:
		return false
	items[id] -= amount
	items_changed.emit()
	return true
