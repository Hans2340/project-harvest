extends SceneTree
## Headless test for kampung ground detail: base dressing, scatter, puddles, path edging, birds.
## Run: godot --headless --path . -s tests/test_ground_detail.gd

var ok := true


func _initialize() -> void:
	var gs = root.get_node("GameState")
	gs.minutes = 10 * 60
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	var z = current_scene
	var counts := {}
	var on_path := 0
	for n in z.get_node("YSort").get_children() + z._ground_cover.get_children():
		if n.has_meta("ground"):
			var g: String = n.get_meta("ground")
			counts[g] = counts.get(g, 0) + 1
			var cell := Vector2i(n.position / 48.0)
			if z._on_path(cell) and not g.begins_with("batu_tepi"):
				on_path += 1
	var total := 0
	for k in counts:
		total += counts[k]
	_check(total > 250, "plenty of ground detail (%d pieces)" % total)
	_check(counts.get("serpihan", 0) >= 10, "wood chips around the firewood")
	_check(counts.get("lumut", 0) >= 5, "moss at the foot of jars and posts")
	_check(counts.get("daun", 0) >= 30, "fallen leaves under the fruit trees")
	_check(counts.get("batu_tepi_h", 0) + counts.get("batu_tepi_v", 0) >= 30, "stone edging along the paths")
	_check(counts.get("renek", 0) >= 5 and counts.get("pelepah", 0) >= 4, "bushes and fallen palm fronds")
	_check(on_path == 0, "no scattered cover on the paths (%d)" % on_path)

	gs.set_weather("cerah")
	_check(z._puddles.size() > 0 and z._puddles.all(func(p): return not p.visible), "puddles hidden on a clear day")
	gs.set_weather("hujan")
	_check(z._puddles.all(func(p): return p.visible), "puddles appear in the rain")
	gs.set_weather("cerah")

	# birds: on the ground by day, fly off when the player comes close
	_check(z.birds.on_ground() == 7, "7 burung tiung on the ground")
	var bird: Sprite2D = z.birds._birds[0][0]
	z.player.global_position = bird.position + Vector2(20, 0)
	await process_frame
	await process_frame
	_check(z.birds.flying() >= 1, "a bird flies off when you come close")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
