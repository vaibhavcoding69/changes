extends Control

## Title screen - level select hub
## Allows navigation to any available level/scene

const LEVELS = [
	{ "name": "Prologue", "path": "res://scenes/prologue.tscn", "act": "Prologue", "color": Color(0.95, 0.88, 0.72) },
	{ "name": "Level 1 – Denial", "path": "res://scenes/levels/level_1.tscn", "act": "Denial", "color": Color(0.55, 0.65, 0.78) },
]

var button_group: Array[Button] = []


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	# --- fullscreen dark background ---
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.09, 0.13, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# --- centred VBox container ---
	var wrapper := CenterContainer.new()
	wrapper.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(wrapper)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	wrapper.add_child(vbox)

	# --- title ---
	var title := Label.new()
	title.text = "Changes"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 72)
	title.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72))
	vbox.add_child(title)

	# --- subtitle ---
	var subtitle := Label.new()
	subtitle.text = "A game about grief, loss, and acceptance."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.58, 0.55))
	vbox.add_child(subtitle)

	# --- spacer ---
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 30)
	vbox.add_child(spacer)

	# --- level select header ---
	var header := Label.new()
	header.text = "Select Level"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 28)
	header.add_theme_color_override("font_color", Color(0.75, 0.73, 0.70))
	vbox.add_child(header)

	# --- level buttons ---
	for i in LEVELS.size():
		var info: Dictionary = LEVELS[i]
		var btn := Button.new()
		btn.text = info["name"]
		btn.custom_minimum_size = Vector2(360, 52)
		btn.add_theme_font_size_override("font_size", 20)

		# style overrides
		var style_normal := StyleBoxFlat.new()
		style_normal.bg_color = Color(0.15, 0.16, 0.22)
		style_normal.corner_radius_top_left = 8
		style_normal.corner_radius_top_right = 8
		style_normal.corner_radius_bottom_left = 8
		style_normal.corner_radius_bottom_right = 8
		style_normal.border_width_left = 2
		style_normal.border_color = info["color"]

		var style_hover := style_normal.duplicate()
		style_hover.bg_color = Color(0.2, 0.21, 0.28)

		var style_pressed := style_normal.duplicate()
		style_pressed.bg_color = Color(0.12, 0.13, 0.18)

		btn.add_theme_stylebox_override("normal", style_normal)
		btn.add_theme_stylebox_override("hover", style_hover)
		btn.add_theme_stylebox_override("pressed", style_pressed)
		btn.add_theme_color_override("font_color", info["color"])
		btn.add_theme_color_override("font_hover_color", Color.WHITE)

		btn.pressed.connect(_on_level_pressed.bind(i))
		vbox.add_child(btn)
		button_group.append(btn)

	# --- quit button ---
	var quit_spacer := Control.new()
	quit_spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(quit_spacer)

	var quit_btn := Button.new()
	quit_btn.text = "Quit"
	quit_btn.custom_minimum_size = Vector2(360, 44)
	quit_btn.add_theme_font_size_override("font_size", 18)

	var quit_style := StyleBoxFlat.new()
	quit_style.bg_color = Color(0.15, 0.12, 0.12)
	quit_style.corner_radius_top_left = 8
	quit_style.corner_radius_top_right = 8
	quit_style.corner_radius_bottom_left = 8
	quit_style.corner_radius_bottom_right = 8

	var quit_hover := quit_style.duplicate()
	quit_hover.bg_color = Color(0.25, 0.15, 0.15)

	quit_btn.add_theme_stylebox_override("normal", quit_style)
	quit_btn.add_theme_stylebox_override("hover", quit_hover)
	quit_btn.add_theme_color_override("font_color", Color(0.7, 0.4, 0.4))
	quit_btn.add_theme_color_override("font_hover_color", Color(1.0, 0.5, 0.5))
	quit_btn.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_btn)


func _on_level_pressed(index: int) -> void:
	var info: Dictionary = LEVELS[index]
	print("[TitleScreen] Loading: %s" % info["path"])
	get_tree().change_scene_to_file(info["path"])


func _on_quit_pressed() -> void:
	get_tree().quit()
