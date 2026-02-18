extends Area2D

## Water Current Zone - Applies water physics and directional current
## Used in Ocean world levels

@export_group("Water Properties")
@export var current_direction: Vector2 = Vector2.RIGHT
@export var current_strength: float = 200.0
@export var buoyancy_force: float = 300.0
@export var water_drag: float = 0.92  # Multiplier for velocity (higher = less drag)
@export var surface_y_offset: float = 0.0  # Offset from top of zone

@export_group("Visual Settings")
@export var water_color: Color = Color(0.2, 0.5, 0.8, 0.4)
@export var surface_color: Color = Color(0.4, 0.7, 1.0, 0.6)
@export var bubble_count: int = 15
@export var wave_amplitude: float = 5.0
@export var wave_frequency: float = 2.0

# --- Internal State ---
var _affected_bodies: Array[RigidBody2D] = []
var _time: float = 0.0
var _bubbles: Array[Dictionary] = []
var _caustic_points: Array[Vector2] = []

signal body_entered_water(body: Node2D)
signal body_exited_water(body: Node2D)
signal body_at_surface(body: Node2D)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_initialize_bubbles()
	_initialize_caustics()
	
	collision_layer = 0
	collision_mask = 2


func _physics_process(delta: float) -> void:
	_time += delta
	
	for body in _affected_bodies:
		if is_instance_valid(body):
			_apply_water_physics(body, delta)
	
	_update_bubbles(delta)
	queue_redraw()


func _apply_water_physics(body: RigidBody2D, delta: float) -> void:
	# Apply drag
	body.linear_velocity *= water_drag
	
	# Apply buoyancy (upward force)
	var submerge_depth := _get_submerge_depth(body)
	if submerge_depth > 0:
		var buoyancy := Vector2.UP * buoyancy_force * clampf(submerge_depth / 50.0, 0.0, 1.5)
		body.apply_central_force(buoyancy)
	
	# Apply current
	var current_force := current_direction.normalized() * current_strength
	body.apply_central_force(current_force)
	
	# Check if at surface
	if abs(submerge_depth) < 20:
		body_at_surface.emit(body)


func _get_submerge_depth(body: RigidBody2D) -> float:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape is RectangleShape2D:
		return 50.0
	
	var rect_size: Vector2 = shape.shape.size
	var surface_y := global_position.y - rect_size.y / 2 + surface_y_offset
	return body.global_position.y - surface_y


func _initialize_bubbles() -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape:
		return
	
	var rect_size := Vector2(200, 200)
	if shape.shape is RectangleShape2D:
		rect_size = shape.shape.size
	
	for i in range(bubble_count):
		_bubbles.append({
			"x": randf_range(-rect_size.x / 2, rect_size.x / 2),
			"y": randf_range(-rect_size.y / 2, rect_size.y / 2),
			"size": randf_range(2, 6),
			"speed": randf_range(30, 80),
			"wobble_phase": randf() * TAU,
			"wobble_speed": randf_range(2, 5),
		})


func _initialize_caustics() -> void:
	# Create random caustic pattern points
	for i in range(20):
		_caustic_points.append(Vector2(
			randf_range(-100, 100),
			randf_range(-100, 100)
		))


func _update_bubbles(delta: float) -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape is RectangleShape2D:
		return
	
	var rect_size: Vector2 = shape.shape.size
	
	for bubble in _bubbles:
		# Move up
		bubble["y"] -= bubble["speed"] * delta
		# Wobble horizontally
		bubble["x"] += sin(_time * bubble["wobble_speed"] + bubble["wobble_phase"]) * 15 * delta
		# Move with current
		bubble["x"] += current_direction.normalized().x * current_strength * 0.1 * delta
		
		# Reset bubble when it reaches surface
		if bubble["y"] < -rect_size.y / 2:
			bubble["y"] = rect_size.y / 2
			bubble["x"] = randf_range(-rect_size.x / 2, rect_size.x / 2)


func _draw() -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape is RectangleShape2D:
		return
	
	var rect_size: Vector2 = shape.shape.size
	var rect := Rect2(-rect_size / 2, rect_size)
	
	# Water body
	draw_rect(rect, water_color)
	
	# Caustic light patterns
	_draw_caustics(rect_size)
	
	# Water surface with waves
	_draw_surface(rect_size)
	
	# Current indicator arrows
	_draw_current_arrows(rect_size)
	
	# Bubbles
	_draw_bubbles()
	
	# Border
	draw_rect(rect, Color(0.3, 0.6, 0.9, 0.3), false, 2.0)


func _draw_caustics(rect_size: Vector2) -> void:
	for i in range(_caustic_points.size()):
		var point := _caustic_points[i]
		# Animate caustics
		var offset := Vector2(
			sin(_time * 1.5 + i * 0.5) * 20,
			cos(_time * 1.2 + i * 0.7) * 20
		)
		var pos := point + offset
		
		# Keep within bounds
		pos.x = fmod(pos.x + rect_size.x / 2, rect_size.x) - rect_size.x / 2
		pos.y = fmod(pos.y + rect_size.y / 2, rect_size.y) - rect_size.y / 2
		
		# Draw caustic highlight
		var caustic_color := Color(0.6, 0.9, 1.0, 0.1 + sin(_time * 2 + i) * 0.05)
		draw_circle(pos, 15 + sin(_time * 3 + i * 2) * 5, caustic_color)


func _draw_surface(rect_size: Vector2) -> void:
	var points := PackedVector2Array()
	var top_y := -rect_size.y / 2 + surface_y_offset
	
	# Create wave points
	for i in range(21):
		var x := -rect_size.x / 2 + (rect_size.x / 20.0) * i
		var wave := sin(_time * wave_frequency + i * 0.4) * wave_amplitude
		points.append(Vector2(x, top_y + wave))
	
	# Draw wave lines
	for layer in range(3):
		var layer_offset := layer * 3
		var layer_alpha := 0.6 - layer * 0.15
		for i in range(points.size() - 1):
			var p1 := points[i] + Vector2(0, layer_offset)
			var p2 := points[i + 1] + Vector2(0, layer_offset)
			draw_line(p1, p2, Color(surface_color.r, surface_color.g, surface_color.b, layer_alpha), 2.0 - layer * 0.5)


func _draw_current_arrows(rect_size: Vector2) -> void:
	if current_strength < 10:
		return
	
	var arrow_count := 3
	var spacing := rect_size.x / (arrow_count + 1)
	
	for i in range(arrow_count):
		var x := -rect_size.x / 2 + spacing * (i + 1)
		# Animate position
		var offset := fmod(_time * current_strength * 0.2 + i * 50, rect_size.x) - rect_size.x / 2
		var arrow_pos := Vector2(offset, 0)
		
		# Draw arrow
		var arrow_size := 20.0
		var dir := current_direction.normalized()
		var end_pos := arrow_pos + dir * arrow_size
		
		draw_line(arrow_pos, end_pos, Color(1, 1, 1, 0.2), 2.0)
		
		# Arrow head
		var angle := dir.angle()
		var head1 := end_pos + Vector2(cos(angle + PI * 0.8), sin(angle + PI * 0.8)) * 8
		var head2 := end_pos + Vector2(cos(angle - PI * 0.8), sin(angle - PI * 0.8)) * 8
		draw_line(end_pos, head1, Color(1, 1, 1, 0.2), 2.0)
		draw_line(end_pos, head2, Color(1, 1, 1, 0.2), 2.0)


func _draw_bubbles() -> void:
	for bubble in _bubbles:
		var bubble_pos := Vector2(bubble["x"], bubble["y"])
		var bubble_size: float = bubble["size"]
		
		# Main bubble
		draw_circle(bubble_pos, bubble_size, Color(0.7, 0.9, 1.0, 0.3))
		# Highlight
		draw_circle(
			bubble_pos + Vector2(-bubble_size * 0.3, -bubble_size * 0.3),
			bubble_size * 0.3,
			Color(1, 1, 1, 0.4)
		)


func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		_affected_bodies.append(body)
		body_entered_water.emit(body)
		
		# Play splash sound
		if has_node("/root/AudioManager"):
			get_node("/root/AudioManager").play_sfx("water_splash")
		
		# Spawn splash particles
		_spawn_splash(body.global_position)


func _on_body_exited(body: Node) -> void:
	if body is RigidBody2D:
		_affected_bodies.erase(body)
		body_exited_water.emit(body)


func _spawn_splash(pos: Vector2) -> void:
	var particles := CPUParticles2D.new()
	particles.position = to_local(pos)
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = 20
	particles.lifetime = 0.6
	particles.direction = Vector2(0, -1)
	particles.spread = 45.0
	particles.initial_velocity_min = 80.0
	particles.initial_velocity_max = 180.0
	particles.gravity = Vector2(0, 400)
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 5.0
	particles.color = Color(0.5, 0.8, 1.0, 0.6)
	particles.finished.connect(particles.queue_free)
	add_child(particles)


# --- Public API ---

func set_current(direction: Vector2, strength: float) -> void:
	current_direction = direction.normalized()
	current_strength = strength


func reverse_current() -> void:
	current_direction = -current_direction
