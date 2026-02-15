extends Camera2D

## Camera that follows the player ball smoothly.

@export var target: NodePath
@export var smooth_speed: float = 5.0

var _target_node: Node2D


func _ready() -> void:
	if target:
		_target_node = get_node(target)


func _process(delta: float) -> void:
	if _target_node:
		global_position = global_position.lerp(_target_node.global_position, smooth_speed * delta)
