extends SceneTree
## Headless test for sun-driven cast shadows, pelita shadows and the Asar notice.
## Run: godot --headless --path . -s tests/test_sun_shadows.gd

var ok := true


func _initialize() -> void:
	var kemarau := 0
	var tengkujuh := 2
	_check(Sun.shadow_vector(8.5, kemarau).x > 0.5, "morning: sun rises on the left of the HUD dial, shadow falls right")
	_check(Sun.shadow_vector(17.5, kemarau).x < -0.5, "afternoon: sun sets on the right, shadow falls left")
	_check(Sun.raw_vector(Sun.SOLAR_NOON, kemarau).length() < 0.4, "noon: short shadow (sun nearly overhead)")
	_check(Sun.shadow_vector(Sun.SOLAR_NOON, kemarau).y > 0.0, "Kemarau: sun in the north, shadows fall south (down)")
	_check(Sun.shadow_vector(Sun.SOLAR_NOON, tengkujuh).y < 0.0, "Tengkujuh: sun in the south, shadows fall north (up)")
	_check(Sun.shadow_vector(7.6, kemarau).length() <= Sun.MAX_LENGTH + 0.001, "low sun: shadow length is capped")
	_check(Sun.strength(12.0, kemarau) == 1.0, "full strength at midday")
	_check(Sun.strength(21.0, kemarau) == 0.0 and Sun.strength(6.2, kemarau) == 0.0, "no sun shadow at night or before sunrise")
	var asar := Sun.asar_minutes(kemarau)
	_check(asar > 15 * 60 and asar < 17 * 60, "Asar at %d:%02d (between 15:00 and 17:00)" % [asar / 60, asar % 60])
	var noon_len := Sun.length_ratio(Sun.SOLAR_NOON, kemarau)
	_check(absf(Sun.length_ratio(asar / 60.0, kemarau) - (noon_len + 1.0)) < 0.03, "at Asar the shadow is one body length past its noon length")

	var gs = root.get_node("GameState")
	var SS = load("res://scripts/world/sun_shadows.gd")
	gs.minutes = 9 * 60
	gs.set_weather("cerah")
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	var z = current_scene
	var ss = z.sun_shadows
	_check(ss.caster_count() >= 20, "kampung: houses, trees, rocks and the player cast shadows (%d)" % ss.caster_count())
	var player_sh: Sprite2D = ss._casters[ss.caster_count() - 1][2]
	var pivot: Node2D = ss._casters[ss.caster_count() - 1][1]
	var ps: Sprite2D = z.player.sprite
	_check(player_sh.texture == ps.texture and player_sh.region_rect.position == Vector2(SS._cell(ps).position), "player shadow copies the player's sprite and current frame")
	var foot: Vector2 = SS.foot_point(z.player.sprite)
	var feet: Vector2 = z.player.sprite.global_position + foot
	_check(absf(foot.x) < 6.0 and pivot.position.distance_to(feet.round()) < 0.5 and player_sh.position == -foot, "player shadow hinges on the player's feet (%s)" % foot)
	var palm: Sprite2D = null
	for c in ss._casters:
		if c[0].has_meta("tree_kind") and c[0].get_meta("tree_kind") == "palm":
			palm = c[0]
			break
	var palm_foot: Vector2 = SS.foot_point(palm)
	var tex_img: Image = palm.texture.get_image()
	var px := int(palm_foot.x - palm.get_rect().position.x)
	var py := int(palm_foot.y - palm.get_rect().position.y) - 1
	_check(tex_img.get_pixel(clampi(px, 0, tex_img.get_width() - 1), clampi(py, 0, tex_img.get_height() - 1)).a > 0.5, "palm shadow hinges on the trunk base pixel (%s)" % palm_foot)
	_check(pivot.visible and pivot.transform.y.x < 0.0, "9:00: player shadow is on and points right (y axis leans left, so height maps right)")

	_check(ss.box_count() == 4, "kampung: every house has a box shadow")
	var fp := PackedVector2Array([Vector2(0, 0), Vector2(100, -50), Vector2(30, -80), Vector2(-70, -30)])
	var noon_poly: PackedVector2Array = SS.box_polygon(fp, 120.0, 12.0, Sun.shadow_vector(Sun.SOLAR_NOON, kemarau))
	_check(Geometry2D.is_point_in_polygon(Vector2(15, -40), noon_poly), "noon: house shadow lies under the house")
	var morning_poly: PackedVector2Array = SS.box_polygon(fp, 120.0, 12.0, Sun.shadow_vector(8.5, kemarau))
	var max_x := -INF
	for p in morning_poly:
		max_x = maxf(max_x, p.x)
	max_x -= 100.0
	_check(max_x > 40.0 and max_x < 120.0, "8:30: house shadow reaches %.0f px right of the house (short, not across the screen)" % max_x)

	# Night near a pelita: the shadow points away from the lamp.
	gs.minutes = 21 * 60
	var lamp: Vector2 = ss._lamps[0]
	z.player.global_position = lamp + Vector2(80, 30)
	await process_frame
	_check(pivot.visible and pivot.transform.y.x < 0.0, "night: player shadow falls away from the pelita (east of it -> points east)")
	z.player.global_position = lamp + Vector2(0, 900)
	await process_frame
	_check(not pivot.visible, "night, far from lamps: no cast shadow")
	await process_frame   # the player was teleported off the map; let physics settle it
	await process_frame
	var foot_oval: Polygon2D = ss._casters[ss.caster_count() - 1][3]
	_check(foot_oval != null and foot_oval.visible and foot_oval.color.a > 0.3 and foot_oval.position == z.player.sprite.global_position.round(), "night: the player keeps a foot shadow under the feet (%s a=%.2f at %s vs %s)" % [foot_oval != null, foot_oval.color.a if foot_oval else 0.0, foot_oval.position if foot_oval else Vector2.ZERO, z.player.sprite.global_position])

	# Asar notice once per day.
	SS.asar_day = -1
	var count := [0]
	ss.asar_started.connect(func(): count[0] += 1)
	gs.minutes = asar + 1
	await process_frame
	await process_frame
	_check(count[0] == 1, "Asar notice fires once when the time comes")
	_check(SS.asar_message().contains("Asar"), "Asar message: %s" % SS.asar_message())

	change_scene_to_file("res://scenes/world/mangrove.tscn")
	for i in 4:
		await process_frame
	_check(current_scene.sun_shadows.caster_count() > 5, "swamp props, altar and player cast shadows")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
