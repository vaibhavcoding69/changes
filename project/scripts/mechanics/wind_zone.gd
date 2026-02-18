extends Area2D

## Wind Zone - Applies directional force to bodies within the area
## Used in Sky world levels

@export_group("Wind Properties")
@export var wind_direction: Vector2 = Vector2.RIGHT
@export var wind_strength: float = 400.0
@export var wind_variation: float = 50.0
@export var gust_interval: float = 3.0
@export var gust_duration: float = 0.5
@export var gust_multiplier: float = 2.0

@export_group("Visual Settings")
@export var particle_color: Color = Color(0.8, 0.9, 1.0, 0.3)
@export var show_wind_lines: bool = true
@export var wind_line_count: int = 8

# --- Internal State ---
var _affected_bodies: Array[RigidBody2D] = []
var _time: float = 0.0
var _gust_timer: float = 0.0
var _is_gusting: bool = false
var _current_strength: float = 0.0
var _wind_lines: Array[Dictionary] = []

signal body_entered_wind(body: Node2D)
signal body_exited_wind(body: Node2D)
signal gust_started
signal gust_ended


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_current_strength = wind_strength
	_initialize_wind_lines()
	
	# Set up collision
	collision_layer = 0
	collision_mask = 2  # Detect layer 2 (ball)


func _physics_process(delta: float) -> void:
	_time += delta
	_gust_timer += delta
	
	# Handle gusting
	if _gust_timer >= gust_interval:
		_start_gust()
		_gust_timer = 0.0
	
	if _is_gusting:
		_current_strength = wind_strength * gust_multiplier
		if _gust_timer >= gust_duration and _is_gusting:
			_end_gust()
	else:
		_current_strength = wind_strength + randf_range(-wind_variation, wind_variation)
	
	# Apply wind force to all affected bodies
	for body in _affected_bodies:
		if is_instance_valid(body):
			var force := wind_direction.normalized() * _current_strength
			body.apply_central_force(force)
	
	# Update wind lines
	_update_wind_lines(delta)
	queue_redraw()


func _start_gust() -> void:
	_is_gusting = true
	gust_started.emit()
	
	# Play wind sound if audio manager exists
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("wind_gust")


func _end_gust() -> void:
	_is_gusting = false
	gust_ended.emit()


func _initialize_wind_lines() -> void:
	if not show_wind_lines:
		return
	
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape:
		return
	
	var rect_size := Vector2(200, 200)  # Default
	if shape.shape is RectangleShape2D:
		rect_size = shape.shape.size
	
	for i in range(wind_line_count):
		_wind_lines.append({
			"position": Vector2(
				randf_range(-rect_size.x / 2, rect_size.x / 2),
				randf_range(-rect_size.y / 2, rect_size.y / 2)
			),
			"length": randf_range(20, 60),
			"speed": randf_range(0.8, 1.2),
			"alpha": randf_range(0.2, 0.5),
		})


func _update_wind_lines(delta: float) -> void:
	for line in _wind_lines:
		line["position"] += wind_direction.normalized() * 100 * line["speed"] * delta
		
		# Wrap around
		var shape := get_node_or_null("CollisionShape2D")
		if shape and shape.shape is RectangleShape2D:
			var rect_size: Vector2 = shape.shape.size
			if line["position"].x > rect_size.x / 2:
				line["position"].x = -rect_size.x / 2
			elif line["position"].x < -rect_size.x / 2:
				line["position"].x = rect_size.x / 2
			if line["position"].y > rect_size.y / 2:
				line["position"].y = -rect_size.y / 2
			elif line["position"].y < -rect_size.y / 2:
				line["position"].y = rect_size.y / 2


func _draw() -> void:
	# Draw zone background
	var shape := get_node_or_null("CollisionShape2D")
	if shape and shape.shape is RectangleShape2D:
		var rect_size: Vector2 = shape.shape.size
		var rect := Rect2(-rect_size / 2, rect_size)
		
		# Zone fill
		var fill_color := Color(0.7, 0.85, 1.0, 0.08)
		if _is_gusting:
			fill_color.a = 0.15
		draw_rect(rect, fill_color)
		
		# Zone border
		draw_rect(rect, Color(0.7, 0.85, 1.0, 0.2), false, 2.0)
	
	# Draw wind lines
	if show_wind_lines:
		for line in _wind_lines:
			var start: Vector2 = line["position"]
			var end: Vector2 = start + wind_direction.normalized() * line["length"]
			var alpha: float = line["alpha"]
			if _is_gusting:
				alpha *= 1.5
			draw_line(start, end, Color(1, 1, 1, alpha), 1.5)
	
	# Draw direction arrow
	_draw_wind_arrow()


func _draw_wind_arrow() -> void:
	var center := Vector2.ZERO
	var arrow_length := 40.0
	var arrow_end := center + wind_direction.normalized() * arrow_length
	
	# Arrow shaft
	draw_line(center, arrow_end, Color(1, 1, 1, 0.3), 2.0)
	
	# Arrow head
	var head_size := 10.0
	var angle := wind_direction.angle()
	var head_left := arrow_end + Vector2(cos(angle + PI * 0.8), sin(angle + PI * 0.8)) * head_size
	var head_right := arrow_end + Vector2(cos(angle - PI * 0.8), sin(angle - PI * 0.8)) * head_size
	draw_line(arrow_end, head_left, Color(1, 1, 1, 0.3), 2.0)
	draw_line(arrow_end, head_right, Color(1, 1, 1, 0.3), 2.0)


func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		_affected_bodies.append(body)
		body_entered_wind.emit(body)


func _on_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		_affected_bodies.erase(body)
		body_exited_wind.emit(body)


# --- Public API ---

func set_wind_direction(direction: Vector2) -> void:
	wind_direction = direction.normalized()


func set_wind_strength(strength: float) -> void:
	wind_strength = strength


func trigger_gust() -> void:
	_start_gust()
	_gust_timer = 0.0
