extends SceneTree
## Headless smoke test for the mangrove zone.
## Run: godot --headless --path . -s tests/test_mangrove.gd

var ok := true


func _initialize() -> void:
	var zone = load("res://scenes/world/mangrove.tscn").instantiate()
	root.add_child(zone)
	await process_frame
	var ground: TileMapLayer = zone.get_node("Ground")
	var w: int = zone._width()
	var h: int = zone.LAYOUT.size()
	var filled := 0
	for y in h:
		for x in w:
			if ground.get_cell_source_id(Vector2i(x, y)) != -1:
				filled += 1
	_check(filled == w * h, "every cell has a tile (%d/%d)" % [filled, w * h])
	_check(ground.get_cell_source_id(Vector2i(4, 7)) == 2, "boardwalk cell uses walkable water")
	_check(ground.get_cell_source_id(Vector2i(10, 7)) == 1, "open water blocks movement")
	var src: TileSetAtlasSource = ground.tile_set.get_source(1)
	_check(src.get_tile_animation_frames_count(Vector2i(0, 0)) == 4, "water is animated (4 frames)")
	_check(zone._altar_cells.size() == 6, "altar placed")
	_check(zone.get_node("YSort").get_child_count() > 10, "props placed (%d)" % zone.get_node("YSort").get_child_count())
	var player = zone.get_node("YSort/Player")
	_check(player.global_position.distance_to(zone.get_node("Spawns/from_farm").global_position) < 1.0, "player at farm entrance")
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
