extends Camera2D

## Smooth follow camera with screen shake and velocity look-ahead.

var _target_path: NodePath
@export var target: NodePath setget set_target
@export var smooth_speed: float = 4.0
@export var look_ahead: float = 0.12
@export var shake_decay: float = 6.0

var _target_node: Node2D = null
var _shake_strength: float = 0.0


func set_target(path: NodePath) -> void:
	# Backing value + immediate resolve if in tree
	_target_path = path
	if is_inside_tree() and _target_path:
		_target_node = get_node_or_null(_target_path)
		if _target_node and _target_node.has_signal("impact_occurred"):
			if not _target_node.is_connected("impact_occurred", self, "_on_impact"):
				_target_node.impact_occurred.connect(_on_impact)


func _ready() -> void:
	# Resolve any pre-set target path
	if _target_path:
		_target_node = get_node_or_null(_target_path)
		if _target_node and _target_node.has_signal("impact_occurred"):
			if not _target_node.is_connected("impact_occurred", self, "_on_impact"):
				_target_node.impact_occurred.connect(_on_impact)


func _process(delta: float) -> void:
	# Lazy-resolve target if it was assigned after ready
	if not _target_node and _target_path:
		_target_node = get_node_or_null(_target_path)
		if _target_node and _target_node.has_signal("impact_occurred"):
			if not _target_node.is_connected("impact_occurred", self, "_on_impact"):
				_target_node.impact_occurred.connect(_on_impact)

	if not _target_node:
		return
	# Target position with velocity look-ahead
	var dest := _target_node.global_position
	if _target_node is RigidBody2D:
		dest += _target_node.linear_velocity * look_ahead

	global_position = global_position.lerp(dest, smooth_speed * delta)

	# Screen shake
	if _shake_strength > 0.01:
		_shake_strength = move_toward(_shake_strength, 0.0, shake_decay * delta)
		offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * _shake_strength
	else:
		offset = offset.lerp(Vector2.ZERO, 10.0 * delta)


func _on_impact(speed: float) -> void:
	_shake_strength = clampf(speed * 0.012, 1.0, 10.0)
