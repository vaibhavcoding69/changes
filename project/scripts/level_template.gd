extends Node2D

## Template for level scenes
## Handles ball spawning, goal setup, and level completion

@export var level_number: int = 1
@export var world_number: int = 1

var ball_scene: PackedScene = preload("res://scenes/ball.tscn")
var goal_scene: PackedScene = preload("res://scenes/goal.tscn")

@onready var ball_spawn: Marker2D = $BallSpawn
@onready var goal_zone: Area2D = $GoalZone

var ball: RigidBody2D
var camera: Camera2D

func _ready() -> void:
	# Spawn ball at spawn point
	if ball_spawn:
		ball = ball_scene.instantiate()
		ball.position = ball_spawn.position
		add_child(ball)
	
	# Set up goal
	if goal_zone:
		goal_zone.body_entered.connect(_on_goal_entered)
	
	# Set up camera to follow ball
	camera = Camera2D.new()
	var camera_script = load("res://scripts/camera.gd")
	camera.set_script(camera_script)
	if ball:
		camera.target = camera.get_path_to(ball)
	add_child(camera)

func _on_goal_entered(body: Node2D) -> void:
	if body == ball:
		# Level complete
		GameState.complete_level(world_number, level_number, ball.shot_count)
		LevelManager.load_next_level()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		# Reset ball position
		if ball:
			ball.position = ball_spawn.position
			ball.linear_velocity = Vector2.ZERO
			ball.shot_count = 0