extends SceneTree
## Headless test: farm -> mangrove -> farm through the exits, and waking in bed
## after passing out in the swamp.
## Run: godot --headless --path . -s tests/test_zone_travel.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/farm.tscn")
	await _frames(3)
	_check(current_scene.name == "Farm", "starts on farm")

	# walk into the south exit
	current_scene.get_node("YSort/Player").global_position = current_scene.get_node("ExitToMangrove").global_position
	await _frames(10)
	_check(current_scene.name == "Mangrove", "south exit leads to mangrove")
	var p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/from_farm").global_position) < 1.0, "arrive at mangrove entrance")
	_check(p.tile_size == 48.0, "player uses 48 px grid in swamp")

	# walk back through the north exit
	p.global_position = current_scene.get_node("ExitToFarm").global_position
	await _frames(10)
	_check(current_scene.name == "Farm", "north exit returns to farm")
	p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/from_mangrove").global_position) < 1.0, "arrive at farm's south path")

	# east exit -> kampung and back
	p.global_position = current_scene.get_node("ExitToKampung").global_position
	await _frames(10)
	_check(current_scene.name == "Kampung", "east exit leads to kampung")
	p = current_scene.get_node("YSort/Player")
	p.global_position = current_scene.get_node("ExitToFarm").global_position
	await _frames(10)
	_check(current_scene.name == "Farm", "kampung west exit returns to farm")
	p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/from_kampung").global_position) < 1.0, "arrive at farm's east path")

	# pass out in the swamp -> wake in bed on the farm
	p.global_position = current_scene.get_node("ExitToMangrove").global_position
	await _frames(10)
	root.get_node("GameState").advance_day()
	await _frames(10)
	_check(current_scene.name == "Farm", "new day sends you home")
	p = current_scene.get_node("YSort/Player")
	_check(p.global_position.distance_to(current_scene.get_node("Spawns/bed").global_position) < 1.0, "wake next to the bed")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _frames(n: int) -> void:
	for i in n:
		await physics_frame
		await process_frame


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
