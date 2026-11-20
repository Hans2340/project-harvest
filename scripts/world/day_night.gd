class_name DayNight
extends RefCounted
## Shared time-of-day tint for CanvasModulate.


## `base` lets a zone be darker overall (e.g. the swamp) while still following the clock.
static func tint(minutes: int, base := Color.WHITE) -> Color:
	var h := minutes / 60.0
	var day_col := Color(1, 1, 1)
	var dusk_col := Color(1.0, 0.82, 0.68)
	var night_col := Color(0.32, 0.36, 0.55)
	var c := day_col
	if h < 7.0:
		c = dusk_col.lerp(day_col, h - 6.0)
	elif h < 17.0:
		c = day_col
	elif h < 19.0:
		c = day_col.lerp(dusk_col, (h - 17.0) / 2.0)
	elif h < 21.0:
		c = dusk_col.lerp(night_col, (h - 19.0) / 2.0)
	else:
		c = night_col
	return c * base * weather_tint(h)


## Rain darkens and cools the light; a clear Kemarau day gets a warm dry haze.
static func weather_tint(hours: float) -> Color:
	var tree := Engine.get_main_loop() as SceneTree
	var gs = tree.root.get_node_or_null("GameState") if tree else null
	if gs == null:
		return Color.WHITE
	if gs.is_raining():
		return Color(0.72, 0.76, 0.84)
	if gs.season_index() == 0 and hours > 9.0 and hours < 17.0:
		return Color(1.0, 0.97, 0.88)
	return Color.WHITE
