extends SceneTree
## Headless test for the kampung zone.
## Run: godot --headless --path . -s tests/test_kampung.gd

var ok := true


func _initialize() -> void:
	var zone = load("res://scenes/world/kampung.tscn").instantiate()
	root.add_child(zone)
	await process_frame
	var ground: TileMapLayer = zone.get_node("Ground")
	var w: int = zone._width()
	var h: int = zone._height()
	var bad := 0
	var filled := 0
	for y in h:
		for x in w:
			if zone.tile_for(Vector2i(x, y)).is_empty():
				bad += 1
			if ground.get_cell_source_id(Vector2i(x, y)) != -1:
				filled += 1
	_check(bad == 0, "every cell mixes only supported terrain pairs")
	_check(filled == w * h, "every cell has a tile (%d/%d)" % [filled, w * h])
	_check(ground.get_cell_source_id(Vector2i(5, 31)) == 3, "deep river uses blocking water")
	_check(ground.get_cell_source_id(Vector2i(zone.JETTY_X, 30)) == 4, "jetty cells are walkable")
	_check(ground.get_cell_source_id(Vector2i(38, 7)) == 1, "sawah tiles present")
	var houses := 0
	for c in zone.get_node("YSort").get_children():
		if c is Sprite2D and c.texture and c.texture.resource_path.contains("rumah_kampung"):
			houses += 1
	_check(houses == 4, "4 houses placed")
	var trees := 0
	var bad_trees := []
	for t in zone.PALMS + zone.FRUIT_TREES:
		var c: Vector2i = t[1]
		var corners: String = zone._corner(c.x, c.y) + zone._corner(c.x + 1, c.y) + zone._corner(c.x, c.y + 1) + zone._corner(c.x + 1, c.y + 1)
		if corners.contains("w") or corners.contains("s") or (c.y in [11, 12] and c.x < 31):
			bad_trees.append(c)
	for c in zone.get_node("YSort").get_children():
		if c.has_meta("tree"):
			trees += 1
	_check(trees == 24 and bad_trees.is_empty(), "24 trees on dry ground, off the main path (bad: %s)" % [bad_trees])
	var game_time = root.get_node("GameState").GAME_MINUTES_PER_SECOND
	_check(is_equal_approx(game_time * 25.0 * 60.0, 24.0 * 60.0), "25 real minutes = 24 game hours")
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
