extends Camera2D

## Advanced Game Camera
## 
## robust handling of:
## - Target following with look-ahead
## - World boundary clamping (never show void if possible)
## - Letterboxing/Centering when viewport is larger than level
## - Screen shake on impact
## - Visual debugging of limits and safe zones
## - Ball safety check (warns if ball escapes)

@export_group("Targeting")
@export var target_path: NodePath
@export var smooth_speed: float = 5.0
@export var look_ahead_factor: float = 0.15
@export var look_ahead_smoothing: float = 3.0

@export_group("Limits & Boundaries")
@export var use_limits: bool = true
## If the viewport is larger than these limits, center the camera on the limits center.
@export var center_if_missized: bool = true
## The world bounds (x, y, width, height)
@export var world_bounds: Rect2 = Rect2(0, 0, 1200, 800)

@export_group("Effects")
@export var shake_decay: float = 8.0
@export var max_shake_offset: Vector2 = Vector2(25, 25)

@export_group("Debug")
@export var show_debug_visuals: bool = true
@export var debug_color: Color = Color.CYAN

# Internal state
var _target_node: Node2D
var _shake_strength: float = 0.0
var _current_look_ahead: Vector2 = Vector2.ZERO
var _is_first_frame: bool = true

# Cache
@onready var _viewport: Viewport = get_viewport()

func _ready() -> void:
    # Attempt to resolve target
    if target_path:
        _target_node = get_node_or_null(target_path)
    
    if not _target_node and get_parent().has_node("Ball"):
        _target_node = get_parent().get_node("Ball")
    
    # Configure basic camera properties
    process_callback = Camera2D.CAMERA2D_PROCESS_PHYSICS
    position_smoothing_enabled = false # We handle smoothing manually for more control
    
    # Connect to impact signals if possible
    _try_connect_impact_signal()
    
    # Validate limits
    if use_limits:
        # We manually manage position, so disable built-in limits to avoid conflicts
        limit_left = -10000000
        limit_top = -10000000
        limit_right = 10000000
        limit_bottom = 10000000
    
    # Initial alignment
    if _target_node:
        global_position = _target_node.global_position
        align() # Force update

func _process(delta: float) -> void:
    # Shake decay
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
        # Try to find ball if we lost it (e.g. respawn)
        if get_parent().has_node("Ball"):
            _target_node = get_parent().get_node("Ball")
            _try_connect_impact_signal()
        return

    # 1. Calculate desired target position
    var target_pos = _target_node.global_position
    
    # 2. Add look-ahead based on velocity (if RigidBody)
    var look_vec = Vector2.ZERO
    if _target_node is RigidBody2D:
        look_vec = _target_node.linear_velocity * look_ahead_factor
    
    _current_look_ahead = _current_look_ahead.lerp(look_vec, look_ahead_smoothing * delta)
    target_pos += _current_look_ahead
    
    # 3. Apply smoothing
    if _is_first_frame:
        global_position = target_pos
        _is_first_frame = false
    else:
        global_position = global_position.lerp(target_pos, smooth_speed * delta)
    
    # 4. Constrain to limits (Custom logic to handle "viewport > limits" case)
    if use_limits:
        _constrain_to_limits()
    
    # 5. Safety check: Is ball out of bounds?
    if _target_node.global_position.y > world_bounds.end.y + 200:
        print_rich("[color=red]ALERT: Ball has fallen out of world bounds! Resetting...[/color]")
        # We could auto-reset here, but let's just warn for now or rely on game state
        
func _constrain_to_limits() -> void:
    var vp_rect = get_viewport_rect()
    var visible_size = vp_rect.size / zoom
    
    var final_pos = global_position
    
    # Horizontal check
    if world_bounds.size.x < visible_size.x:
        # World is smaller than viewport width -> Center it
        if center_if_missized:
            final_pos.x = world_bounds.position.x + world_bounds.size.x * 0.5
    else:
        # World is larger -> Clamp normal
        var min_x = world_bounds.position.x + visible_size.x * 0.5
        var max_x = world_bounds.end.x - visible_size.x * 0.5
        final_pos.x = clampf(final_pos.x, min_x, max_x)
        
    # Vertical check
    if world_bounds.size.y < visible_size.y:
        # World is smaller than viewport height -> Center it
        if center_if_missized:
            final_pos.y = world_bounds.position.y + world_bounds.size.y * 0.5
    else:
        # World is larger -> Clamp normal
        var min_y = world_bounds.position.y + visible_size.y * 0.5
        var max_y = world_bounds.end.y - visible_size.y * 0.5
        final_pos.y = clampf(final_pos.y, min_y, max_y)
    
    global_position = final_pos

func _try_connect_impact_signal() -> void:
    if _target_node and _target_node.has_signal("impact_occurred"):
        if not _target_node.is_connected("impact_occurred", _on_impact):
            _target_node.impact_occurred.connect(_on_impact)

func _on_impact(strength: float) -> void:
    # strength is usually 0..something large. Normalize roughly.
    var intensity = clampf(strength / 800.0, 0.0, 1.0)
    _shake_strength = intensity * 5.0 # decay starts from here

# --- Debug Drawing ---

func _draw() -> void:
    if not show_debug_visuals or not Engine.is_editor_hint() and not OS.is_debug_build():
        # Only show in debug builds or editor
        if not OS.has_feature("editor"): # But user might want to see it now
             pass # Logic to force show based on export var
             
    if show_debug_visuals:
        # Draw camera center
        draw_line(Vector2(-10, 0), Vector2(10, 0), debug_color, 2.0)
        draw_line(Vector2(0, -10), Vector2(0, 10), debug_color, 2.0)
        
        # Draw limits rect relative to camera (since draw is local)
        # We need to transform world coordinates to local
        var local_rect = world_bounds
        local_rect.position -= global_position
        
        draw_rect(local_rect, debug_color, false, 2.0)
        
        # Draw "Dead zone" or "Safe Area"
        # ...
