extends Camera2D

## Enhanced Camera2D — lazy target resolution, optional world limits,
## look-ahead, screen shake and lightweight runtime debug support.

@export var target: NodePath : set = set_target
@export var smooth_speed: float = 4.0
@export var look_ahead: float = 0.12
@export var shake_decay: float = 6.0

@export var clamp_to_limits: bool = false
@export var limits_rect: Rect2 = Rect2(-600, -400, 1200, 800)

@export var deadzone: Vector2 = Vector2.ZERO
@export var debug_draw: bool = false

var _target_node: Node2D = null
var _shake_strength: float = 0.0


func set_target(path: NodePath) -> void:
	# Resolve immediately if possible, otherwise lazy-resolve in _process
	_target_node = get_node_or_null(path)
	if _target_node and _target_node.has_signal("impact_occurred"):
		var impact_callable := Callable(self, "_on_impact")
		if not _target_node.is_connected("impact_occurred", impact_callable):
			_target_node.impact_occurred.connect(impact_callable)


func set_limits(rect: Rect2) -> void:
	limits_rect = rect
	clamp_to_limits = rect.size != Vector2.ZERO


func _ready() -> void:
	# If `target` was set in the editor, try to resolve it now
	if target:
		_target_node = get_node_or_null(target)
		if _target_node and _target_node.has_signal("impact_occurred"):
			var impact_callable := Callable(self, "_on_impact")
			if not _target_node.is_connected("impact_occurred", impact_callable):
				_target_node.impact_occurred.connect(impact_callable)


func _process(delta: float) -> void:
	# Lazy-resolve target assigned at runtime
	if not _target_node and target:
		_target_node = get_node_or_null(target)
		if _target_node and _target_node.has_signal("impact_occurred"):
			var impact_callable := Callable(self, "_on_impact")
			if not _target_node.is_connected("impact_occurred", impact_callable):
				_target_node.impact_occurred.connect(impact_callable)

	# Destination with optional look-ahead and deadzone handling
	var dest: Vector2 = _target_node.global_position
	if _target_node is RigidBody2D:
		dest += _target_node.linear_velocity * look_ahead

	# Clamp destination to world limits (takes viewport half-size into account)
	if clamp_to_limits and limits_rect.size != Vector2.ZERO:
		var vp_size := get_viewport().get_visible_rect().size * 0.5 * zoom
		var min_pos := limits_rect.position + vp_size
		var max_pos := limits_rect.position + limits_rect.size - vp_size
		dest.x = clamp(dest.x, min_pos.x, max_pos.x)
		dest.y = clamp(dest.y, min_pos.y, max_pos.y)

	global_position = global_position.lerp(dest, smooth_speed * delta)

	# Screen shake
	if _shake_strength > 0.01:
		_shake_strength = move_toward(_shake_strength, 0.0, shake_decay * delta)
		offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * _shake_strength
	else:
		offset = offset.lerp(Vector2.ZERO, 10.0 * delta)

	# Debug: optionally draw limits info to the editor/output
	if debug_draw and Engine.is_editor_hint() == false:
		# lightweight runtime debug info
		print_verbose("[Camera] pos=", global_position, " limits=", limits_rect)


func _on_impact(speed: float) -> void:
	_shake_strength = clampf(speed * 0.012, 1.0, 10.0)
