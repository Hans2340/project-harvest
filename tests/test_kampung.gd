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
	_check(ground.get_cell_source_id(Vector2i(5, 23)) == 3, "deep river uses blocking water")
	_check(ground.get_cell_source_id(Vector2i(zone.JETTY_X, 22)) == 4, "jetty cells are walkable")
	_check(ground.get_cell_source_id(Vector2i(28, 6)) == 1, "sawah tiles present")
	var houses := 0
	for c in zone.get_node("YSort").get_children():
		if c is Sprite2D and c.texture and c.texture.resource_path.contains("rumah_kampung"):
			houses += 1
	_check(houses == 4, "4 houses placed")
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
