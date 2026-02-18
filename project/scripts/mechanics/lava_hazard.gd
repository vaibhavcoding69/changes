extends Area2D

## Lava Hazard - Kills the ball on contact, respawns at last checkpoint
## Used in Volcano world levels

@export_group("Hazard Settings")
@export var damage_delay: float = 0.0  # Seconds before damage is applied
@export var respawn_delay: float = 0.8
@export var show_warning: bool = true
@export var warning_distance: float = 100.0

@export_group("Visual Settings")
@export var lava_color: Color = Color(1.0, 0.3, 0.1)
@export var glow_color: Color = Color(1.0, 0.6, 0.2)
@export var bubble_count: int = 12
@export var surface_wave_speed: float = 2.0

# --- Internal State ---
var _time: float = 0.0
var _bubbles: Array[Dictionary] = []
var _warning_active: bool = false
var _warning_target: Node2D = null

signal ball_killed(ball: Node2D)
signal ball_warning(ball: Node2D, distance: float)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_initialize_bubbles()
	
	# Set up collision
	collision_layer = 0
	collision_mask = 2  # Detect layer 2 (ball)
	
	# Set up monitoring for warning zone
	var warning_area := Area2D.new()
	warning_area.name = "WarningZone"
	var warning_shape := CollisionShape2D.new()
	warning_shape.shape = _create_warning_shape()
	warning_area.add_child(warning_shape)
	warning_area.collision_layer = 0
	warning_area.collision_mask = 2
	warning_area.body_entered.connect(_on_warning_entered)
	warning_area.body_exited.connect(_on_warning_exited)
	add_child(warning_area)


func _create_warning_shape() -> Shape2D:
	var shape := get_node_or_null("CollisionShape2D")
	if shape and shape.shape is RectangleShape2D:
		var rect: RectangleShape2D = shape.shape
		var warning_rect := RectangleShape2D.new()
		warning_rect.size = rect.size + Vector2(warning_distance * 2, warning_distance * 2)
		return warning_rect
	return CircleShape2D.new()


func _process(delta: float) -> void:
	_time += delta
	_update_bubbles(delta)
	
	# Update warning
	if _warning_active and _warning_target and is_instance_valid(_warning_target):
		var distance := global_position.distance_to(_warning_target.global_position)
		ball_warning.emit(_warning_target, distance)
	
	queue_redraw()


func _initialize_bubbles() -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape:
		return
	
	var rect_size := Vector2(200, 50)
	if shape.shape is RectangleShape2D:
		rect_size = shape.shape.size
	
	for i in range(bubble_count):
		_bubbles.append({
			"x": randf_range(-rect_size.x / 2, rect_size.x / 2),
			"y": rect_size.y / 2,
			"size": randf_range(3, 8),
			"speed": randf_range(20, 50),
			"phase": randf() * TAU,
		})


func _update_bubbles(delta: float) -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape is RectangleShape2D:
		return
	
	var rect_size: Vector2 = shape.shape.size
	
	for bubble in _bubbles:
		bubble["y"] -= bubble["speed"] * delta
		bubble["x"] += sin(_time * 3 + bubble["phase"]) * 10 * delta
		
		# Reset bubble when it reaches top
		if bubble["y"] < -rect_size.y / 2:
			bubble["y"] = rect_size.y / 2
			bubble["x"] = randf_range(-rect_size.x / 2, rect_size.x / 2)
			bubble["size"] = randf_range(3, 8)


func _draw() -> void:
	var shape := get_node_or_null("CollisionShape2D")
	if not shape or not shape.shape is RectangleShape2D:
		return
	
	var rect_size: Vector2 = shape.shape.size
	var rect := Rect2(-rect_size / 2, rect_size)
	
	# Lava body
	var wave_offset := sin(_time * surface_wave_speed) * 3
	draw_rect(rect, lava_color)
	
	# Surface waves
	_draw_surface_waves(rect_size, wave_offset)
	
	# Glow effect
	for i in range(3):
		var glow_rect := Rect2(
			rect.position - Vector2(i * 4, i * 4),
			rect.size + Vector2(i * 8, i * 8)
		)
		var glow := glow_color
		glow.a = 0.1 - i * 0.025
		draw_rect(glow_rect, glow, false, 2.0)
	
	# Bubbles
	for bubble in _bubbles:
		var bubble_color := Color(1, 0.7, 0.3, 0.6)
		draw_circle(Vector2(bubble["x"], bubble["y"]), bubble["size"], bubble_color)
		# Highlight
		draw_circle(
			Vector2(bubble["x"] - bubble["size"] * 0.3, bubble["y"] - bubble["size"] * 0.3),
			bubble["size"] * 0.3,
			Color(1, 1, 0.8, 0.4)
		)
	
	# Skull warning icon (optional)
	if show_warning:
		_draw_warning_icon()


func _draw_surface_waves(rect_size: Vector2, base_offset: float) -> void:
	var points := PackedVector2Array()
	var top_y := -rect_size.y / 2
	
	for i in range(21):
		var x := -rect_size.x / 2 + (rect_size.x / 20.0) * i
		var wave := sin(_time * surface_wave_speed + i * 0.5) * 4
		points.append(Vector2(x, top_y + wave))
	
	# Draw wave line
	for i in range(points.size() - 1):
		draw_line(points[i], points[i + 1], Color(1, 0.8, 0.4, 0.8), 3.0)


func _draw_warning_icon() -> void:
	var icon_pos := Vector2(0, -50)
	
	# Pulsing effect
	var pulse := (sin(_time * 4) + 1) * 0.5
	var icon_scale := 1.0 + pulse * 0.1
	
	# Triangle warning
	var size := 15 * icon_scale
	var p1 := icon_pos + Vector2(0, -size)
	var p2 := icon_pos + Vector2(-size * 0.866, size * 0.5)
	var p3 := icon_pos + Vector2(size * 0.866, size * 0.5)
	
	draw_polygon([p1, p2, p3], [Color(1, 0.8, 0, 0.3 + pulse * 0.2)])
	draw_polyline([p1, p2, p3, p1], Color(1, 0.6, 0, 0.6), 2.0)
	
	# Exclamation mark
	draw_line(
		icon_pos + Vector2(0, -6) * icon_scale,
		icon_pos + Vector2(0, 2) * icon_scale,
		Color(0.2, 0.1, 0, 0.8),
		2.5
	)
	draw_circle(icon_pos + Vector2(0, 7) * icon_scale, 2 * icon_scale, Color(0.2, 0.1, 0, 0.8))


func _on_body_entered(body: Node) -> void:
	if body.name == "Player" or body.is_in_group("ball"):
		_kill_ball(body)


func _on_warning_entered(body: Node) -> void:
	if body.name == "Player" or body.is_in_group("ball"):
		_warning_active = true
		_warning_target = body


func _on_warning_exited(body: Node) -> void:
	if body == _warning_target:
		_warning_active = false
		_warning_target = null


func _kill_ball(ball: Node2D) -> void:
	ball_killed.emit(ball)
	
	# Play death effect
	_spawn_death_particles(ball.global_position)
	
	# Play sound
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("lava_sizzle")
	
	# Freeze and respawn
	if ball is RigidBody2D:
		ball.freeze = true
		ball.visible = false
	
	# Respawn after delay
	get_tree().create_timer(respawn_delay).timeout.connect(func():
		_respawn_ball(ball)
	)


func _respawn_ball(ball: Node2D) -> void:
	# Find spawn point in parent
	var spawn_point := ball.get_parent().get_node_or_null("BallSpawn") as Marker2D
	if spawn_point:
		ball.global_position = spawn_point.global_position
	else:
		# Fallback: move up significantly
		ball.global_position = global_position + Vector2(0, -200)
	
	if ball is RigidBody2D:
		ball.linear_velocity = Vector2.ZERO
		ball.freeze = false
	
	ball.visible = true


func _spawn_death_particles(pos: Vector2) -> void:
	var particles := CPUParticles2D.new()
	particles.position = to_local(pos)
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = 30
	particles.lifetime = 0.8
	particles.direction = Vector2(0, -1)
	particles.spread = 60.0
	particles.initial_velocity_min = 100.0
	particles.initial_velocity_max = 250.0
	particles.gravity = Vector2(0, 200)
	particles.scale_amount_min = 3.0
	particles.scale_amount_max = 8.0
	particles.color = Color(1, 0.5, 0.1)
	particles.finished.connect(particles.queue_free)
	add_child(particles)
