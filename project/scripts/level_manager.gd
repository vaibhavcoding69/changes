extends Node

## Level/World progression manager
## Handles scene transitions and progression through themed worlds

const WORLD_SCENES = {
	0: "res://scenes/tutorial.tscn",
	1: [
		"res://scenes/levels/world1_meadow_level1.tscn",
		"res://scenes/levels/world1_meadow_level2.tscn",
		"res://scenes/levels/world1_meadow_level3.tscn",
	],
	2: [
		"res://scenes/levels/world2_volcano_level1.tscn",
		"res://scenes/levels/world2_volcano_level2.tscn",
		"res://scenes/levels/world2_volcano_level3.tscn",
	],
	3: [
		"res://scenes/levels/world3_sky_level1.tscn",
		"res://scenes/levels/world3_sky_level2.tscn",
		"res://scenes/levels/world3_sky_level3.tscn",
	],
	4: [
		"res://scenes/levels/world4_ocean_level1.tscn",
		"res://scenes/levels/world4_ocean_level2.tscn",
		"res://scenes/levels/world4_ocean_level3.tscn",
	],
	5: [
		"res://scenes/levels/world5_space_level1.tscn",
		"res://scenes/levels/world5_space_level2.tscn",
		"res://scenes/levels/world5_space_level3.tscn",
	],
	6: "res://scenes/levels/bonus.tscn",
}


func load_world(world: int) -> void:
	"""Load the first level of a world"""
	GameState.current_world = world
	GameState.current_level = 0
	
	var scene_path: String
	if WORLD_SCENES[world] is String:
		scene_path = WORLD_SCENES[world]
	else:
		scene_path = WORLD_SCENES[world][0]
	
	_load_scene(scene_path)


func load_next_level() -> void:
	"""Load the next level in the current world"""
	var world = GameState.current_world
	var level = GameState.current_level
	
	if WORLD_SCENES[world] is String:
		# Single scene world (tutorial/bonus)
		if world == 0:
			load_world(1)
		elif world == 6:
			# Game complete
			GameState.game_completed = true
	else:
		# Multi-level world
		level += 1
		if level < len(WORLD_SCENES[world]):
			GameState.current_level = level
			_load_scene(WORLD_SCENES[world][level])
		else:
			# Move to next world
			load_world(world + 1)


func load_level_by_path(path: String) -> void:
	"""Directly load a scene by path"""
	_load_scene(path)


func _load_scene(path: String) -> void:
	"""Load a scene with transition"""
	print("[LevelManager] Loading: %s" % path)
	get_tree().change_scene_to_file(path)
