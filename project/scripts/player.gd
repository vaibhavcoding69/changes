extends RigidBody2D

## Pull-and-shoot ball controller.
## Click near the ball, drag to aim, release to launch.

@export var max_power: float = 1000.0
@export var drag_radius: float = 100.0

@onready var trajectory_line: Line2D = $TrajectoryLine
@onready var sprite: Sprite2D = $Sprite2D

var is_dragging: bool = false
var drag_start: Vector2 = Vector2.ZERO
var drag_current: Vector2 = Vector2.ZERO

# Minimum velocity to consider the ball "stopped"
const REST_THRESHOLD: float = 15.0


func _ready() -> void:
	trajectory_line.visible = false
	# Set physics material
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = 0.6
	physics_material_override.friction = 0.3
	continuous_cd = RigidBody2D.CCD_MODE_CAST_RAY


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_on_mouse_pressed(event.global_position)
			else:
				_on_mouse_released()
	
	elif event is InputEventMouseMotion and is_dragging:
		drag_current = event.global_position
		_update_trajectory()


func _on_mouse_pressed(mouse_pos: Vector2) -> void:
	# Only start drag if clicking near the ball
	if global_position.distance_to(mouse_pos) <= drag_radius and _is_ball_resting():
		is_dragging = true
		drag_start = mouse_pos
		drag_current = mouse_pos
		freeze = true
		trajectory_line.visible = true


func _on_mouse_released() -> void:
	if not is_dragging:
		return
	
	is_dragging = false
	freeze = false
	trajectory_line.visible = false
	
	# Calculate launch direction and power
	var drag_vector: Vector2 = drag_start - drag_current
	var power: float = clampf(drag_vector.length(), 0.0, max_power)
	var direction: Vector2 = drag_vector.normalized()
	
	apply_central_impulse(direction * power)


func _update_trajectory() -> void:
	if not is_dragging:
		return
	
	var drag_vector: Vector2 = drag_start - drag_current
	var power: float = clampf(drag_vector.length(), 0.0, max_power)
	var direction: Vector2 = drag_vector.normalized()
	
	# Draw a dashed trajectory preview
	var points: PackedVector2Array = PackedVector2Array()
	var num_points: int = 20
	var step_length: float = power / max_power * 15.0  # Scale line length with power
	
	for i in range(num_points):
		var t: float = float(i) / float(num_points)
		# Only show every other segment for dashed effect
		points.append(direction * step_length * i * 5.0)
	
	trajectory_line.points = points


func _is_ball_resting() -> bool:
	return linear_velocity.length() < REST_THRESHOLD or freeze
