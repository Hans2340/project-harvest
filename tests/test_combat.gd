extends SceneTree
## Headless test for the silat combo and the training dummy. Anim ids: 0 idle, 3 jab, 4 cross, 5 kick.
## Run: godot --headless --path . -s tests/test_combat.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	var z = current_scene
	var p = z.player
	var d = z.dummy
	_check(d.is_in_group("hittable"), "the dummy is in the kampung and hittable")

	# Stand left of the dummy, facing it.
	p.global_position = d.global_position + Vector2(-30, 0)
	p._update_facing(Vector2.RIGHT)
	var log := []
	p.struck.connect(func(step, hit): log.append([step, hit]))

	# One press: a single jab, then back to idle.
	p.attack()
	_check(p.is_attacking() and p._anim == 3, "attack starts the jab")
	await _until(func(): return not p.is_attacking(), 90)
	_check(log == [[0, true]], "a single press is one jab that lands (%s)" % [log])
	_check(d.hits == 1 and d.total_damage == 1, "the dummy took the jab")

	# Mash attack: jab, cross, kick.
	log.clear()
	p.global_position = d.global_position + Vector2(-30, 0)
	var anims := {}
	p.attack()
	for i in 150:
		if i % 6 == 0:
			p.attack()
		anims[p._anim] = true
		await physics_frame
		if not p.is_attacking():
			break
	_check(anims.has(3) and anims.has(4) and anims.has(5),
		"mashing plays jab, cross and kick")
	_check(log.size() == 3 and log.all(func(e): return e[1]), "all three strikes land (%s)" % [log])
	_check(d.total_damage == 1 + 1 + 1 + 2, "combo damage 1 + 1 + 2 (total %d)" % d.total_damage)
	_check(not p.is_attacking() and p._anim == 0, "the combo ends after the kick")

	# Auto-target: the dummy is to the right, we face left and stand two tiles away.
	log.clear()
	var start: Vector2 = d.global_position + Vector2(-90, 0)
	p.global_position = start
	p._update_facing(Vector2.LEFT)
	p.attack()
	await _until(func(): return not p.is_attacking(), 90)
	_check(log == [[0, true]], "facing away, the jab turns to the dummy and lands (%s)" % [log])
	_check(p.facing == Vector2.RIGHT, "now facing the dummy")
	_check(p.global_position.x > start.x + 40, "stepped in toward it (%.0f px)" % (p.global_position.x - start.x))

	# Off the axis: below-right of the dummy. Lines up and lands.
	log.clear()
	p.global_position = d.global_position + Vector2(70, 50)
	p._update_facing(Vector2.DOWN)
	p.attack()
	await _until(func(): return not p.is_attacking(), 90)
	_check(log == [[0, true]], "a target off the axis: steps in, lines up and lands (%s)" % [log])

	# Out of range: no turning, no stepping, the jab goes the way we face and misses.
	log.clear()
	start = d.global_position + Vector2(-200, 0)
	p.global_position = start
	p._update_facing(Vector2.LEFT)
	p.attack()
	await _until(func(): return not p.is_attacking(), 90)
	_check(log == [[0, false]] and p.facing == Vector2.LEFT, "out of range: the jab goes where we face and misses")
	_check(p.global_position.distance_to(start) < 20, "out of range: only the small lunge")

	# No attacking while the player is frozen (inventory open, sleeping...).
	p.can_move = false
	p.attack()
	_check(not p.is_attacking(), "no attack while the player can't move")
	p.can_move = true

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _until(cond: Callable, max_frames: int) -> void:
	for i in max_frames:
		if cond.call():
			return
		await physics_frame


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
