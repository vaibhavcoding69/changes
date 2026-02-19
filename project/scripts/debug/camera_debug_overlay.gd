extends Node2D

# Runtime debug overlay that visualizes a Camera2D's configured limits
# and the camera's target position. Attach dynamically from level template
# (only created when debug is desired).

@export var camera_path: NodePath
@export var color: Color = Color(0.9, 0.2, 0.2, 0.25)
@export var border_color: Color = Color(0.9, 0.2, 0.2, 0.85)

func _process(_delta: float) -> void:
	update()

func _draw() -> void:
	var cam = get_node_or_null(camera_path) as Node
	if not cam:
		return
	var limits: Rect2 = cam.get("limits_rect") if cam.has_method("get") else Rect2()
	if limits.size != Vector2.ZERO:
		# draw filled rect in world-space (overlay is at root — assume same coordinate space)
		draw_rect(limits, color)
		draw_rect(limits, Color(border_color.r, border_color.g, border_color.b, 0.6), false)

	# draw target position marker
	var tnode = cam.get("_target_node") if cam.has_method("get") else null
	if tnode:
		if tnode is Node2D:
			draw_circle(tnode.global_position, 6, border_color)
			draw_line(tnode.global_position, cam.global_position, border_color, 1.2)
