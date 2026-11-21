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

## "kayu" style: carved wood and gold, made with PixelLab from leoxent's mockup
## (assets/ui/clock_kayu/README.md).
const KAYU_PANEL := preload("res://assets/ui/clock_kayu/panel.png")
const KAYU_BAR := preload("res://assets/ui/clock_kayu/bar.png")

var style := ""
var _date: Label
var _time: Label
var _gold: Label
var _season_icon: TextureRect
var _weather_icon: TextureRect
var _dial: Dial


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	offset_left = -SIZE.x - 4
	offset_right = -4
	offset_top = 4
	offset_bottom = 4 + SIZE.y
	_build(GameState.clock_style)
	GameState.clock_style_changed.connect(_build)
	GameState.time_changed.connect(func(_m): _refresh())
	GameState.day_changed.connect(func(_d): _refresh())
	GameState.gold_changed.connect(func(_g): _refresh())
	GameState.weather_changed.connect(func(_w): _refresh())


## (Re)build the clock in a style ("lama" or "kayu").
func _build(new_style: String) -> void:
	style = new_style
	for c in get_children():
		remove_child(c)
		c.queue_free()
	_season_icon = TextureRect.new()
	_weather_icon = TextureRect.new()
	_dial = Dial.new()
	_dial.kayu = style == "kayu"
	if _dial.kayu:
		_dial.size = Vector2(64, 64)
		_build_kayu()
	else:
		_build_lama()
	for icon in [_weather_icon, _season_icon]:
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon.size = Vector2(12, 12)
	add_child(_dial)   # last, so it sits on top of the panel's edge
	_refresh()


func _build_lama() -> void:
	var panel := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	panel.position = Vector2(48, 2)
	panel.size = Vector2(110, 58)
	add_child(panel)
	_date = _text(Vector2(56, 6), Vector2(98, 14), UiSkin.TEXT_GOLD)
	add_child(_weather_icon)
	add_child(_season_icon)
	_weather_icon.position = Vector2(84, 24)
	_season_icon.position = Vector2(112, 24)
	_time = _text(Vector2(56, 39), Vector2(98, 14), UiSkin.TEXT)
	var bar := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	bar.position = Vector2(48, 60)
	bar.size = Vector2(110, 22)
	add_child(bar)
	_coin_and_gold(Vector2(58, 65), Vector2(74, 64))


func _build_kayu() -> void:
	_sprite(KAYU_PANEL, Vector2(48, 2))   # 112 x 56; the dial covers its left edge
	_date = _text(Vector2(60, 7), Vector2(88, 14), UiSkin.TEXT_GOLD)
	add_child(_weather_icon)
	add_child(_season_icon)
	_weather_icon.position = Vector2(85, 22)
	_season_icon.position = Vector2(113, 22)
	_time = _text(Vector2(60, 38), Vector2(88, 14), UiSkin.TEXT)
	_sprite(KAYU_BAR, Vector2(48, 60))   # 112 x 22
	_coin_and_gold(Vector2(58, 65), Vector2(72, 64))


func _sprite(tex: Texture2D, pos: Vector2) -> TextureRect:
	var r := TextureRect.new()
	r.texture = tex
	r.position = pos
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(r)
	return r


func _text(pos: Vector2, size_: Vector2, color: Color) -> Label:
	var l := UiSkin.label("", 10, color)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.position = pos
	l.size = size_
	add_child(l)
	return l


func _coin_and_gold(coin_pos: Vector2, gold_pos: Vector2) -> void:
	_sprite(COIN, coin_pos)
	_gold = UiSkin.label("", 10, UiSkin.TEXT_GOLD)
	_gold.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_gold.position = gold_pos
	_gold.size = Vector2(76, 14)
	add_child(_gold)


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

	const RING := preload("res://assets/ui/clock_kayu/dial_ring.png")
	const HILLS := preload("res://assets/ui/clock_kayu/dial_hills.png")
	const KERIS := preload("res://assets/ui/clock_kayu/keris.png")
	const K_CENTER := Vector2(31.5, 32.0)   ## centre of the ring art (64 x 64)
	const K_RADIUS := 24.5                  ## inside of the ring
	const KERIS_PIVOT := Vector2(19, 5.5)   ## the guard; the blade points to the tip at (0, 0.5)
	const KERIS_ANGLE := -2.884             ## atan2(-5, -19): the blade's direction in the art

	var kayu := false

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		size = Vector2(62, 62)

	func _draw() -> void:
		if kayu:
			_draw_kayu()
			return
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

	## Carved style: code sky, sun/moon and stars under the PixelLab hills, the keris as the
	## hand, and the gold ring on top.
	func _draw_kayu() -> void:
		var c := K_CENTER
		var r := K_RADIUS
		var hours := GameState.minutes / 60.0
		draw_circle(c, r, ClockUI.sky_color(hours))
		var night := clampf((hours - 19.0) / 1.5, 0.0, 1.0)
		if night > 0.0:
			for p in [Vector2(-13, -12), Vector2(-4, -18), Vector2(8, -15), Vector2(15, -6), Vector2(-17, -4), Vector2(3, -9)]:
				draw_rect(Rect2((c + p).floor(), Vector2(1, 1)), Color(1, 1, 0.85, night))
		if GameState.is_raining():
			for k in 3:
				draw_circle(c + Vector2(-9 + k * 8, -13 + (k % 2) * 3), 5, Color(0.55, 0.58, 0.62))
			for k in 4:
				draw_line(c + Vector2(-11 + k * 6, -6), c + Vector2(-13 + k * 6, -1), Color(0.6, 0.75, 0.9), 1.0)
		else:
			var body := (c + Vector2.from_angle(-ClockUI.body_angle(hours)) * (r - 8)).floor()
			if hours < 19.0:
				draw_circle(body, 4.5, Color(1.0, 0.85, 0.4))
				draw_circle(body, 3, Color(1.0, 0.95, 0.7))
			else:
				draw_circle(body, 4, Color(0.92, 0.92, 0.85))
				draw_circle(body + Vector2(2, -1), 3, ClockUI.sky_color(hours))
		draw_texture(HILLS, Vector2.ZERO)
		draw_set_transform(c, -ClockUI.hand_angle(hours) - KERIS_ANGLE)
		draw_texture(KERIS, -KERIS_PIVOT)
		draw_set_transform(Vector2.ZERO)
		draw_texture(RING, Vector2.ZERO)
