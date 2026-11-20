extends SceneTree
## Headless test for the environment: wind sway, lamps by night, weather rolls and rain.
## Run: godot --headless --path . -s tests/test_ambience.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 3:
		await process_frame
	var z = current_scene
	var gs = root.get_node("GameState")
	var amb = z.ambience

	var swaying := 0
	for n in z.get_node("YSort").get_children():
		if n.has_meta("tree") and n.material != null and n.material.shader.resource_path.ends_with("wind_sway.gdshader"):
			swaying += 1
	_check(swaying == 24, "all 24 trees sway in the wind (%d)" % swaying)
	_check(amb.water_cells.size() > 100 and amb.firefly_cells.size() > 50, "water glint and firefly areas found")
	_check(amb._lamps.size() == 4, "a pelita lamp at each house")

	gs.minutes = 12 * 60
	await process_frame
	_check(amb._lamps[0].energy == 0.0, "lamps off at noon")
	gs.minutes = 22 * 60
	await process_frame
	_check(amb._lamps[0].energy > 1.0, "lamps glow at night")

	gs.set_weather("hujan")
	for i in 3:
		await process_frame
	_check(amb._fx_draw._drops.size() > 100, "rain falls when it rains")
	_check(amb.get_sway_material().get_shader_parameter("gust") > 0.0, "wind is stronger in rain")
	var day_night = load("res://scripts/world/day_night.gd")
	var dry: Color = day_night.tint(12 * 60)
	gs.set_weather("cerah")
	for i in 3:
		await process_frame
	_check(amb._fx_draw._drops.is_empty(), "rain stops")
	_check(day_night.tint(12 * 60).get_luminance() > dry.get_luminance(), "rain darkens the light")

	# weather rolls: day 1 is always clear; Tengkujuh is rainier than Kemarau
	var rainy := [0, 0, 0]
	for d in range(2, 2 + 84 * 3):
		gs.day = d
		gs.roll_weather()
		if gs.is_raining():
			rainy[gs.season_index()] += 1
	_check(rainy[2] > rainy[1] and rainy[1] > rainy[0], "Tengkujuh rainiest, Kemarau driest %s" % [rainy])
	gs.day = 1
	gs.roll_weather()
	_check(not gs.is_raining(), "day 1 is clear")

	change_scene_to_file("res://scenes/world/mangrove.tscn")
	for i in 3:
		await process_frame
	_check(current_scene.ambience.water_cells.size() > 100, "swamp has ambience too")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
