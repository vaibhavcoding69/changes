extends Area2D

## Gravity Zone - Alters gravity for bodies within the area
## Used in Space world levels for low gravity and orbital mechanics

@export_group("Gravity Properties")
@export var gravity_scale: float = 0.3  # Multiplier for normal gravity
@export var gravity_direction: Vector2 = Vector2.DOWN
@export var use_radial_gravity: bool = false  # Pull toward center
@export var radial_strength: float = 200.0
@export var damping: float = 0.98  # Velocity damping in zone

@export_group("Visual Settings")
@export var zone_color: Color = Color(0.4, 0.2, 0.8, 0.2)
@export var star_count: int = 30
@export var show_gravity_field: bool = true

# --- Internal State ---
var _affected_bodies: Array[RigidBody2D] = []
var _time: float = 0.0
var _stars: Array[Dictionary] = []
var _original_gravity: float = 980.0

signal body_entered_zone(body: Node2D)
signal body_exited_zone(body: Node2D)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_original_gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980.0)
	_initialize_stars()
	
	collision_layer = 0
	collision_mask = 2


func _physics_process(delta: float) -> void:
	_time += delta
	
	for body in _affected_bodies:
		if is_instance_valid(body):
			_apply_gravity_physics(body, delta)
	
	_update_stars(delta)
	queue_redraw()


func _apply_gravity_physics(body: RigidBody2D, delta: float) -> void:
	# Apply damping
	body.linear_velocity *= damping
	
	if use_radial_gravity:
		# Pull toward center of zone
		var to_center := global_position - body.global_position
		var distance := to_center.length()
		if distance > 10:
			var force := to_center.normalized() * radial_strength
			# Inverse square falloff (clamped)
			force *= clampf(100.0 / distance, 0.1, 2.0)
			body.apply_central_force(force)
	else:
		# Apply modified linear gravity
		var modified_gravity := _original_gravity * gravity_scale
		var gravity_force := gravity_direction.normalized() * modified_gravity * body.mass
		# Counteract normal gravity and apply modified
		var counter_force := Vector2.UP * _original_gravity * body.mass
		body.apply_central_force(counter_force + gravity_force)


func _initialize_stars() -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape:
		return
	
	var size := Vector2(300, 300)
	if shape.shape is RectangleShape2D:
		size = shape.shape.size
	elif shape.shape is CircleShape2D:
		var radius: float = shape.shape.radius
		size = Vector2(radius * 2, radius * 2)
	
	for i in range(star_count):
		_stars.append({
			"position": Vector2(
				randf_range(-size.x / 2, size.x / 2),
				randf_range(-size.y / 2, size.y / 2)
			),
			"size": randf_range(1, 3),
			"brightness": randf_range(0.3, 1.0),
			"twinkle_speed": randf_range(2, 6),
			"twinkle_phase": randf() * TAU,
		})


func _update_stars(delta: float) -> void:
	# Stars slowly drift
	for star in _stars:
		star["twinkle_phase"] += delta * star["twinkle_speed"]


func _draw() -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape:
		return
	
	# Draw zone background
	if shape.shape is RectangleShape2D:
		var rect_size: Vector2 = shape.shape.size
		var rect := Rect2(-rect_size / 2, rect_size)
		draw_rect(rect, zone_color)
		draw_rect(rect, Color(0.5, 0.3, 0.9, 0.3), false, 2.0)
	elif shape.shape is CircleShape2D:
		var radius: float = shape.shape.radius
		draw_circle(Vector2.ZERO, radius, zone_color)
		_draw_ring(radius, Color(0.5, 0.3, 0.9, 0.3), 2.0)
	
	# Draw stars
	_draw_stars()
	
	# Draw gravity field indicators
	if show_gravity_field:
		_draw_gravity_field()
	
	# Draw radial gravity center
	if use_radial_gravity:
		_draw_gravity_center()


func _draw_stars() -> void:
	for star in _stars:
		var twinkle := (sin(star["twinkle_phase"]) + 1.0) * 0.5
		var brightness: float = star["brightness"] * (0.5 + twinkle * 0.5)
		var size: float = star["size"] * (0.8 + twinkle * 0.4)
		
		var star_color := Color(1, 1, 1, brightness)
		draw_circle(star["position"], size, star_color)
		
		# Star glow
		draw_circle(star["position"], size * 2, Color(1, 1, 1, brightness * 0.2))


func _draw_gravity_field() -> void:
	if use_radial_gravity:
		# Draw concentric circles
		for i in range(4):
			var radius := 40.0 + i * 40.0 + sin(_time * 2 + i) * 5
			var alpha := 0.15 - i * 0.03
			_draw_ring(radius, Color(0.6, 0.4, 1.0, alpha), 1.5)
	else:
		# Draw gravity direction arrows
		var arrow_count := 5
		var spacing := 60.0
		
		for i in range(arrow_count):
			var offset := fmod(_time * 30 + i * spacing, spacing * arrow_count) - spacing * arrow_count / 2
			var arrow_pos := gravity_direction.normalized() * offset
			
			# Arrow
			var arrow_length := 30.0
			var end_pos := arrow_pos + gravity_direction.normalized() * arrow_length
			var alpha := 0.3 - abs(offset) / (spacing * arrow_count) * 0.2
			
			draw_line(arrow_pos, end_pos, Color(0.6, 0.4, 1.0, alpha), 2.0)
			
			# Arrow head
			var angle := gravity_direction.angle()
			var head1 := end_pos + Vector2(cos(angle + PI * 0.8), sin(angle + PI * 0.8)) * 8
			var head2 := end_pos + Vector2(cos(angle - PI * 0.8), sin(angle - PI * 0.8)) * 8
			draw_line(end_pos, head1, Color(0.6, 0.4, 1.0, alpha), 2.0)
			draw_line(end_pos, head2, Color(0.6, 0.4, 1.0, alpha), 2.0)


func _draw_gravity_center() -> void:
	# Pulsing center orb
	var pulse := (sin(_time * 3) + 1.0) * 0.5
	var core_radius := 10.0 + pulse * 5.0
	
	# Outer glow
	for i in range(4):
		var r := core_radius + i * 8
		var alpha := 0.3 - i * 0.07
		draw_circle(Vector2.ZERO, r, Color(0.8, 0.5, 1.0, alpha))
	
	# Core
	draw_circle(Vector2.ZERO, core_radius, Color(0.9, 0.7, 1.0, 0.8))
	draw_circle(Vector2.ZERO, core_radius * 0.5, Color(1, 1, 1, 0.6))


func _draw_ring(radius: float, color: Color, width: float) -> void:
	var segments := 32
	for i in range(segments):
		var a1 := float(i) / segments * TAU
		var a2 := float(i + 1) / segments * TAU
		draw_line(
			Vector2(cos(a1), sin(a1)) * radius,
			Vector2(cos(a2), sin(a2)) * radius,
			color, width
		)


func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		_affected_bodies.append(body)
		body_entered_zone.emit(body)
		
		# Play space warp sound
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("space_warp")


func _on_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		_affected_bodies.erase(body)
		body_exited_zone.emit(body)


# --- Public API ---

func set_gravity_scale(scale: float) -> void:
	gravity_scale = scale


func set_radial_gravity(enabled: bool, strength: float = 200.0) -> void:
	use_radial_gravity = enabled
	radial_strength = strength


func invert_gravity() -> void:
	gravity_direction = -gravity_direction
