class_name NavGrid
extends RefCounted
## Walkable grid for click-to-move: A* over half-tile cells (24 px) of a zone. A cell is solid
## when a box the size of the player's feet at its centre touches any collision (houses, trees,
## water, the dummy, the map edges). Built once per zone, the first time it is needed.

const CELL := 24.0
const PROBE := Vector2(14, 10)   ## a bit bigger than the player's feet (12 x 8)

var astar := AStarGrid2D.new()
var bounds := Rect2i()


## Probe the physics world over `area` (world px). `exclude` = RIDs to ignore (the player).
func build(world: World2D, area: Rect2, mask: int, exclude: Array[RID]) -> void:
	bounds = Rect2i(0, 0, ceili(area.size.x / CELL), ceili(area.size.y / CELL))
	astar.region = bounds
	astar.cell_size = Vector2(CELL, CELL)
	astar.offset = area.position + Vector2(CELL, CELL) / 2.0   # ids map to cell centres
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar.update()
	var space := world.direct_space_state
	var q := PhysicsShapeQueryParameters2D.new()
	var box := RectangleShape2D.new()
	box.size = PROBE
	q.shape = box
	q.collision_mask = mask
	q.exclude = exclude
	for y in bounds.size.y:
		for x in bounds.size.x:
			q.transform = Transform2D(0.0, centre(Vector2i(x, y)))
			if not space.intersect_shape(q, 1).is_empty():
				astar.set_point_solid(Vector2i(x, y))


func centre(c: Vector2i) -> Vector2:
	return astar.offset + Vector2(c) * CELL


func cell_of(p: Vector2) -> Vector2i:
	return Vector2i(((p - astar.offset) / CELL).round())


func is_walkable(c: Vector2i) -> bool:
	return bounds.has_point(c) and not astar.is_point_solid(c)


## The walkable cell nearest to `c` (itself if walkable), searching outward a few rings.
func nearest_walkable(c: Vector2i, rings := 4) -> Vector2i:
	if is_walkable(c):
		return c
	for r in range(1, rings + 1):
		var best := Vector2i(-1, -1)
		var best_d := INF
		for dy in range(-r, r + 1):
			for dx in range(-r, r + 1):
				if maxi(absi(dx), absi(dy)) != r:
					continue
				var n := c + Vector2i(dx, dy)
				var d := Vector2(dx, dy).length()
				if is_walkable(n) and d < best_d:
					best_d = d
					best = n
		if best_d < INF:
			return best
	return Vector2i(-1, -1)


## World-space waypoints from `from` to `to` (the last one is `to` itself when it is walkable).
## Empty when there is no way there.
func find_path(from: Vector2, to: Vector2) -> PackedVector2Array:
	var a := nearest_walkable(cell_of(from), 2)
	var b := nearest_walkable(cell_of(to))
	if a.x < 0 or b.x < 0:
		return PackedVector2Array()
	var ids := astar.get_id_path(a, b)
	if ids.is_empty():
		return PackedVector2Array()
	var pts := PackedVector2Array()
	for i in range(1, ids.size()):   # skip the cell we stand in
		pts.append(centre(ids[i]))
	if b == cell_of(to):
		if pts.is_empty():
			pts.append(to)
		else:
			pts[pts.size() - 1] = to
	return _smooth(from, pts)


## Drop waypoints we can walk straight past (no solid cell on the straight line), so the walk
## isn't zig-zag along the grid.
func _smooth(from: Vector2, pts: PackedVector2Array) -> PackedVector2Array:
	if pts.size() < 2:
		return pts
	var out := PackedVector2Array()
	var cur := from
	var i := 0
	while i < pts.size():
		var j := pts.size() - 1
		while j > i and not _clear(cur, pts[j]):
			j -= 1
		out.append(pts[j])
		cur = pts[j]
		i = j + 1
	return out


func _clear(a: Vector2, b: Vector2) -> bool:
	var steps := ceili(a.distance_to(b) / (CELL / 3.0))
	for k in range(1, steps + 1):
		var p := a.lerp(b, float(k) / steps)
		# The feet are wider than a line: check the cells under both sides of the probe too.
		for off in [Vector2.ZERO, Vector2(PROBE.x / 2, PROBE.y / 2), Vector2(-PROBE.x / 2, PROBE.y / 2),
				Vector2(PROBE.x / 2, -PROBE.y / 2), Vector2(-PROBE.x / 2, -PROBE.y / 2)]:
			if not is_walkable(cell_of(p + off)):
				return false
	return true
