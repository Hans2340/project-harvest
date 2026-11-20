extends SceneTree
## Headless test: plant padi in the kampung sawah -> sleep x3 -> harvest; plots persist.
## Run: godot --headless --path . -s tests/test_sawah_farming.gd

const HOE := 0
const SEEDS := 1
const WATER := 2

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 3:
		await process_frame
	var k = current_scene
	var gs = root.get_node("GameState")
	var fs = root.get_node("FarmState")
	var cell := Vector2i(38, 7)
	_check(k.is_sawah(cell), "test cell is sawah")

	k._on_use_requested(HOE, cell)
	_check(not fs.plots.has(cell), "hoe is not needed in the sawah")
	k._on_use_requested(SEEDS, cell)
	_check(fs.plots.has(cell) and fs.plots[cell].crop == "padi" and gs.items.padi_seed == 9, "planting padi uses a seed")
	_check(k._crop_sprites.has(cell), "padi sprite shown")
	for i in 3:
		k._on_use_requested(SEEDS, Vector2i(11, 9))   # facing the home house = sleep
	_check(gs.day == 4, "sleeping at home advances the day (day %d)" % gs.day)
	_check(fs.plots[cell].stage == 3, "sawah padi grows every night without watering (stage %d)" % fs.plots[cell].stage)
	k = current_scene
	k._on_use_requested(HOE, cell)
	_check(gs.items.padi == 2 and fs.plots[cell].crop == "", "harvest gives 2 padi")

	k._on_use_requested(SEEDS, Vector2i(15, 11))
	_check(not fs.plots.has(Vector2i(15, 11)), "cannot plant on the dirt yard")

	k._on_use_requested(SEEDS, cell)
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 3:
		await process_frame
	_check(current_scene._crop_sprites.has(cell), "planted padi persists after reloading the zone")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
