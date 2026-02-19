extends StaticBody2D

## Moving platform that oscillates between two points

@export var move_distance: float = 200.0
@export var move_speed: float = 100.0
@export var horizontal: bool = true

var start_position: Vector2
var direction: int = 1

func _ready() -> void:
	start_position = position

func _physics_process(delta: float) -> void:
	var move_vector = Vector2.RIGHT if horizontal else Vector2.DOWN
	position += move_vector * direction * move_speed * delta
	
	if horizontal:
		if position.x > start_position.x + move_distance:
			direction = -1
		elif position.x < start_position.x - move_distance:
			direction = 1
	else:
		if position.y > start_position.y + move_distance:
			direction = -1
		elif position.y < start_position.y - move_distance:
			direction = 1