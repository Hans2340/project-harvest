extends SceneTree
## Headless test: kampung -> swamp -> kampung through the exits, and waking at home
## after passing out in the swamp.
## Run: godot --headless --path . -s tests/test_zone_travel.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file(ProjectSettings.get_setting("application/run/main_scene"))
	await _frames(3)
	_check(current_scene.name == "Kampung", "game starts in the kampung")
	var p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/home").global_position) < 1.0, "start at home")

	p.global_position = current_scene.get_node("ExitToMangrove").global_position
	await _frames(10)
	_check(current_scene.name == "Mangrove", "west path leads to the swamp")
	p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/from_kampung").global_position) < 1.0, "arrive at swamp entrance")
	_check(p.tile_size == 48.0, "player uses 48 px grid")

	p.global_position = current_scene.get_node("ExitToKampung").global_position
	await _frames(10)
	_check(current_scene.name == "Kampung", "swamp exit returns to kampung")
	p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/from_mangrove").global_position) < 1.0, "arrive on the kampung's west path")

	p.global_position = current_scene.get_node("ExitToMangrove").global_position
	await _frames(10)
	root.get_node("GameState").advance_day()
	await _frames(10)
	_check(current_scene.name == "Kampung", "new day sends you home")
	p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/home").global_position) < 1.0, "wake at home")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _frames(n: int) -> void:
	for i in n:
		await physics_frame
		await process_frame


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
