extends Node

## Level/Act progression manager
## Handles scene transitions and progression through the 5 acts

const ACT_SCENES = {
	0: "res://scenes/prologue.tscn",
	1: [
		"res://scenes/levels/act1_denial_level1.tscn",
		"res://scenes/levels/act1_denial_level2.tscn",
		"res://scenes/levels/act1_denial_level3.tscn",
	],
	2: [], # Anger (to be created)
	3: [], # Bargaining (to be created)
	4: [], # Depression (to be created)
	5: [], # Acceptance (to be created)
	6: "res://scenes/epilogue.tscn",
}


func load_act(act: int) -> void:
	"""Load the first level of an act"""
	GameState.current_act = act
	GameState.current_level = 0
	
	var scene_path: String
	if ACT_SCENES[act] is String:
		scene_path = ACT_SCENES[act]
	else:
		scene_path = ACT_SCENES[act][0]
	
	_load_scene(scene_path)


func load_next_level() -> void:
	"""Load the next level in the current act"""
	var act = GameState.current_act
	var level = GameState.current_level
	
	if ACT_SCENES[act] is String:
		# Single scene act (prologue/epilogue)
		if act == 0:
			load_act(1)
		elif act == 6:
			# Game complete
			GameState.game_completed = true
	else:
		# Multi-level act
		level += 1
		if level < len(ACT_SCENES[act]):
			GameState.current_level = level
			_load_scene(ACT_SCENES[act][level])
		else:
			# Move to next act
			load_act(act + 1)


func load_level_by_path(path: String) -> void:
	"""Directly load a scene by path"""
	_load_scene(path)


func _load_scene(path: String) -> void:
	"""Load a scene with fade transition"""
	# Optional: could add fade-to-black transition here
	print("[LevelManager] Loading: %s" % path)
	get_tree().change_scene_to_file(path)
