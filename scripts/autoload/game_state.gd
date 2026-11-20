extends Node
## Global game state (autoloaded as `GameState`).
## Holds time, day and the player's items. Keep gameplay rules elsewhere.

signal day_changed(new_day: int)
signal time_changed(minutes: int)
signal items_changed
signal gold_changed(gold: int)
signal weather_changed(weather: String)
signal character_changed(id: String)

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

## Playable characters: id -> display name. Each has `assets/sprites/player/<id>/player_sheet.png`
## in the same 8x9 layout. Picked from the dev tools (F1) for now.
const CHARACTERS := {
	"pendekar_lelaki": "Pendekar lelaki",
	"pendekar_perempuan": "Pendekar perempuan",
}
var character := "pendekar_lelaki"


func set_character(id: String) -> void:
	if not CHARACTERS.has(id) or id == character:
		return
	character = id
	character_changed.emit(id)


static func character_sheet(id: String) -> Texture2D:
	return load("res://assets/sprites/player/%s/player_sheet.png" % id)


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
	roll_weather()
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


## Today's weather: "cerah" (clear) or "hujan" (rain). Rolled each morning from the season.
var weather := "cerah"
## Chance of rain per season (Kemarau, Musim Buah, Tengkujuh).
const RAIN_CHANCE := [0.06, 0.25, 0.65]


## Deterministic per day, so a day's weather is the same if you reload it later.
func roll_weather() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = day * 7919 + 13
	set_weather("hujan" if day > 1 and rng.randf() < RAIN_CHANCE[season_index()] else "cerah")


func set_weather(w: String) -> void:
	weather = w
	weather_changed.emit(weather)


func is_raining() -> bool:
	return weather == "hujan"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):   # F11
		toggle_fullscreen()
	if event.is_action_pressed("debug_weather"):   # F7: toggle rain for testing
		set_weather("cerah" if is_raining() else "hujan")


## Windows keeps the taskbar on top of a plain (borderless) fullscreen window, so use exclusive
## fullscreen, which covers the whole screen.
func toggle_fullscreen() -> void:
	var mode := DisplayServer.window_get_mode()
	var full := mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if full else DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	if full:
		fit_window.call_deferred()


const TITLE_BAR := 40   ## px kept free above the window for its title bar


func _ready() -> void:
	fit_window()


## Size the window to the largest whole multiple of the base resolution (640x360) that fits the
## screen's usable area (minus the taskbar and the title bar), and centre it: 1280x720 on a 1080p
## screen, 1920x1080 on 1440p, 3200x1800 on 4K. The stretch aspect is "expand", so any other window
## shape or screen ratio shows more of the world instead of black bars.
func fit_window() -> void:
	if DisplayServer.get_name() == "headless" or Engine.is_embedded_in_editor():
		return
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		return
	var base := Vector2i(ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
	var area := DisplayServer.screen_get_usable_rect()
	var scale := maxi(1, mini(area.size.x / base.x, (area.size.y - TITLE_BAR) / base.y))
	var size := base * scale
	DisplayServer.window_set_min_size(base)
	DisplayServer.window_set_size(size)
	DisplayServer.window_set_position(area.position + (area.size - size) / 2 + Vector2i(0, TITLE_BAR / 2))


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
