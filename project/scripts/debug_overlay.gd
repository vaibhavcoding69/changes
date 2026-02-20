extends Node2D

## Visual Debug Overlay for Camera and World Boundaries
## Add this to your main scene or level to visualize alignment issues.

@export var camera_path: NodePath
@onready var camera: Camera2D = get_node_or_null(camera_path) if camera_path else null

func _ready() -> void:
	if not camera:
		# Try to find active camera
		var viewport = get_viewport()
		if viewport:
			camera = viewport.get_camera_2d()
	
	set_process(true)
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if not camera:
		return

	# Draw viewport rect in world implementation logic
	var vp_rect = get_viewport_rect()
	var cam_pos = camera.global_position
	# For Camera2D, the visible area is centered on position
	# unless limits interfere.
	# But we can get the actual visible rect from the canvas transform
	var canvas_transform = get_canvas_transform()
	var view_size = get_viewport_rect().size
	
	# Inverse transform to get world coordinates
	var tl = canvas_transform.affine_inverse() * Vector2.ZERO
	var tr = canvas_transform.affine_inverse() * Vector2(view_size.x, 0)
	var bl = canvas_transform.affine_inverse() * Vector2(0, view_size.y)
	var br = canvas_transform.affine_inverse() * view_size
	
	# Draw visible area outline
	var points = PackedVector2Array([tl, tr, br, bl, tl])
	draw_polyline(points, Color.CYAN, 4.0)
	
	# Draw level bounds if known (hardcoded 1200x800 for now)
	var level_rect = Rect2(0, 0, 1200, 800)
	draw_rect(level_rect, Color.MAGENTA, false, 4.0)
	
	# Draw safe margin markers
	draw_line(Vector2(0, 0), Vector2(100, 100), Color.RED, 2.0)
	draw_line(Vector2(1200, 800), Vector2(1100, 700), Color.RED, 2.0)
	
	# Check if camera center is aligned
	var center = (tl + br) * 0.5
	draw_circle(center, 10, Color.YELLOW)
	draw_line(center - Vector2(20, 0), center + Vector2(20, 0), Color.YELLOW, 2.0)
	draw_line(center - Vector2(0, 20), center + Vector2(0, 20), Color.YELLOW, 2.0)
	
	# Display info
	var font = ThemeDB.fallback_font
	var font_size = ThemeDB.fallback_font_size
	draw_string(font, tl + Vector2(10, 30), "Cam Pos: " + str(camera.global_position), HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.WHITE)
	draw_string(font, tl + Vector2(10, 60), "View Rect: " + str(Rect2(tl, br-tl)), HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.WHITE)

