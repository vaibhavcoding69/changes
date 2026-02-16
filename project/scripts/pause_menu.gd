extends Control

## Pause menu controller for game pausing functionality

signal pause_toggled(is_paused: bool)

@onready var pause_panel: ColorRect = $PausePanel
@onready var resume_button: Button = $PausePanel/VBoxContainer/ResumeButton
@onready var restart_button: Button = $PausePanel/VBoxContainer/RestartButton
@onready var quit_button: Button = $PausePanel/VBoxContainer/QuitButton

var is_paused: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if pause_panel:
		pause_panel.visible = false
	
	if resume_button:
		resume_button.pressed.connect(_on_resume)
	if restart_button:
		restart_button.pressed.connect(_on_restart)
	if quit_button:
		quit_button.pressed.connect(_on_quit)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle_pause()
		get_tree().root.set_input_as_handled()


func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if pause_panel:
		pause_panel.visible = is_paused
		if is_paused:
			pause_panel.modulate.a = 0.0
			var tw: Tween = create_tween()
			tw.tween_property(pause_panel, "modulate:a", 1.0, 0.2)
			if resume_button:
				resume_button.grab_focus()
		else:
			pause_panel.visible = false
	
	pause_toggled.emit(is_paused)


func _on_resume() -> void:
	toggle_pause()


func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
