extends Node2D

## Prologue Scene - "Before"
## Two balls together, learning to move.
## Tutorial level with warm colors and simple objective.

@onready var player = $Player
@onready var companion = $Companion
@onready var goal = $Goal
@onready var goal_label = $UI/GoalLabel
@onready var hint_label = $UI/HintLabel

signal transition_to_act1

var companion_reached = false


func _ready() -> void:
	# Set initial state
	player.shot_count = 0
	
	# Animate entrance
	var tw: Tween = create_tween()
	tw.set_parallel(true)
	tw.tween_property($ColorRect, "color:a", 0.0, 0.0)  # Background already visible
	tw.tween_property(hint_label, "modulate:a", 1.0, 1.5).set_delay(1.0)
	
	# Check if companion reached
	goal.area_entered.connect(_on_goal_area_entered)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE and companion_reached:
			# Skip to act 1 (for testing)
			_transition_to_act1()


func _on_goal_area_entered(body: Node2D) -> void:
	if body.name == "Player" and not companion_reached:
		companion_reached = true
		_on_companion_reached()


func _on_companion_reached() -> void:
	hint_label.text = "You found them..."
	hint_label.modulate.a = 1.0
	
	# Animate companion glow
	var tw: Tween = create_tween()
	tw.tween_property(companion, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0)
	tw.tween_callback(func():
		# Brief pause then transition
		await get_tree().create_timer(2.0).timeout
		_transition_to_act1()
	)


func _transition_to_act1() -> void:
	# Fade to black
	var tw: Tween = create_tween()
	tw.tween_property($ColorRect, "color:a", 1.0, 2.0)
	tw.tween_callback(func():
		# Show final text
		var narrator = $UI/NarratorText
		narrator.visible = true
		narrator.modulate.a = 0.0
		var tw2: Tween = create_tween()
		tw2.tween_property(narrator, "modulate:a", 1.0, 1.5)
		tw2.tween_callback(func():
			await get_tree().create_timer(3.0).timeout
			# Transition to Act 1
			LevelManager.load_act(1)
		)
	)


func _process(delta: float) -> void:
	# Subtle background animation
	pass
