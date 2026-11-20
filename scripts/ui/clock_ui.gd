class_name ClockUI
extends Control
## Top-right clock (in the spirit of Stardew Valley's, with our own look):
## a sky dial with moving sun/moon and a sweeping hand, the date, season + weather
## icons, the time (Malay 12-hour), and the player's money (pitis).
## Frames/panels come from the Dark Ages UI pack (UiSkin); the dial is drawn in code.

const SIZE := Vector2(160, 84)
const DIAL_CENTER := Vector2(31, 31)
const DIAL_RADIUS := 27.0
const DAY_START := 6.0     ## hand far left
const DAY_END := 26.0      ## 02:00, hand far right (pass out)

const SEASON_ICONS := [
	preload("res://assets/ui/icons/season_kemarau.png"),
	preload("res://assets/ui/icons/season_musim_buah.png"),
	preload("res://assets/ui/icons/season_tengkujuh.png"),
]
const WEATHER_ICONS := {
	"cerah": preload("res://assets/ui/icons/weather_cerah.png"),
	"hujan": preload("res://assets/ui/icons/weather_hujan.png"),
}
const COIN := preload("res://assets/ui/icons/coin_pitis.png")

var _date: Label
var _time: Label
var _gold: Label
var _season_icon := TextureRect.new()
var _weather_icon := TextureRect.new()
var _dial := Dial.new()


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	offset_left = -SIZE.x - 4
	offset_right = -4
	offset_top = 4
	offset_bottom = 4 + SIZE.y

	var panel := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	panel.position = Vector2(48, 2)
	panel.size = Vector2(110, 58)
	add_child(panel)

	_date = UiSkin.label("", 10, UiSkin.TEXT_GOLD)
	_date.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_date.position = Vector2(56, 6)
	_date.size = Vector2(98, 14)
	add_child(_date)

	for icon in [_weather_icon, _season_icon]:
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.size = Vector2(12, 12)
		add_child(icon)
	_weather_icon.position = Vector2(84, 24)
	_season_icon.position = Vector2(112, 24)

	_time = UiSkin.label("", 10)
	_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_time.position = Vector2(56, 39)
	_time.size = Vector2(98, 14)
	add_child(_time)

	var bar := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	bar.position = Vector2(48, 60)
	bar.size = Vector2(110, 22)
	add_child(bar)
	var coin := TextureRect.new()
	coin.texture = COIN
	coin.position = Vector2(58, 65)
	coin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(coin)
	_gold = UiSkin.label("", 10, UiSkin.TEXT_GOLD)
	_gold.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_gold.position = Vector2(74, 64)
	_gold.size = Vector2(76, 14)
	add_child(_gold)

	add_child(_dial)   # last, so it sits on top of the panel's edge

	GameState.time_changed.connect(func(_m): _refresh())
	GameState.day_changed.connect(func(_d): _refresh())
	GameState.gold_changed.connect(func(_g): _refresh())
	GameState.weather_changed.connect(func(_w): _refresh())
	_refresh()


func _process(_delta: float) -> void:
	_dial.queue_redraw()   # smooth hand + sky between the 10-minute text updates


func _refresh() -> void:
	_date.text = "%s. %d" % [GameState.weekday_short(), GameState.day_of_season()]
	_time.text = GameState.time_text_12h()
	_gold.text = str(GameState.gold)
	_season_icon.texture = SEASON_ICONS[GameState.season_index()]
	_season_icon.tooltip_text = GameState.season_name()
	_weather_icon.texture = WEATHER_ICONS.get(GameState.weather, WEATHER_ICONS["cerah"])


## Hand angle for a time (hours, 6..26): 180° (left) at 06:00 -> 0° (right) at 02:00.
static func hand_angle(hours: float) -> float:
	var t := clampf((hours - DAY_START) / (DAY_END - DAY_START), 0.0, 1.0)
	return PI * (1.0 - t)


## Sun/moon angle on the dial: the sun rises at 06:00 (left), is overhead at ~12:30 and sets
## at 19:00 (right); the moon then rises and crosses until 02:00.
static func body_angle(hours: float) -> float:
	if hours < 19.0:
		return PI * (1.0 - clampf((hours - 6.0) / 13.0, 0.0, 1.0))
	return PI * (1.0 - clampf((hours - 19.0) / 7.0, 0.0, 1.0))


## Sky colour for a time of day (hours, 6..26), greyer in rain.
static func sky_color(hours: float) -> Color:
	var c := _clear_sky(hours)
	if GameState.is_raining():
		c = c.lerp(Color(0.42, 0.45, 0.5) * c.get_luminance() * 2.2, 0.7)
	return c


static func _clear_sky(hours: float) -> Color:
	var dawn := Color(0.93, 0.62, 0.45)
	var day := Color(0.45, 0.66, 0.84)
	var dusk := Color(0.86, 0.47, 0.32)
	var night := Color(0.09, 0.13, 0.22)
	if hours < 7.0:
		return dawn.lerp(day, hours - 6.0)
	if hours < 17.0:
		return day
	if hours < 18.5:
		return day.lerp(dusk, (hours - 17.0) / 1.5)
	if hours < 20.0:
		return dusk.lerp(night, (hours - 18.5) / 1.5)
	return night


class Dial:
	extends Control
	## The round sky window: sky colour, stars at night, sun/moon on an arc, and the hand.

	const OUTLINE := Color(0.18, 0.2, 0.16)     ## pack "Charcoal Brown" #2E322A
	const GOLD := Color(0.86, 0.77, 0.49)        ## pack "Honey Gold" #dcc47c
	const CAMEL := Color(0.76, 0.57, 0.29)       ## pack "Camel" #C19149
	const EARTH := Color(0.24, 0.2, 0.15)

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		size = Vector2(62, 62)

	func _draw() -> void:
		var c := ClockUI.DIAL_CENTER
		var r := ClockUI.DIAL_RADIUS
		var hours := GameState.minutes / 60.0
		# frame
		draw_circle(c, r + 3, OUTLINE)
		draw_circle(c, r + 1.5, GOLD)
		draw_circle(c, r, ClockUI.sky_color(hours))
		# stars at night
		var night := clampf((hours - 19.0) / 1.5, 0.0, 1.0)
		if night > 0.0:
			for p in [Vector2(-14, -12), Vector2(-4, -20), Vector2(9, -16), Vector2(17, -6), Vector2(-19, -3), Vector2(3, -9)]:
				draw_rect(Rect2(c + p, Vector2(1, 1)), Color(1, 1, 0.85, night))
		# sun by day, moon by night, riding the same arc as the hand
		var body_pos := c + Vector2.from_angle(-ClockUI.body_angle(hours)) * (r - 8)
		if GameState.is_raining():
			# rain clouds instead of the sun/moon
			for k in 3:
				draw_circle(c + Vector2(-10 + k * 9, -14 + (k % 2) * 3), 6, Color(0.55, 0.58, 0.62))
			for k in 4:
				draw_line(c + Vector2(-12 + k * 7, -6), c + Vector2(-14 + k * 7, -1), Color(0.6, 0.75, 0.9), 1.0)
		elif hours < 19.0:
			draw_circle(body_pos, 5, Color(1.0, 0.85, 0.4))
			draw_circle(body_pos, 3.5, Color(1.0, 0.95, 0.7))
		else:
			draw_circle(body_pos, 4.5, Color(0.92, 0.92, 0.85))
			draw_circle(body_pos + Vector2(2, -1), 3.5, ClockUI.sky_color(hours))
		# ground (lower half): the kampung horizon
		var ground := PackedVector2Array()
		for i in 17:
			ground.append(c + Vector2.from_angle(PI * i / 16.0) * r)
		draw_colored_polygon(ground, EARTH)
		draw_line(c + Vector2(-r, 0), c + Vector2(r, 0), OUTLINE, 1.0)
		# small attap roof silhouette on the horizon
		draw_colored_polygon(PackedVector2Array([c + Vector2(-16, 0), c + Vector2(-10, -6), c + Vector2(-4, 0)]), OUTLINE)
		# hand
		var tip := c + Vector2.from_angle(-ClockUI.hand_angle(hours)) * (r - 2)
		draw_line(c, tip, OUTLINE, 3.0)
		draw_line(c, tip, CAMEL, 1.0)
		draw_circle(c, 3, OUTLINE)
		draw_circle(c, 2, GOLD)
