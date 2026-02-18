extends Node

## Global game state manager - tracks progression, worlds, player data
## Auto-loads as singleton

# Current progression
var current_world: int = 0  # 0=tutorial, 1-5=worlds, 6=bonus
var current_level: int = 0

# Player data
var shots_total: int = 0
var stars_earned: int = 0
var levels_completed: int = 0

# Game state
var game_completed: bool = false

# Audio mute
var music_muted: bool = false
var sfx_muted: bool = false


func _ready() -> void:
	print("[GameState] Initialized")


func get_world_name() -> String:
	match current_world:
		0: return "Tutorial"
		1: return "Meadow"
		2: return "Volcano"
		3: return "Sky"
		4: return "Ocean"
		5: return "Space"
		6: return "Bonus"
		_: return "Unknown"


func next_world() -> void:
	current_world += 1
	current_level = 0
	print("[GameState] Advanced to World %d: %s" % [current_world, get_world_name()])


func next_level() -> void:
	current_level += 1
	levels_completed += 1


func add_shots(count: int) -> void:
	shots_total += count


func add_stars(count: int) -> void:
	stars_earned += count


func reset() -> void:
	current_world = 0
	current_level = 0
	shots_total = 0
	stars_earned = 0
	levels_completed = 0
	game_completed = false
	print("[GameState] Reset to initial state")
