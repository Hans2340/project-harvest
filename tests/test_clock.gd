extends SceneTree
## Headless test for the clock UI and calendar helpers.
## Run: godot --headless --path . -s tests/test_clock.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 3:
		await process_frame
	var gs = root.get_node("GameState")
	var clock = current_scene.get_node("HUD").clock

	gs.minutes = 6 * 60 + 57
	_check(gs.time_text_12h() == "6:50 pagi", "time shows in 10-minute steps (%s)" % gs.time_text_12h())
	gs.minutes = 14 * 60 + 30
	_check(gs.time_text_12h() == "2:30 petang", "afternoon = petang")
	gs.minutes = 21 * 60 + 10
	_check(gs.time_text_12h() == "9:10 malam", "night = malam")
	gs.minutes = 24 * 60 + 40
	_check(gs.time_text_12h() == "12:40 malam", "after midnight still malam")

	_check(is_equal_approx(clock.hand_angle(6.0), PI) and is_equal_approx(clock.hand_angle(26.0), 0.0), "hand sweeps left (06:00) to right (02:00)")
	_check(absf(clock.body_angle(12.5) - PI / 2.0) < 0.01, "sun is overhead around 12:30")

	gs.day = 1
	_check(gs.weekday_short() == "Isn" and gs.season_name() == "Kemarau" and gs.day_of_season() == 1, "day 1 = Isnin 1, Kemarau")
	gs.day = 30
	_check(gs.season_name() == "Musim Buah" and gs.day_of_season() == 2 and gs.weekday_short() == "Sel", "day 30 = Selasa 2, Musim Buah")
	gs.day = 1
	gs.day_changed.emit(1)

	gs.add_gold(500)
	_check(clock._gold.text == "500", "money shown in the clock")
	gs.time_changed.emit(int(gs.minutes))
	_check(clock._time.text == gs.time_text_12h() and clock._date.text == "Isn. 1", "clock labels update")

	# Style switch (dev tools): rebuilds the clock, labels still live, saved in settings.
	var before: String = gs.clock_style
	var other := "kayu" if before == "lama" else "lama"
	gs.set_clock_style(other)
	await process_frame
	_check(clock.style == other and clock._dial.kayu == (other == "kayu"), "clock rebuilt in the %s style" % other)
	_check(clock._gold.text == "500" and clock._time.text == gs.time_text_12h(), "labels still filled after the switch")
	var cfg := ConfigFile.new()
	cfg.load(gs.SETTINGS_PATH)
	_check(cfg.get_value("ui", "clock_style", "") == other, "style saved to settings")
	gs.set_clock_style(before)

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
