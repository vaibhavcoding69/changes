extends Node2D

## Level manager — handles UI updates, shot tracking, level completion, and restart.

@onready var player: RigidBody2D = $Player
@onready var goal: Area2D = $Goal
@onready var shot_label: Label = $UI/ShotCounter
@onready var hint_label: Label = $UI/HintLabel
@onready var complete_panel: ColorRect = $UI/LevelComplete
@onready var complete_label: Label = $UI/LevelComplete/CompletionLabel

var level_complete: bool = false
var _restart_cooldown: float = 0.0


func _ready() -> void:
	player.shot_fired.connect(_on_shot)
	goal.goal_reached.connect(_on_goal)
	if complete_panel:
		complete_panel.visible = false
	_update_shots(0)

	# Animate hint label entrance
	if hint_label:
		hint_label.modulate.a = 0.0
		var tw := create_tween()
		tw.tween_property(hint_label, "modulate:a", 0.8, 1.2).set_delay(0.5)


func _process(delta: float) -> void:
	if _restart_cooldown > 0:
		_restart_cooldown -= delta


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R and _restart_cooldown <= 0:
			_restart_level()
		elif event.keycode == KEY_ENTER and level_complete:
			_next_level()


func _on_shot(count: int) -> void:
	_update_shots(count)
	GameState.add_shots(1)
	# Fade out hint after first shot
	if count == 1 and hint_label:
		var tw := create_tween()
		tw.tween_property(hint_label, "modulate:a", 0.0, 1.5)


func _on_goal() -> void:
	level_complete = true
	if complete_panel:
		complete_panel.visible = true
		complete_panel.modulate.a = 0.0
		var tw := create_tween()
		tw.tween_property(complete_panel, "modulate:a", 1.0, 0.5) \
			.set_ease(Tween.EASE_OUT)
	if complete_label:
		var rating := _get_rating(player.shot_count)
		complete_label.text = "Level Complete!\n\nShots: %d\n%s\n\nPress ENTER for next level (R to restart)" \
			% [player.shot_count, rating]


func _update_shots(count: int) -> void:
	if shot_label:
		shot_label.text = "Shots: %d" % count


func _get_rating(shots: int) -> String:
	if shots <= 1:
		return "★★★  Perfect!"
	elif shots <= 3:
		return "★★☆  Great!"
	elif shots <= 5:
		return "★☆☆  Good"
	else:
		return "☆☆☆  Keep trying!"


func _restart_level() -> void:
	_restart_cooldown = 0.5
	# Brief fade-out before restart
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.anchors_preset = 15  # Full rect
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	$UI.add_child(overlay)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var tw := create_tween()
	tw.tween_property(overlay, "color:a", 1.0, 0.2)
	tw.tween_callback(get_tree().reload_current_scene)


func _next_level() -> void:
	_restart_cooldown = 0.5
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.anchors_preset = 15
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	$UI.add_child(overlay)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var tw := create_tween()
	tw.tween_property(overlay, "color:a", 1.0, 0.3)
	tw.tween_callback(func():
		LevelManager.load_next_level()
	)

