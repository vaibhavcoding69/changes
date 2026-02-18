extends Area2D

## Collectible Star/Coin - Can be collected by the ball
## Tracks collection state and provides visual feedback

@export_group("Collectible Settings")
@export var collectible_id: String = ""  # Unique ID for save/load (auto-generated if empty)
@export var points_value: int = 100
@export var is_star: bool = true  # Star (level rating) vs Coin (bonus)

@export_group("Visual Settings")
@export var star_color: Color = Color(1.0, 0.9, 0.3)
@export var coin_color: Color = Color(1.0, 0.75, 0.2)
@export var glow_intensity: float = 1.0
@export var rotation_speed: float = 2.0
@export var bob_amplitude: float = 5.0
@export var bob_speed: float = 2.0

# --- Internal State ---
var _time: float = 0.0
var _collected: bool = false
var _base_position: Vector2
var _visual_rotation: float = 0.0
var _collect_scale: float = 1.0

signal collected(collectible: Area2D)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_base_position = position
	
	# Auto-generate ID if not set
	if collectible_id.is_empty():
		collectible_id = "%s_%d_%d" % [get_parent().name, int(position.x), int(position.y)]
	
	# Check if already collected
	if _is_collected_in_save():
		_collected = true
		visible = false
	
	collision_layer = 0
	collision_mask = 2


func _process(delta: float) -> void:
	if _collected:
		return
	
	_time += delta
	_visual_rotation += rotation_speed * delta
	
	# Bob animation
	position.y = _base_position.y + sin(_time * bob_speed) * bob_amplitude
	
	# Collection animation
	if _collect_scale < 1.0:
		_collect_scale = move_toward(_collect_scale, 0.0, delta * 4.0)
		if _collect_scale <= 0.01:
			visible = false
	
	queue_redraw()


func _draw() -> void:
	if _collected:
		return
	
	var base_scale := _collect_scale
	
	if is_star:
		_draw_star(base_scale)
	else:
		_draw_coin(base_scale)


func _draw_star(base_scale: float) -> void:
	var scale := base_scale
	var glow_pulse := (sin(_time * 3.0) + 1.0) * 0.5 * glow_intensity
	
	# Glow layers
	for i in range(4):
		var glow_size := (20 + i * 8) * scale
		var alpha := (0.15 - i * 0.03) * (1.0 + glow_pulse * 0.5)
		var glow_col := Color(star_color.r, star_color.g, star_color.b, alpha)
		draw_circle(Vector2.ZERO, glow_size, glow_col)
	
	# Draw star shape
	var points := PackedVector2Array()
	var inner_radius := 8 * scale
	var outer_radius := 16 * scale
	
	for i in range(10):
		var angle := _visual_rotation + float(i) / 10.0 * TAU - PI / 2
		var radius := outer_radius if i % 2 == 0 else inner_radius
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	
	# Star fill
	var fill_color := star_color
	fill_color.a = 0.9
	draw_colored_polygon(points, fill_color)
	
	# Star outline
	points.append(points[0])  # Close the shape
	draw_polyline(points, Color(1, 1, 0.8, 0.8), 2.0)
	
	# Center highlight
	draw_circle(Vector2(-2, -2) * scale, 4 * scale, Color(1, 1, 1, 0.5))
	
	# Sparkle particles
	_draw_sparkles(scale)


func _draw_coin(base_scale: float) -> void:
	var scale := base_scale
	var glow_pulse := (sin(_time * 3.0) + 1.0) * 0.5 * glow_intensity
	
	# Ellipse squash for 3D rotation effect
	var squash := abs(cos(_visual_rotation * 2))
	var coin_width := 14 * scale * (0.3 + squash * 0.7)
	var coin_height := 14 * scale
	
	# Glow
	for i in range(3):
		var glow_size := 18 + i * 6
		var alpha := (0.12 - i * 0.03) * (1.0 + glow_pulse * 0.5)
		draw_circle(Vector2.ZERO, glow_size * scale, Color(coin_color.r, coin_color.g, coin_color.b, alpha))
	
	# Coin body (ellipse approximation)
	_draw_ellipse(Vector2.ZERO, coin_width, coin_height, coin_color)
	
	# Edge highlight
	if squash > 0.3:
		var highlight_x := -coin_width * 0.5
		draw_line(
			Vector2(highlight_x, -coin_height * 0.6),
			Vector2(highlight_x, coin_height * 0.6),
			Color(1, 0.9, 0.6, 0.4), 2.0
		)
	
	# Inner circle/symbol
	if squash > 0.5:
		_draw_ellipse(Vector2.ZERO, coin_width * 0.6, coin_height * 0.6, Color(0.9, 0.65, 0.15))


func _draw_ellipse(center: Vector2, width: float, height: float, color: Color) -> void:
	var points := PackedVector2Array()
	var segments := 24
	
	for i in range(segments):
		var angle := float(i) / segments * TAU
		points.append(center + Vector2(cos(angle) * width, sin(angle) * height))
	
	draw_colored_polygon(points, color)


func _draw_sparkles(scale: float) -> void:
	var sparkle_count := 3
	for i in range(sparkle_count):
		var angle := _time * 4 + float(i) / sparkle_count * TAU
		var dist := 20 + sin(_time * 6 + i * 2) * 5
		var pos := Vector2(cos(angle), sin(angle)) * dist * scale
		var sparkle_size := 2 + sin(_time * 8 + i * 3) * 1
		
		draw_circle(pos, sparkle_size * scale, Color(1, 1, 1, 0.6))


func _on_body_entered(body: Node) -> void:
	if _collected:
		return
	
	if body.name == "Player" or body.is_in_group("ball"):
		_collect(body)


func _collect(collector: Node2D) -> void:
	_collected = true
	
	# Start collection animation
	_collect_scale = 1.0
	
	# Spawn collection particles
	_spawn_collect_particles()
	
	# Play sound
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sfx("star_collect")
	
	# Update game state
	if has_node("/root/GameState"):
		var game_state = get_node("/root/GameState")
		if is_star:
			game_state.add_stars(1)
		game_state.add_collectible(collectible_id, points_value)
	
	collected.emit(self)
	
	# Delayed free
	get_tree().create_timer(0.5).timeout.connect(queue_free)


func _spawn_collect_particles() -> void:
	var particles := CPUParticles2D.new()
	particles.position = Vector2.ZERO
	particles.emitting = true
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = 25
	particles.lifetime = 0.6
	particles.direction = Vector2(0, 0)
	particles.spread = 180.0
	particles.initial_velocity_min = 80.0
	particles.initial_velocity_max = 200.0
	particles.gravity = Vector2(0, -50)
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 5.0
	particles.color = star_color if is_star else coin_color
	particles.finished.connect(particles.queue_free)
	get_parent().add_child(particles)
	particles.global_position = global_position


func _is_collected_in_save() -> bool:
	if has_node("/root/GameState"):
		var game_state = get_node("/root/GameState")
		if game_state.has_method("is_collectible_collected"):
			return game_state.is_collectible_collected(collectible_id)
	return false


# --- Public API ---

func reset() -> void:
	_collected = false
	visible = true
	_collect_scale = 1.0
	position = _base_position
