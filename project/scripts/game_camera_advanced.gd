extends Camera2D

## Advanced Game Camera
## Robust handling of target following, boundary clamping, and world centering

@export_group("Targeting")
@export var target_path: NodePath
@export var smooth_speed: float = 5.0
@export var look_ahead_factor: float = 0.15
@export var look_ahead_smoothing: float = 3.0

@export_group("Limits & Boundaries")
@export var use_limits: bool = true
@export var center_if_missized: bool = true
@export var world_bounds: Rect2 = Rect2(0, 0, 1200, 800)

@export_group("Effects")
@export var shake_decay: float = 8.0
@export var max_shake_offset: Vector2 = Vector2(25, 25)

@export_group("Debug")
@export var show_debug_visuals: bool = true
@export var debug_color: Color = Color.CYAN

var _target_node: Node2D
var _shake_strength: float = 0.0
var _current_look_ahead: Vector2 = Vector2.ZERO
var _is_first_frame: bool = true
var _debug_counter: int = 0

@onready var _viewport: Viewport = get_viewport()

func _ready() -> void:
    if target_path:
        _target_node = get_node_or_null(target_path)
    
    if not _target_node and get_parent().has_node("Ball"):
        _target_node = get_parent().get_node("Ball")
    
    process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
    position_smoothing_enabled = false
    anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
    zoom = Vector2(1.0, 1.0)
    
    _try_connect_impact_signal()
    
    if use_limits:
        limit_left = -10000000
        limit_top = -10000000
        limit_right = 10000000
        limit_bottom = 10000000
    
    if _target_node:
        global_position = _target_node.global_position
        align()
    
    print_rich(
        "[color=cyan]CAMERA INIT:[/color] ",
        "WorldBounds=", world_bounds, " | ",
        "Zoom=", zoom, " | ",
        "AP=", anchor_mode
    )

func _process(delta: float) -> void:
    if _shake_strength > 0:
        _shake_strength = move_toward(_shake_strength, 0.0, shake_decay * delta)
        offset = Vector2(
            randf_range(-_shake_strength, _shake_strength),
            randf_range(-_shake_strength, _shake_strength)
        ) * max_shake_offset * 0.1
    else:
        offset = Vector2.ZERO

    if show_debug_visuals:
        queue_redraw()

func _physics_process(delta: float) -> void:
    if not is_instance_valid(_target_node):
        if get_parent().has_node("Ball"):
            _target_node = get_parent().get_node("Ball")
            _try_connect_impact_signal()
        return

    var target_pos = _target_node.global_position
    
    var look_vec = Vector2.ZERO
    if _target_node is RigidBody2D:
        look_vec = _target_node.linear_velocity * look_ahead_factor
    
    _current_look_ahead = _current_look_ahead.lerp(look_vec, look_ahead_smoothing * delta)
    target_pos += _current_look_ahead
    
    if _is_first_frame:
        global_position = target_pos
        _is_first_frame = false
    else:
        global_position = global_position.lerp(target_pos, smooth_speed * delta)
    
    var vp_rect = get_viewport_rect()
    var visible_size = vp_rect.size / zoom
    
    if is_equal_approx(world_bounds.size.x, visible_size.x) and is_equal_approx(world_bounds.size.y, visible_size.y):
        global_position = world_bounds.position + world_bounds.size * 0.5
    
    if use_limits:
        _constrain_to_limits()
    
    var ball_pos = _target_node.global_position
    var escape_margin = 300.0
    if ball_pos.y > world_bounds.end.y + escape_margin or ball_pos.y < world_bounds.position.y - escape_margin \
            or ball_pos.x > world_bounds.end.x + escape_margin or ball_pos.x < world_bounds.position.x - escape_margin:
        print_rich("[color=red]ALERT: Ball escaped world bounds! Position: ", ball_pos, "[/color]")
        var spawn_point = get_parent().get_node_or_null("BallSpawn")
        if spawn_point:
            _target_node.global_position = spawn_point.global_position
            _target_node.linear_velocity = Vector2.ZERO
            _target_node.angular_velocity = 0.0
            print_rich("[color=green]Ball respawned at: ", spawn_point.global_position, "[/color]")

func _constrain_to_limits() -> void:
    var vp_rect = get_viewport_rect()
    var visible_size = vp_rect.size / zoom
    
    _debug_counter += 1
    if show_debug_visuals and _debug_counter >= 600:
        _debug_counter = 0
        var is_centered_x = world_bounds.size.x < visible_size.x
        var is_centered_y = world_bounds.size.y < visible_size.y
        print_rich(
            "[color=yellow]CAM:[/color] VP=", vp_rect.size, 
            " Visible=", visible_size, " WorldSize=", world_bounds.size,
            " CenterX=", is_centered_x, " CenterY=", is_centered_y,
            " WorldPos=", world_bounds.position, " CamPos=", global_position
        )
    
    var final_pos = global_position
    
    if world_bounds.size.x < visible_size.x:
        final_pos.x = world_bounds.position.x + world_bounds.size.x * 0.5
    else:
        var min_x = world_bounds.position.x + visible_size.x * 0.5
        var max_x = world_bounds.end.x - visible_size.x * 0.5
        final_pos.x = clampf(final_pos.x, min_x, max_x)
    
    if world_bounds.size.y < visible_size.y:
        final_pos.y = world_bounds.position.y + world_bounds.size.y * 0.5
    else:
        var min_y = world_bounds.position.y + visible_size.y * 0.5
        var max_y = world_bounds.end.y - visible_size.y * 0.5
        final_pos.y = clampf(final_pos.y, min_y, max_y)
    
    global_position = final_pos

func _try_connect_impact_signal() -> void:
    if _target_node and _target_node.has_signal("impact_occurred"):
        if not _target_node.is_connected("impact_occurred", _on_impact):
            _target_node.impact_occurred.connect(_on_impact)

func _on_impact(strength: float) -> void:
    var intensity = clampf(strength / 800.0, 0.0, 1.0)
    _shake_strength = intensity * 5.0
