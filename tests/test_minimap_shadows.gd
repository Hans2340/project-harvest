extends SceneTree
## Headless test for the minimap and ground shadows.
## Run: godot --headless --path . -s tests/test_minimap_shadows.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	var z = current_scene
	var mm = z.get_node("HUD").minimap
	var tex: Texture2D = mm._map_rect.texture
	_check(tex != null and tex.get_width() == 46 * mm._scale and tex.get_height() == 32 * mm._scale, "kampung minimap built (46x32 tiles at %dx)" % mm._scale)
	var pp: Vector2 = mm.player_point()
	_check(pp.x > 0 and pp.y > 0 and pp.x < tex.get_width() and pp.y < tex.get_height(), "player dot inside the map")
	var sun_count: int = z.sun_shadows.caster_count() + z.sun_shadows.box_count()
	_check(sun_count >= 28, "sun shadows for houses, trees and props (%d)" % sun_count)

	var ev := InputEventAction.new()
	ev.action = "minimap"
	ev.pressed = true
	mm._unhandled_input(ev)
	_check(not mm.visible, "M hides the minimap")
	mm._unhandled_input(ev)
	_check(mm.visible, "M shows it again")

	change_scene_to_file("res://scenes/world/mangrove.tscn")
	for i in 4:
		await process_frame
	mm = current_scene.get_node("HUD").minimap
	_check(mm._map_rect.texture != null and mm._map_rect.texture.get_width() == 32 * mm._scale, "swamp minimap built")
	_check(current_scene.sun_shadows.caster_count() > 5, "swamp props have sun shadows")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
