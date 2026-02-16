extends Node

## Global game state manager - tracks progression, acts, player data
## Auto-loads as singleton

# Current progression
var current_act: int = 0  # 0=prologue, 1-5=acts, 6=epilogue
var current_level: int = 0

# Player data
var shots_total: int = 0
var deaths: int = 0
var collected_memories: int = 0

# Game state
var game_completed: bool = false
var can_use_narrator: bool = true

# Audio mute
var music_muted: bool = false
var sfx_muted: bool = false


func _ready() -> void:
	print("[GameState] Initialized")


func get_act_name() -> String:
	match current_act:
		0: return "Prologue"
		1: return "Denial"
		2: return "Anger"
		3: return "Bargaining"
		4: return "Depression"
		5: return "Acceptance"
		6: return "Epilogue"
		_: return "Unknown"


func next_act() -> void:
	current_act += 1
	current_level = 0
	print("[GameState] Advanced to Act %d: %s" % [current_act, get_act_name()])


func next_level() -> void:
	current_level += 1


func add_shots(count: int) -> void:
	shots_total += count


func add_death() -> void:
	deaths += 1


func add_memory() -> void:
	collected_memories += 1


func reset() -> void:
	current_act = 0
	current_level = 0
	shots_total = 0
	deaths = 0
	collected_memories = 0
	game_completed = false
	print("[GameState] Reset to initial state")
