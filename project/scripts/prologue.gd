extends Node2D

## Tutorial Scene
## Learn the basics: aim, shoot, reach the goal.
## Simple level with warm colors and clear objective.

@onready var player = $Player
@onready var goal = $Goal
@onready var hint_label = $UI/HintLabel

var goal_reached_flag = false


func _ready() -> void:
	# Set initial state
	player.shot_count = 0
	
	# Animate entrance
	var tw: Tween = create_tween()
	tw.set_parallel(true)
	tw.tween_property($ColorRect, "color:a", 0.0, 0.0)  # Background already visible
	tw.tween_property(hint_label, "modulate:a", 1.0, 1.5).set_delay(1.0)
	
	# Check if goal reached
	goal.area_entered.connect(_on_goal_area_entered)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE and goal_reached_flag:
			# Skip to world 1 (for testing)
			_transition_to_world1()


func _on_goal_area_entered(body: Node2D) -> void:
	if body.name == "Player" and not goal_reached_flag:
		goal_reached_flag = true
		_on_goal_complete()


func _on_goal_complete() -> void:
	hint_label.text = "Nice shot! Let's go!"
	hint_label.modulate.a = 1.0
	
	# Brief pause then transition
	var tw: Tween = create_tween()
	tw.tween_interval(2.0)
	tw.tween_callback(_transition_to_world1)


func _transition_to_world1() -> void:
	# Fade to black then move to world 1
	var tw: Tween = create_tween()
	tw.tween_property($ColorRect, "color:a", 1.0, 1.0)
	tw.tween_callback(func():
		LevelManager.load_world(1)
	)


func _process(delta: float) -> void:
	# Subtle background animation
	pass
