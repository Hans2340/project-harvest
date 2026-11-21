extends SceneTree
## Headless test for the running feel: body lift on airborne frames and dust on footfalls.
## Run: godot --headless --path . -s tests/test_player_feel.gd

var ok := true


func _initialize() -> void:
	change_scene_to_file("res://scenes/world/kampung.tscn")
	for i in 4:
		await process_frame
	var z = current_scene
	var p = z.player
	var zone_parent: Node = p.get_parent()
	var spawned := [0]
	zone_parent.child_entered_tree.connect(func(n): if n is DustPuff: spawned[0] += 1)

	Input.action_press("move_right")
	Input.action_press("run")
	var lifted := false
	var grounded := false
	for i in 60:
		await physics_frame
		if p.sprite.offset.y < p.SPRITE_OFFSET.y:
			lifted = true
		else:
			grounded = true
	var running_puffs: int = spawned[0]
	_check(lifted and grounded, "running: the body lifts 1 px on airborne frames and lands again")
	_check(running_puffs >= 3, "running: dust on footfalls (%d puffs in 1 s)" % running_puffs)

	Input.action_release("run")
	var walk_lift := false
	for i in 30:
		await physics_frame
		walk_lift = walk_lift or p.sprite.offset.y != p.SPRITE_OFFSET.y
	_check(not walk_lift, "walking: no lift")
	Input.action_release("move_right")
	for i in 30:
		await process_frame
	_check(_puffs(zone_parent) == 0, "dust fades and frees itself")

	print("RESULT: ", "PASS" if ok else "FAIL")
	quit(0 if ok else 1)


func _puffs(n: Node) -> int:
	var c := 0
	for ch in n.get_children():
		if ch is DustPuff:
			c += 1
	return c


func _check(cond: bool, label: String) -> void:
	print(("  ok   " if cond else "  FAIL ") + label)
	ok = ok and cond
