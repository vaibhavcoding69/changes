extends Control

# Small on-screen debug UI that shows camera stats (position, zoom, target)
# Add to the scene root when you need quick runtime info.

@export var camera_path: NodePath

func _ready() -> void:
	set_process(true)
	anchor_right = 1.0
	anchor_bottom = 1.0
	margin_right = -16
	margin_bottom = -16
	rect_min_size = Vector2(220, 86)

func _process(_delta: float) -> void:
	var cam = get_node_or_null(camera_path) as Node
	if not cam:
		visible = false
		return
	visible = true
	var pos = cam.global_position
	var z = cam.zoom if cam.has_method("get") else cam.zoom
	var txt := "Camera: (%.1f, %.1f)\nZoom: %.2f\nTarget: %s" % [pos.x, pos.y, z.x, str(cam.get("_target_node"))]
	get_tree().root.call_deferred("set_window_title", txt)