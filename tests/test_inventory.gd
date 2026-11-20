extends SceneTree
## Headless test for the inventory window and hotbar.
## Run: godot --headless --path . -s tests/test_inventory.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/farm.tscn")
	for i in 3:
		await process_frame
	var hud = current_scene.get_node("HUD")
	var gs = root.get_node("GameState")
	var inv = hud.inventory

	_check(not inv.visible, "inventory starts closed")
	_check(hud.hotbar._slots.size() == 3, "hotbar has 3 tool slots")
	_check(hud.hotbar._slots[0].texture.region == UiSkin.SLOT_SELECTED, "hoe selected at start")

	inv.open_inventory()
	_check(inv.visible and paused, "opening shows window and pauses game")
	_check(inv._slots[0].item_id == "padi_seed" and inv._slots[0]._count.text == "10", "first slot: 10 padi seeds")
	_check(inv._slots[1].item_id == "", "padi hidden while count is 0")
	_check(inv._name.text.begins_with("Benih Padi"), "details show item name")

	gs.add_item("padi", 4)
	_check(inv._slots[1].item_id == "padi" and inv._slots[1]._count.text == "4", "new items appear live")

	inv.close_inventory()
	_check(not inv.visible and not paused, "closing resumes game")
	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
