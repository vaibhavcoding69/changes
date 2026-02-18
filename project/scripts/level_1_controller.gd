extends Node2D

## Level 1 "Meadow" - Fully interactive controller
## Features: animated background with parallax grass layers, floating particles,
## dynamic HUD with combo counter, tutorial popups, star rating animation,
## enhanced level intro/outro sequences, ambient firefly particles

# ═══════════════════════════════════════════════════════════════
# CONSTANTS & CONFIGURATION
# ═══════════════════════════════════════════════════════════════

const WORLD_NAME: String = "Meadow"
const LEVEL_NUM: int = 1
const WORLD_NUM: int = 1
const SCREEN_W: float = 1600.0
const SCREEN_H: float = 1000.0

# Star rating thresholds (shots)
const STAR_3_MAX: int = 2
const STAR_2_MAX: int = 4
const STAR_1_MAX: int = 6

# Meadow colour palette
const COL_SKY_TOP := Color(0.12, 0.18, 0.28, 1.0)
const COL_SKY_BOT := Color(0.08, 0.12, 0.2, 1.0)
const COL_GRASS := Color(0.22, 0.45, 0.28, 1.0)
const COL_GRASS_LIGHT := Color(0.32, 0.58, 0.36, 0.6)
const COL_PLATFORM := Color(0.38, 0.42, 0.52, 1.0)
const COL_PLATFORM_EDGE := Color(0.55, 0.6, 0.72, 0.8)
const COL_ACCENT := Color(0.45, 0.82, 0.45, 1.0)
const COL_WARM := Color(0.95, 0.88, 0.72, 1.0)
const COL_HINT := Color(0.8, 0.78, 0.7, 0.8)
const COL_DIM := Color(0.5, 0.48, 0.45, 0.6)

# ═══════════════════════════════════════════════════════════════
# NODE REFERENCES
# ═══════════════════════════════════════════════════════════════

@onready var player: RigidBody2D = $Player
@onready var goal: Area2D = $Goal
@onready var ui_layer: CanvasLayer = $UI
@onready var shot_label: Label = $UI/ShotCounter
@onready var hint_label: Label = $UI/HintLabel
@onready var complete_panel: ColorRect = $UI/LevelComplete
@onready var complete_label: Label = $UI/LevelComplete/CompletionLabel
@onready var pause_menu: Control = $UI/PauseMenu

# ═══════════════════════════════════════════════════════════════
# STATE VARIABLES
# ═══════════════════════════════════════════════════════════════

var level_complete: bool = false
var level_started: bool = false
var _restart_cooldown: float = 0.0
var _time: float = 0.0

# Combo system
var _combo_count: int = 0
var _combo_timer: float = 0.0
var _best_combo: int = 0
const COMBO_WINDOW: float = 2.0

# Tutorial popup state
var _tutorial_step: int = 0
var _tutorial_shown: Array[bool] = [false, false, false, false]
var _tutorial_popup: Control = null
var _tutorial_timer: float = 0.0

# Intro/outro state
var _intro_active: bool = true
var _intro_timer: float = 0.0
var _outro_active: bool = false
var _outro_timer: float = 0.0

# Ambient particles
var _fireflies: Array[Dictionary] = []
var _grass_blades: Array[Dictionary] = []

# HUD animation state
var _hud_shot_scale: float = 1.0
var _hud_combo_alpha: float = 0.0
var _star_nodes: Array[Label] = []

# Background decoration nodes
var _bg_layer: Control = null
var _fg_layer: Control = null
var _decoration_layer: Node2D = null

# ═══════════════════════════════════════════════════════════════
# READY
# ═══════════════════════════════════════════════════════════════

func _ready() -> void:
	# Connect player signals
	if player:
		player.shot_fired.connect(_on_shot_fired)
		player.impact_occurred.connect(_on_impact)
	# Connect goal signal
	if goal:
		goal.goal_reached.connect(_on_goal_reached)
	# Hide completion panel
	if complete_panel:
		complete_panel.visible = false
	# Update shot display
	_update_shot_display(0)

	# Build dynamic layers
	_build_ambient_background()
	_build_fireflies(25)
	_build_grass_blades(40)
	_build_enhanced_hud()
	_build_tutorial_system()
	_start_level_intro()


#SECTION_PROCESS

# ═══════════════════════════════════════════════════════════════
# PROCESS LOOP
# ═══════════════════════════════════════════════════════════════

func _process(delta: float) -> void:
	_time += delta

	if _restart_cooldown > 0:
		_restart_cooldown -= delta

	# Update all dynamic systems
	_update_fireflies(delta)
	_update_grass_blades(delta)
	_update_combo(delta)
	_update_hud_animation(delta)
	_update_tutorial(delta)

	if _intro_active:
		_update_intro(delta)
	if _outro_active:
		_update_outro(delta)


# ═══════════════════════════════════════════════════════════════
# AMBIENT BACKGROUND
# ═══════════════════════════════════════════════════════════════

func _build_ambient_background() -> void:
	# Parent container behind everything else
	_bg_layer = Control.new()
	_bg_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg_layer.z_index = -10
	add_child(_bg_layer)
	move_child(_bg_layer, 0)

	# Night sky gradient overlay at the top
	var sky_grad := ColorRect.new()
	sky_grad.position = Vector2(-200, -200)
	sky_grad.size = Vector2(SCREEN_W + 400, 450)
	sky_grad.color = Color(0.08, 0.1, 0.2, 0.3)
	sky_grad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg_layer.add_child(sky_grad)

	# Scatter background stars (tiny dots)
	for i in 30:
		var star := ColorRect.new()
		var sz := randf_range(1.5, 3.5)
		star.size = Vector2(sz, sz)
		star.position = Vector2(randf_range(-100, SCREEN_W + 100), randf_range(-100, 400))
		star.color = Color(1, 1, 0.95, randf_range(0.04, 0.15))
		star.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_bg_layer.add_child(star)

	# Distant hill silhouettes (parallax-like)
	for i in 4:
		var hill := ColorRect.new()
		var hw := randf_range(300, 600)
		var hh := randf_range(40, 100)
		hill.position = Vector2(randf_range(-100, SCREEN_W - 200), 750 - hh + i * 20)
		hill.size = Vector2(hw, hh + 200)
		hill.color = Color(0.1, 0.15 + i * 0.02, 0.12 + i * 0.015, 0.25 - i * 0.04)
		hill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_bg_layer.add_child(hill)

	# Ground grass strip at the very bottom
	var ground_strip := ColorRect.new()
	ground_strip.position = Vector2(-200, 920)
	ground_strip.size = Vector2(SCREEN_W + 400, 100)
	ground_strip.color = COL_GRASS
	ground_strip.color.a = 0.15
	ground_strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg_layer.add_child(ground_strip)

	# Create foreground decoration layer
	_fg_layer = Control.new()
	_fg_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fg_layer.z_index = 5
	add_child(_fg_layer)

	# Vignette corners
	for corner_data in [
		{"pos": Vector2(-50, -50), "size": Vector2(400, 400)},
		{"pos": Vector2(SCREEN_W - 350, -50), "size": Vector2(400, 400)},
		{"pos": Vector2(-50, SCREEN_H - 350), "size": Vector2(400, 400)},
		{"pos": Vector2(SCREEN_W - 350, SCREEN_H - 350), "size": Vector2(400, 400)},
	]:
		var vig := ColorRect.new()
		vig.position = corner_data["pos"]
		vig.size = corner_data["size"]
		vig.color = Color(0, 0, 0, 0.06)
		vig.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_fg_layer.add_child(vig)


#SECTION_FIREFLIES

# ═══════════════════════════════════════════════════════════════
# FIREFLY PARTICLES
# ═══════════════════════════════════════════════════════════════

func _build_fireflies(count: int) -> void:
	for i in count:
		var fly := ColorRect.new()
		var sz := randf_range(2.5, 5.0)
		fly.size = Vector2(sz, sz)
		fly.mouse_filter = Control.MOUSE_FILTER_IGNORE
		fly.z_index = 4

		var glow_hue := randf_range(0.2, 0.4)  # green-yellow range
		fly.color = Color.from_hsv(glow_hue, 0.5, 1.0, 0.0)

		add_child(fly)

		var data := {
			"node": fly,
			"x": randf_range(-50, SCREEN_W + 50),
			"y": randf_range(200, SCREEN_H - 100),
			"vx": randf_range(-15, 15),
			"vy": randf_range(-10, 10),
			"phase": randf_range(0, TAU),
			"blink_speed": randf_range(1.5, 4.0),
			"max_alpha": randf_range(0.15, 0.45),
			"wobble": randf_range(15, 50),
		}
		_fireflies.append(data)


func _update_fireflies(delta: float) -> void:
	for ff in _fireflies:
		var node: ColorRect = ff["node"]
		ff["x"] += ff["vx"] * delta + sin(_time * 0.7 + ff["phase"]) * ff["wobble"] * delta
		ff["y"] += ff["vy"] * delta + cos(_time * 0.5 + ff["phase"]) * ff["wobble"] * 0.5 * delta

		# Wrap around
		if ff["x"] < -60: ff["x"] = SCREEN_W + 50
		elif ff["x"] > SCREEN_W + 60: ff["x"] = -50
		if ff["y"] < 100: ff["y"] = SCREEN_H - 100
		elif ff["y"] > SCREEN_H: ff["y"] = 200

		node.position = Vector2(ff["x"], ff["y"])

		# Smooth blink
		var blink := (sin(_time * ff["blink_speed"] + ff["phase"]) + 1.0) * 0.5
		node.color.a = blink * ff["max_alpha"]


# ═══════════════════════════════════════════════════════════════
# ANIMATED GRASS BLADES
# ═══════════════════════════════════════════════════════════════

func _build_grass_blades(count: int) -> void:
	for i in count:
		var blade := ColorRect.new()
		var bw := randf_range(2, 5)
		var bh := randf_range(12, 35)
		blade.size = Vector2(bw, bh)
		blade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		blade.z_index = 1

		var shade := randf_range(0.7, 1.0)
		blade.color = Color(
			COL_GRASS.r * shade,
			COL_GRASS.g * shade,
			COL_GRASS.b * shade,
			randf_range(0.2, 0.5)
		)

		blade.pivot_offset = Vector2(bw / 2, bh)  # pivot at base

		add_child(blade)

		var data := {
			"node": blade,
			"base_x": randf_range(-50, SCREEN_W + 50),
			"base_y": randf_range(900, 945),
			"phase": randf_range(0, TAU),
			"sway_speed": randf_range(1.0, 3.0),
			"sway_amount": randf_range(0.05, 0.2),
		}
		blade.position = Vector2(data["base_x"], data["base_y"] - bh)
		_grass_blades.append(data)


func _update_grass_blades(delta: float) -> void:
	for gb in _grass_blades:
		var node: ColorRect = gb["node"]
		var sway: float = sin(_time * gb["sway_speed"] + gb["phase"]) * gb["sway_amount"]
		node.rotation = sway

		# React to nearby player (bend away)
		if player and is_instance_valid(player):
			var dist := player.global_position.distance_to(
				Vector2(gb["base_x"], gb["base_y"])
			)
			if dist < 120.0:
				var push_dir := signf(gb["base_x"] - player.global_position.x)
				var push_strength := (1.0 - dist / 120.0) * 0.35
				node.rotation += push_dir * push_strength


#SECTION_HUD

# ═══════════════════════════════════════════════════════════════
# ENHANCED HUD
# ═══════════════════════════════════════════════════════════════

var _combo_label: Label = null
var _world_badge: Control = null
var _timer_label: Label = null
var _level_timer: float = 0.0

func _build_enhanced_hud() -> void:
	if not ui_layer:
		return

	# World + Level badge (top-left corner)
	_world_badge = Control.new()
	_world_badge.position = Vector2(16, 55)
	ui_layer.add_child(_world_badge)

	var badge_bg := ColorRect.new()
	badge_bg.size = Vector2(160, 28)
	badge_bg.color = Color(0.1, 0.12, 0.18, 0.6)
	_world_badge.add_child(badge_bg)

	var badge_accent := ColorRect.new()
	badge_accent.size = Vector2(3, 28)
	badge_accent.color = COL_ACCENT
	_world_badge.add_child(badge_accent)

	var badge_label := Label.new()
	badge_label.text = "%s  •  Level %d" % [WORLD_NAME, LEVEL_NUM]
	badge_label.position = Vector2(12, 2)
	badge_label.size = Vector2(140, 24)
	badge_label.add_theme_font_size_override("font_size", 13)
	badge_label.add_theme_color_override("font_color", COL_DIM)
	_world_badge.add_child(badge_label)

	# Combo counter (center-top, hidden until active)
	_combo_label = Label.new()
	_combo_label.text = ""
	_combo_label.position = Vector2(500, 80)
	_combo_label.size = Vector2(200, 50)
	_combo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_combo_label.add_theme_font_size_override("font_size", 28)
	_combo_label.add_theme_color_override("font_color", Color(1, 0.85, 0.3, 0.0))
	_combo_label.z_index = 20
	ui_layer.add_child(_combo_label)

	# Level timer (top-right area)
	_timer_label = Label.new()
	_timer_label.text = "0:00"
	_timer_label.position = Vector2(1040, 55)
	_timer_label.size = Vector2(120, 28)
	_timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_timer_label.add_theme_font_size_override("font_size", 14)
	_timer_label.add_theme_color_override("font_color", Color(0.45, 0.43, 0.4, 0.5))
	ui_layer.add_child(_timer_label)

	# Star rating preview (below shot counter)
	_star_nodes.clear()
	for i in 3:
		var star := Label.new()
		star.text = "☆"
		star.position = Vector2(24 + i * 28, 90)
		star.size = Vector2(28, 30)
		star.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		star.add_theme_font_size_override("font_size", 22)
		star.add_theme_color_override("font_color", Color(0.35, 0.33, 0.3, 0.4))
		ui_layer.add_child(star)
		_star_nodes.append(star)

	_refresh_star_preview(0)


func _update_hud_animation(delta: float) -> void:
	# Shot counter bounce effect
	if shot_label and _hud_shot_scale > 1.0:
		_hud_shot_scale = move_toward(_hud_shot_scale, 1.0, delta * 4.0)
		shot_label.scale = Vector2(_hud_shot_scale, _hud_shot_scale)

	# Level timer (only counts when playing)
	if level_started and not level_complete:
		_level_timer += delta
		if _timer_label:
			var mins := int(_level_timer) / 60
			var secs := int(_level_timer) % 60
			_timer_label.text = "%d:%02d" % [mins, secs]

	# Combo label fade
	if _combo_label:
		var target_a := 0.9 if _combo_count >= 2 else 0.0
		_hud_combo_alpha = move_toward(_hud_combo_alpha, target_a, delta * 3.0)
		_combo_label.add_theme_color_override("font_color",
			Color(1, 0.85, 0.3, _hud_combo_alpha))


func _refresh_star_preview(shots: int) -> void:
	var rating := _get_star_count(shots)
	for i in _star_nodes.size():
		var star: Label = _star_nodes[i]
		if i < rating:
			star.text = "★"
			star.add_theme_color_override("font_color", Color(1, 0.85, 0.3, 0.8))
		else:
			star.text = "☆"
			star.add_theme_color_override("font_color", Color(0.35, 0.33, 0.3, 0.4))


#SECTION_TUTORIAL

# ═══════════════════════════════════════════════════════════════
# TUTORIAL POPUP SYSTEM
# ═══════════════════════════════════════════════════════════════

const TUTORIAL_MESSAGES = [
	{"text": "Click near the ball and drag to aim", "delay": 2.5, "duration": 5.0},
	{"text": "Release to launch! Drag further for more power", "delay": 0.5, "duration": 4.5},
	{"text": "The green ring shows your power level", "delay": 0.5, "duration": 4.0},
	{"text": "Reach the glowing goal to complete the level", "delay": 1.0, "duration": 5.0},
]

func _build_tutorial_system() -> void:
	_tutorial_popup = Control.new()
	_tutorial_popup.z_index = 15
	_tutorial_popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(_tutorial_popup)

	# Background panel
	var bg := ColorRect.new()
	bg.name = "BG"
	bg.size = Vector2(420, 60)
	bg.position = Vector2(390, 650)
	bg.color = Color(0.06, 0.08, 0.12, 0.85)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tutorial_popup.add_child(bg)

	# Left accent bar
	var accent := ColorRect.new()
	accent.size = Vector2(3, 60)
	accent.position = bg.position
	accent.color = COL_ACCENT
	accent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tutorial_popup.add_child(accent)

	# Icon
	var icon := Label.new()
	icon.name = "Icon"
	icon.text = "💡"
	icon.position = bg.position + Vector2(12, 14)
	icon.size = Vector2(30, 30)
	icon.add_theme_font_size_override("font_size", 20)
	_tutorial_popup.add_child(icon)

	# Text label
	var txt := Label.new()
	txt.name = "Text"
	txt.text = ""
	txt.position = bg.position + Vector2(45, 8)
	txt.size = Vector2(360, 44)
	txt.add_theme_font_size_override("font_size", 15)
	txt.add_theme_color_override("font_color", COL_HINT)
	txt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tutorial_popup.add_child(txt)

	# Dismiss hint
	var dismiss := Label.new()
	dismiss.name = "Dismiss"
	dismiss.text = "click to dismiss"
	dismiss.position = bg.position + Vector2(310, 44)
	dismiss.size = Vector2(110, 16)
	dismiss.add_theme_font_size_override("font_size", 9)
	dismiss.add_theme_color_override("font_color", Color(0.4, 0.38, 0.35, 0.3))
	_tutorial_popup.add_child(dismiss)

	_tutorial_popup.modulate.a = 0.0
	_tutorial_popup.visible = false


func _show_tutorial(index: int) -> void:
	if index >= TUTORIAL_MESSAGES.size() or _tutorial_shown[index]:
		return
	_tutorial_shown[index] = true
	_tutorial_step = index

	var msg: Dictionary = TUTORIAL_MESSAGES[index]
	var txt: Label = _tutorial_popup.get_node("Text")
	txt.text = msg["text"]

	_tutorial_popup.visible = true
	_tutorial_popup.modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(_tutorial_popup, "modulate:a", 1.0, 0.4).set_ease(Tween.EASE_OUT)

	_tutorial_timer = msg["duration"]


func _dismiss_tutorial() -> void:
	if not _tutorial_popup.visible:
		return
	var tw := create_tween()
	tw.tween_property(_tutorial_popup, "modulate:a", 0.0, 0.3).set_ease(Tween.EASE_IN)
	tw.tween_callback(func() -> void: _tutorial_popup.visible = false)


func _update_tutorial(delta: float) -> void:
	if _tutorial_popup.visible and _tutorial_timer > 0:
		_tutorial_timer -= delta
		if _tutorial_timer <= 0:
			_dismiss_tutorial()
			# Queue next tutorial message
			if _tutorial_step + 1 < TUTORIAL_MESSAGES.size():
				var next_delay: float = TUTORIAL_MESSAGES[_tutorial_step + 1]["delay"]
				get_tree().create_timer(next_delay).timeout.connect(
					_show_tutorial.bind(_tutorial_step + 1)
				)


#SECTION_INTRO

# ═══════════════════════════════════════════════════════════════
# LEVEL INTRO SEQUENCE
# ═══════════════════════════════════════════════════════════════

var _intro_overlay: Control = null
var _intro_title: Label = null
var _intro_subtitle: Label = null
var _intro_world_icon: Label = null
var _intro_countdown: Label = null

func _start_level_intro() -> void:
	_intro_active = true
	_intro_timer = 0.0

	# Disable player input during intro
	if player:
		player.set_process_input(false)

	# Build intro overlay
	_intro_overlay = Control.new()
	_intro_overlay.z_index = 50
	_intro_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(_intro_overlay)

	# Dark backdrop
	var backdrop := ColorRect.new()
	backdrop.name = "Backdrop"
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.03, 0.05, 0.08, 0.92)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_intro_overlay.add_child(backdrop)

	# World icon
	_intro_world_icon = Label.new()
	_intro_world_icon.text = "🌿"
	_intro_world_icon.position = Vector2(530, 240)
	_intro_world_icon.size = Vector2(140, 60)
	_intro_world_icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_intro_world_icon.add_theme_font_size_override("font_size", 48)
	_intro_world_icon.modulate.a = 0.0
	_intro_overlay.add_child(_intro_world_icon)

	# Title
	_intro_title = Label.new()
	_intro_title.text = "World 1: %s" % WORLD_NAME
	_intro_title.position = Vector2(300, 310)
	_intro_title.size = Vector2(600, 60)
	_intro_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_intro_title.add_theme_font_size_override("font_size", 44)
	_intro_title.add_theme_color_override("font_color", COL_ACCENT)
	_intro_title.modulate.a = 0.0
	_intro_overlay.add_child(_intro_title)

	# Subtitle
	_intro_subtitle = Label.new()
	_intro_subtitle.text = "Level %d  •  Navigate through platforms to the goal" % LEVEL_NUM
	_intro_subtitle.position = Vector2(300, 375)
	_intro_subtitle.size = Vector2(600, 30)
	_intro_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_intro_subtitle.add_theme_font_size_override("font_size", 16)
	_intro_subtitle.add_theme_color_override("font_color", COL_DIM)
	_intro_subtitle.modulate.a = 0.0
	_intro_overlay.add_child(_intro_subtitle)

	# Decorative line under title
	var line := ColorRect.new()
	line.name = "Line"
	line.position = Vector2(450, 370)
	line.size = Vector2(300, 1)
	line.color = Color(COL_ACCENT.r, COL_ACCENT.g, COL_ACCENT.b, 0.0)
	_intro_overlay.add_child(line)

	# Star requirement text
	var star_hint := Label.new()
	star_hint.name = "StarHint"
	star_hint.text = "★★★ %d shots  |  ★★ %d shots  |  ★ %d shots" % [STAR_3_MAX, STAR_2_MAX, STAR_1_MAX]
	star_hint.position = Vector2(350, 420)
	star_hint.size = Vector2(500, 25)
	star_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	star_hint.add_theme_font_size_override("font_size", 13)
	star_hint.add_theme_color_override("font_color", Color(0.6, 0.55, 0.4, 0.0))
	_intro_overlay.add_child(star_hint)

	# Animate sequence
	var tw := create_tween()
	tw.tween_property(_intro_world_icon, "modulate:a", 1.0, 0.5).set_delay(0.3)
	tw.tween_property(_intro_title, "modulate:a", 1.0, 0.5).set_delay(0.1)
	tw.tween_property(line, "color:a", 0.4, 0.4)
	tw.tween_property(_intro_subtitle, "modulate:a", 1.0, 0.4)
	tw.tween_property(star_hint, "theme_override_colors/font_color:a", 0.6, 0.4)
	tw.tween_interval(1.8)
	tw.tween_callback(_end_intro)


func _update_intro(delta: float) -> void:
	_intro_timer += delta


func _end_intro() -> void:
	_intro_active = false
	level_started = true

	# Enable player input
	if player:
		player.set_process_input(true)

	# Fade out overlay
	if _intro_overlay:
		var tw := create_tween()
		tw.tween_property(_intro_overlay, "modulate:a", 0.0, 0.6).set_ease(Tween.EASE_IN)
		tw.tween_callback(func() -> void:
			_intro_overlay.queue_free()
			_intro_overlay = null
		)

	# Show first tutorial after a brief pause
	get_tree().create_timer(TUTORIAL_MESSAGES[0]["delay"]).timeout.connect(
		_show_tutorial.bind(0)
	)


#SECTION_OUTRO

# ═══════════════════════════════════════════════════════════════
# LEVEL OUTRO / COMPLETION SEQUENCE
# ═══════════════════════════════════════════════════════════════

var _outro_overlay: Control = null

func _start_level_outro() -> void:
	_outro_active = true
	_outro_timer = 0.0
	level_complete = true

	# Dismiss any tutorial popup
	_dismiss_tutorial()

	# Build outro overlay
	_outro_overlay = Control.new()
	_outro_overlay.z_index = 50
	_outro_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(_outro_overlay)

	# Dark backdrop
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.03, 0.05, 0.08, 0.0)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_outro_overlay.add_child(backdrop)

	# "Level Complete!" header
	var header := Label.new()
	header.text = "Level Complete!"
	header.position = Vector2(350, 200)
	header.size = Vector2(500, 55)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 42)
	header.add_theme_color_override("font_color", COL_ACCENT)
	header.modulate.a = 0.0
	_outro_overlay.add_child(header)

	# Stats card background
	var card := ColorRect.new()
	card.position = Vector2(400, 280)
	card.size = Vector2(400, 260)
	card.color = Color(0.07, 0.09, 0.14, 0.0)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_outro_overlay.add_child(card)

	# Shot count stat
	var shots_text := Label.new()
	shots_text.text = "Shots Used"
	shots_text.position = Vector2(400, 290)
	shots_text.size = Vector2(400, 22)
	shots_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shots_text.add_theme_font_size_override("font_size", 14)
	shots_text.add_theme_color_override("font_color", COL_DIM)
	shots_text.modulate.a = 0.0
	_outro_overlay.add_child(shots_text)

	var shots_num := Label.new()
	var shot_count: int = player.shot_count if player else 0
	shots_num.text = str(shot_count)
	shots_num.position = Vector2(400, 312)
	shots_num.size = Vector2(400, 40)
	shots_num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	shots_num.add_theme_font_size_override("font_size", 36)
	shots_num.add_theme_color_override("font_color", COL_WARM)
	shots_num.modulate.a = 0.0
	_outro_overlay.add_child(shots_num)

	# Time stat
	var time_text := Label.new()
	time_text.text = "Time"
	time_text.position = Vector2(400, 365)
	time_text.size = Vector2(400, 22)
	time_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_text.add_theme_font_size_override("font_size", 14)
	time_text.add_theme_color_override("font_color", COL_DIM)
	time_text.modulate.a = 0.0
	_outro_overlay.add_child(time_text)

	var time_num := Label.new()
	var mins := int(_level_timer) / 60
	var secs := int(_level_timer) % 60
	time_num.text = "%d:%02d" % [mins, secs]
	time_num.position = Vector2(400, 385)
	time_num.size = Vector2(400, 35)
	time_num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_num.add_theme_font_size_override("font_size", 28)
	time_num.add_theme_color_override("font_color", COL_WARM)
	time_num.modulate.a = 0.0
	_outro_overlay.add_child(time_num)

	# Star rating — animated reveal
	var star_count := _get_star_count(shot_count)
	var star_y: float = 440.0
	for i in 3:
		var star := Label.new()
		star.name = "OutroStar%d" % i
		star.text = "★" if i < star_count else "☆"
		star.position = Vector2(540 + i * 40, star_y)
		star.size = Vector2(40, 50)
		star.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		star.add_theme_font_size_override("font_size", 36)
		var col := Color(1, 0.85, 0.3, 0.0) if i < star_count else Color(0.3, 0.28, 0.25, 0.0)
		star.add_theme_color_override("font_color", col)
		star.modulate.a = 0.0
		star.scale = Vector2(0.3, 0.3)
		star.pivot_offset = Vector2(20, 25)
		_outro_overlay.add_child(star)

	# Rating text
	var rating_lbl := Label.new()
	rating_lbl.text = _get_rating_text(shot_count)
	rating_lbl.position = Vector2(400, 495)
	rating_lbl.size = Vector2(400, 28)
	rating_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rating_lbl.add_theme_font_size_override("font_size", 18)
	rating_lbl.add_theme_color_override("font_color", Color(COL_ACCENT.r, COL_ACCENT.g, COL_ACCENT.b, 0.0))
	_outro_overlay.add_child(rating_lbl)

	# Continue prompt
	var continue_lbl := Label.new()
	continue_lbl.name = "Continue"
	continue_lbl.text = "Press ENTER for next level  •  R to retry"
	continue_lbl.position = Vector2(350, 555)
	continue_lbl.size = Vector2(500, 25)
	continue_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	continue_lbl.add_theme_font_size_override("font_size", 14)
	continue_lbl.add_theme_color_override("font_color", Color(0.5, 0.48, 0.45, 0.0))
	_outro_overlay.add_child(continue_lbl)

	# ── Animate the reveal sequence ──
	var tw := create_tween()
	tw.tween_property(backdrop, "color:a", 0.88, 0.5)
	tw.tween_property(header, "modulate:a", 1.0, 0.4)
	tw.tween_property(card, "color:a", 0.9, 0.3)
	tw.tween_property(shots_text, "modulate:a", 1.0, 0.25)
	tw.tween_property(shots_num, "modulate:a", 1.0, 0.3)
	tw.tween_property(time_text, "modulate:a", 1.0, 0.25)
	tw.tween_property(time_num, "modulate:a", 1.0, 0.3)

	# Stars pop-in one at a time
	for i in 3:
		var s: Label = _outro_overlay.get_node("OutroStar%d" % i)
		tw.tween_property(s, "modulate:a", 1.0, 0.2)
		tw.tween_property(s, "scale", Vector2(1.0, 1.0), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	tw.tween_property(rating_lbl, "theme_override_colors/font_color:a", 0.9, 0.3)
	tw.tween_property(continue_lbl, "theme_override_colors/font_color:a", 0.6, 0.4)


func _update_outro(delta: float) -> void:
	_outro_timer += delta


#SECTION_COMBO

# ═══════════════════════════════════════════════════════════════
# COMBO SYSTEM + FLOATING TEXT
# ═══════════════════════════════════════════════════════════════

func _register_bounce() -> void:
	_combo_count += 1
	_combo_timer = COMBO_WINDOW
	if _combo_count > _best_combo:
		_best_combo = _combo_count

	if _combo_count >= 2 and _combo_label:
		_combo_label.text = "%dx Bounce!" % _combo_count
		# Pop scale effect
		_combo_label.scale = Vector2(1.3, 1.3)
		_combo_label.pivot_offset = Vector2(100, 25)
		var tw := create_tween()
		tw.tween_property(_combo_label, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT)

	# Milestone celebration text
	if _combo_count == 3:
		_spawn_float_text("Nice combo!", player.global_position + Vector2(0, -60), Color(0.3, 0.9, 0.4))
	elif _combo_count == 5:
		_spawn_float_text("Amazing!", player.global_position + Vector2(0, -60), Color(1.0, 0.75, 0.2))


func _update_combo(delta: float) -> void:
	if _combo_timer > 0:
		_combo_timer -= delta
		if _combo_timer <= 0:
			_combo_count = 0
			if _combo_label:
				_combo_label.text = ""


func _spawn_float_text(text: String, world_pos: Vector2, color: Color) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.global_position = world_pos
	lbl.size = Vector2(200, 30)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 20)
	lbl.add_theme_color_override("font_color", color)
	lbl.z_index = 30
	lbl.pivot_offset = Vector2(100, 15)
	lbl.scale = Vector2(0.5, 0.5)
	add_child(lbl)

	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(lbl, "position:y", lbl.position.y - 80.0, 1.2).set_ease(Tween.EASE_OUT)
	tw.tween_property(lbl, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tw.tween_property(lbl, "modulate:a", 0.0, 0.8).set_delay(0.6)
	tw.chain().tween_callback(lbl.queue_free)


# ═══════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════

func _get_star_count(shots: int) -> int:
	if shots <= STAR_3_MAX:
		return 3
	elif shots <= STAR_2_MAX:
		return 2
	elif shots <= STAR_1_MAX:
		return 1
	else:
		return 0


func _get_rating_text(shots: int) -> String:
	match _get_star_count(shots):
		3: return "Perfect!"
		2: return "Great job!"
		1: return "Good"
		_: return "Keep trying!"


func _update_shot_display(count: int) -> void:
	if shot_label:
		shot_label.text = "Shots: %d" % count


#SECTION_SIGNALS

# ═══════════════════════════════════════════════════════════════
# SIGNAL HANDLERS
# ═══════════════════════════════════════════════════════════════

func _on_shot_fired(count: int) -> void:
	_update_shot_display(count)
	GameState.add_shots(1)

	# Shot counter bounce
	_hud_shot_scale = 1.25

	# Update star preview
	_refresh_star_preview(count)

	# Show tutorial about power ring on first shot
	if count == 1:
		if hint_label:
			var tw := create_tween()
			tw.tween_property(hint_label, "modulate:a", 0.0, 1.0)
		# Queue tutorial step 2
		if not _tutorial_shown[2]:
			get_tree().create_timer(1.5).timeout.connect(_show_tutorial.bind(2))


func _on_impact(speed: float) -> void:
	if speed > 100.0:
		_register_bounce()

	# Shake fireflies near impact
	if player:
		for ff in _fireflies:
			var dist := Vector2(ff["x"], ff["y"]).distance_to(player.global_position)
			if dist < 150.0:
				ff["vx"] += randf_range(-30, 30)
				ff["vy"] += randf_range(-30, 30)

	# Show goal tutorial if near goal
	if player and goal and not _tutorial_shown[3]:
		var dist_to_goal := player.global_position.distance_to(goal.global_position)
		if dist_to_goal < 300.0:
			_show_tutorial(3)


func _on_goal_reached() -> void:
	if level_complete:
		return
	GameState.levels_completed += 1
	_start_level_outro()


# ═══════════════════════════════════════════════════════════════
# RESTART & NEXT LEVEL
# ═══════════════════════════════════════════════════════════════

func _restart_level() -> void:
	if _restart_cooldown > 0:
		return
	_restart_cooldown = 0.5

	# Quick fade-out
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(overlay)

	var tw := create_tween()
	tw.tween_property(overlay, "color:a", 1.0, 0.25)
	tw.tween_callback(get_tree().reload_current_scene)


func _next_level() -> void:
	if _restart_cooldown > 0:
		return
	_restart_cooldown = 0.5

	# Smooth fade-out
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(overlay)

	var tw := create_tween()
	tw.tween_property(overlay, "color:a", 1.0, 0.35)
	tw.tween_callback(func() -> void:
		LevelManager.load_next_level()
	)


#SECTION_INPUT

# ═══════════════════════════════════════════════════════════════
# INPUT HANDLING
# ═══════════════════════════════════════════════════════════════

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				_restart_level()
			KEY_ENTER:
				if level_complete:
					_next_level()
			KEY_SPACE:
				# Dismiss tutorial popup
				if _tutorial_popup and _tutorial_popup.visible:
					_dismiss_tutorial()

	# Click to dismiss tutorial
	if event is InputEventMouseButton and event.pressed:
		if _tutorial_popup and _tutorial_popup.visible:
			_dismiss_tutorial()
