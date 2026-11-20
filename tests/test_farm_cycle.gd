extends SceneTree
## Headless smoke test: hoe -> plant -> water -> sleep x3 -> harvest.
## Run: godot --headless --path . -s tests/test_farm_cycle.gd
## (Uses untyped access: autoloads/class names aren't ready when a -s script compiles.)

const HOE := 0
const SEEDS := 1
const WATER := 2
const TILLED := 2
const WATERED := 3
const POND := 4

var ok := true


func _initialize() -> void:
	var farm = load("res://scenes/world/farm.tscn").instantiate()
	root.add_child(farm)
	await process_frame
	var gs = root.get_node("GameState")
	var cell := Vector2i(15, 18)

	farm._on_use_requested(HOE, cell)
	_check(farm._tile(cell) == TILLED, "hoe tills grass")
	farm._on_use_requested(SEEDS, cell)
	_check(farm.plots[cell].crop != null and gs.items.padi_seed == 9, "planting uses a seed")
	for i in 3:
		farm._on_use_requested(WATER, cell)
		_check(farm._tile(cell) == WATERED, "watered on day %d" % (i + 1))
		farm._sleep()
	_check(farm.plots[cell].stage == 3, "padi ripe after 3 watered days (stage %d)" % farm.plots[cell].stage)
	_check(gs.day == 4, "day advanced to 4")
	_check(farm._tile(cell) == TILLED, "soil dries overnight")
	farm._on_use_requested(HOE, cell)
	_check(gs.items.padi == 2 and farm.plots[cell].crop == null, "harvest gives 2 padi")

	var c2 := Vector2i(16, 18)
	farm._on_use_requested(HOE, c2)
	farm._on_use_requested(SEEDS, c2)
	farm._sleep()
	_check(farm.plots[c2].stage == 0, "unwatered crop does not grow")

	farm._on_use_requested(HOE, Vector2i(6, 12))
	_check(not farm.plots.has(Vector2i(6, 12)), "cannot hoe the path")
	_check(farm._tile(Vector2i(30, 6)) == POND, "pond is water")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
