extends Node
## Global game state (autoloaded as `GameState`).
## Holds time, day and the player's items. Keep gameplay rules elsewhere.

signal day_changed(new_day: int)
signal time_changed(minutes: int)
signal items_changed
signal gold_changed(gold: int)

const DAY_START_MINUTES := 6 * 60   ## 06:00
const DAY_END_MINUTES := 26 * 60    ## 02:00 next day: pass out
## Monsoon seasons (see docs/game-design.md), 28 days each, in this order.
const SEASONS := ["Kemarau", "Musim Buah", "Tengkujuh"]
const DAYS_PER_SEASON := 28
const WEEKDAYS := ["Isnin", "Selasa", "Rabu", "Khamis", "Jumaat", "Sabtu", "Ahad"]
const WEEKDAYS_SHORT := ["Isn", "Sel", "Rab", "Kha", "Jum", "Sab", "Aha"]

const GAME_MINUTES_PER_SECOND := 0.96  ## 25 real minutes = 24 in-game hours (06:00-02:00 day ~ 21 real minutes)

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


## Malay 12-hour clock in 10-minute steps, e.g. "6:50 pagi", "2:30 petang", "9:10 malam".
func time_text_12h() -> String:
	var m := (int(minutes) / 10 * 10) % (24 * 60)
	var h := m / 60
	var part := "pagi"
	if h >= 12 and h < 19:
		part = "petang"
	elif h >= 19 or h < 5:
		part = "malam"
	var h12 := h % 12
	if h12 == 0:
		h12 = 12
	return "%d:%02d %s" % [h12, m % 60, part]


func day_of_season() -> int:
	return (day - 1) % DAYS_PER_SEASON + 1


func season_index() -> int:
	return ((day - 1) / DAYS_PER_SEASON) % SEASONS.size()


func season_name() -> String:
	return SEASONS[season_index()]


func weekday_short() -> String:
	return WEEKDAYS_SHORT[(day - 1) % 7]


## Weather is always clear for now; a weather system can set this later.
var weather := "cerah"


func add_gold(amount: int) -> void:
	gold = max(0, gold + amount)
	gold_changed.emit(gold)


func add_item(id: String, amount: int) -> void:
	items[id] = items.get(id, 0) + amount
	items_changed.emit()


func take_item(id: String, amount: int = 1) -> bool:
	if items.get(id, 0) < amount:
		return false
	items[id] -= amount
	items_changed.emit()
	return true
