extends Node

# Small helper utilities for camera/level bounds used by Level/Camera systems.
# Keep these simple and safe (no TileMap-specific API calls). Use to compute
# a world-space bounding rectangle from a level node's children.

func compute_children_aabb(root: Node2D, margin: Vector2 = Vector2.ZERO) -> Rect2:
	var first := true
	var aabb := Rect2()
	for c in root.get_children():
		if c is Node2D:
			var p: Vector2 = c.global_position
			if first:
				aabb.position = p
				aabb.size = Vector2.ZERO
				first = false
			else:
				var min_x = min(aabb.position.x, p.x)
				var min_y = min(aabb.position.y, p.y)
				var max_x = max(aabb.position.x + aabb.size.x, p.x)
				var max_y = max(aabb.position.y + aabb.size.y, p.y)
				aabb.position = Vector2(min_x, min_y)
				aabb.size = Vector2(max_x - min_x, max_y - min_y)

	# apply margin
	aabb.position -= margin
	aabb.size += margin * 2.0
	return aabb


func rect_union(a: Rect2, b: Rect2) -> Rect2:
	if a.size == Vector2.ZERO:
		return b
	if b.size == Vector2.ZERO:
		return a
	var min_x = min(a.position.x, b.position.x)
	var min_y = min(a.position.y, b.position.y)
	var max_x = max(a.position.x + a.size.x, b.position.x + b.size.x)
	var max_y = max(a.position.y + a.size.y, b.position.y + b.size.y)
	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))
