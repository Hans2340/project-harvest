extends SceneTree
## Headless test for the dev tools: F1 opens the window, and picking a character swaps the
## player's sheet and keeps it across zone changes.
## Run: godot --headless --path . -s tests/test_dev_tools.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	var gs = root.get_node("GameState")
	var z = current_scene
	var hud = z.find_child("HUD", true, false)
	var dev = hud.dev_tools
	_check(dev != null and not dev.visible, "dev tools exist in a debug build and start hidden")

	var key := InputEventKey.new()
	key.keycode = KEY_F1
	key.pressed = true
	root.push_input(key)
	await process_frame
	_check(dev.visible, "F1 opens the dev tools")

	var p = z.player
	var lelaki: Texture2D = p.sprite.texture
	dev._char_buttons["pendekar_perempuan"].pressed.emit()
	await process_frame
	_check(gs.character == "pendekar_perempuan", "picking Pendekar perempuan sets the character")
	_check(p.sprite.texture != lelaki and p.sprite.texture.resource_path.contains("pendekar_perempuan"),
		"the player's sheet swaps to hers")
	_check(p.sprite.hframes == 8 and p.sprite.vframes == 18, "same 8x18 sheet layout")

	change_scene_to_file("res://scenes/world/mangrove.tscn")
	for i in 4:
		await process_frame
	_check(current_scene.player.sprite.texture.resource_path.contains("pendekar_perempuan"),
		"the pick stays after changing zone")
	gs.set_character("pendekar_lelaki")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
