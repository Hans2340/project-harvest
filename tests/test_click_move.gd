extends SceneTree
## Headless test for click-to-move: walking, pathing round the home house, clicking the dummy
## to strike it, clicking the sawah to plant, and WASD taking control back.
## Run: godot --headless --path . -s tests/test_click_move.gd

var ok := true
var farm: Node


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	farm = root.get_node("FarmState")
	var z = current_scene
	var p = z.player
	var home: Vector2 = p.global_position

	# Open ground, a few tiles right.
	var goal := home + Vector2(150, 30)
	p.click_at(goal)
	_check(p.is_walking_path(), "a click on the ground gives a path")
	await _walk(p, 400)
	_check(p.global_position.distance_to(goal) < 6.0, "walked to the click (%.1f px off)" % p.global_position.distance_to(goal))

	# Behind the home house: the straight line is blocked, so the path goes round it.
	p.global_position = home
	await physics_frame
	goal = home + Vector2(0, -150)
	p.click_at(goal)
	_check(p._path.size() >= 2, "behind the house: the path turns (%d waypoints)" % p._path.size())
	await _walk(p, 900)
	_check(p.global_position.distance_to(goal) < 6.0, "walked round the house to the click (%.1f px off)" % p.global_position.distance_to(goal))

	# Click the dummy from a few tiles away: walk up and strike it.
	var d = z.dummy
	var hits_before: int = d.hits
	p.global_position = d.global_position + Vector2(-140, 40)
	await physics_frame
	p.click_at(d.hit_center())
	await _until(func(): return d.hits > hits_before, 400)
	_check(d.hits > hits_before, "clicking the dummy walks up and strikes it")

	# Click an empty sawah plot with the seeds: walk next to it and plant.
	var cell := _nearest_sawah(z, p.global_position)
	_check(cell.x >= 0, "found an empty sawah plot")
	p.current_tool = 1   # seeds
	_check(p.is_use_target(cell), "the empty plot is a click target with the seeds")
	p.click_at((Vector2(cell) + Vector2(0.5, 0.5)) * z.TILE)
	await _until(func(): return farm.plots.has(cell), 900)
	_check(farm.plots.has(cell), "clicking the plot walks over and plants it")
	p.current_tool = 0
	_check(not p.is_use_target(cell), "a planted plot isn't a click target any more")

	# A movement key takes control back.
	p.click_at(p.global_position + Vector2(200, 0))
	await physics_frame
	Input.action_press("move_down")
	await physics_frame
	await physics_frame
	Input.action_release("move_down")
	_check(not p.is_walking_path(), "a movement key cancels the click path")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _nearest_sawah(z, from: Vector2) -> Vector2i:
	var best := Vector2i(-1, -1)
	var best_d := INF
	for y in z._height():
		for x in z._width():
			var c := Vector2i(x, y)
			if z.is_sawah(c) and not farm.plots.has(c):
				var dist := from.distance_to((Vector2(c) + Vector2(0.5, 0.5)) * z.TILE)
				if dist < best_d:
					best_d = dist
					best = c
	return best


func _walk(p, max_frames: int) -> void:
	await _until(func(): return not p.is_walking_path(), max_frames)


func _until(cond: Callable, max_frames: int) -> void:
	for i in max_frames:
		if cond.call():
			return
		await physics_frame


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
