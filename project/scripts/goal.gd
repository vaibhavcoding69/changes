extends Area2D

## Goal zone — triggers level completion when the player ball enters.

signal goal_reached


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		goal_reached.emit()
		_show_goal_effect()


func _show_goal_effect() -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.5)
	await tween.finished
