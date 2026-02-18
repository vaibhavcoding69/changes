extends Node

## Enhanced Global Game State Manager
## Tracks progression, collectibles, settings, with full save/load support
## Auto-loads as singleton "GameState"

const SAVE_FILE := "user://changes_save.dat"
const SETTINGS_FILE := "user://changes_settings.dat"
const SAVE_VERSION := 1

# --- Current Session State ---
var current_world: int = 0
var current_level: int = 0
var current_level_shots: int = 0

# --- Persistent Player Data ---
var total_shots: int = 0
var total_stars: int = 0
var total_score: int = 0
var levels_completed: int = 0
var game_completed: bool = false
var play_time_seconds: float = 0.0

# --- Level Progress ---
# Dictionary: "world_level" -> { "completed": bool, "best_shots": int, "stars": int, "time": float }
var level_progress: Dictionary = {}

# --- Collectibles ---
# Dictionary: collectible_id -> { "collected": bool, "points": int }
var collected_items: Dictionary = {}

# --- World Unlocks ---
var unlocked_worlds: Array[int] = [0, 1]  # Tutorial and Meadow unlocked by default

# --- Settings ---
var settings: Dictionary = {
	"music_volume": 0.7,
	"sfx_volume": 0.8,
	"master_volume": 1.0,
	"fullscreen": false,
	"vsync": true,
	"show_trajectory": true,
	"screen_shake": true,
}

# --- Signals ---
signal level_completed_signal(world: int, level: int, shots: int, stars: int)
signal world_unlocked(world: int)
signal collectible_collected(id: String, points: int)
signal progress_saved
signal progress_loaded
signal settings_changed


func _ready() -> void:
	print("[GameState] Initializing...")
	load_progress()
	load_settings()
	print("[GameState] Ready - World: %d, Level: %d" % [current_world, current_level])


func _process(delta: float) -> void:
	# Track play time
	play_time_seconds += delta


# ===========================================================================
#  WORLD/LEVEL MANAGEMENT
# ===========================================================================

func get_world_name(world: int = -1) -> String:
	if world < 0:
		world = current_world
	match world:
		0: return "Tutorial"
		1: return "Meadow"
		2: return "Volcano"
		3: return "Sky"
		4: return "Ocean"
		5: return "Space"
		6: return "Bonus"
		_: return "Unknown"


func get_world_color(world: int = -1) -> Color:
	if world < 0:
		world = current_world
	match world:
		0: return Color(0.95, 0.88, 0.72)  # Tutorial - Warm
		1: return Color(0.45, 0.82, 0.45)  # Meadow - Green
		2: return Color(1.0, 0.4, 0.2)     # Volcano - Red/Orange
		3: return Color(0.6, 0.85, 1.0)    # Sky - Light Blue
		4: return Color(0.2, 0.6, 0.9)     # Ocean - Deep Blue
		5: return Color(0.6, 0.3, 0.9)     # Space - Purple
		6: return Color(1.0, 0.85, 0.4)    # Bonus - Gold
		_: return Color.WHITE


func is_world_unlocked(world: int) -> bool:
	return world in unlocked_worlds


func unlock_world(world: int) -> void:
	if world not in unlocked_worlds:
		unlocked_worlds.append(world)
		unlocked_worlds.sort()
		world_unlocked.emit(world)
		save_progress()


func get_level_key(world: int, level: int) -> String:
	return "%d_%d" % [world, level]


# ===========================================================================
#  LEVEL COMPLETION
# ===========================================================================

func complete_level(world: int, level: int, shots: int) -> Dictionary:
	var key := get_level_key(world, level)
	var stars := calculate_stars(shots)
	var is_new_record := false
	
	# Update progress
	if not level_progress.has(key):
		level_progress[key] = {
			"completed": true,
			"best_shots": shots,
			"stars": stars,
			"times_played": 1,
		}
		levels_completed += 1
		is_new_record = true
	else:
		var existing = level_progress[key]
		existing["times_played"] += 1
		if shots < existing["best_shots"]:
			existing["best_shots"] = shots
			existing["stars"] = max(existing["stars"], stars)
			is_new_record = true
		elif stars > existing["stars"]:
			existing["stars"] = stars
	
	# Update totals
	total_shots += shots
	total_stars = _calculate_total_stars()
	
	# Check world unlock
	_check_world_unlocks(world, level)
	
	# Emit signal
	level_completed_signal.emit(world, level, shots, stars)
	
	# Auto-save
	save_progress()
	
	return {
		"shots": shots,
		"stars": stars,
		"is_new_record": is_new_record,
		"total_stars": total_stars,
	}


func calculate_stars(shots: int) -> int:
	if shots <= 1:
		return 3
	elif shots <= 3:
		return 2
	elif shots <= 5:
		return 1
	else:
		return 0


func get_star_rating_text(stars: int) -> String:
	match stars:
		3: return "★★★ Perfect!"
		2: return "★★☆ Great!"
		1: return "★☆☆ Good"
		_: return "☆☆☆ Keep trying!"


func _calculate_total_stars() -> int:
	var total := 0
	for key in level_progress:
		total += level_progress[key].get("stars", 0)
	return total


func _check_world_unlocks(completed_world: int, completed_level: int) -> void:
	# Unlock next world when completing last level of current world
	var levels_in_world := _get_levels_in_world(completed_world)
	if completed_level >= levels_in_world - 1:
		unlock_world(completed_world + 1)


func _get_levels_in_world(world: int) -> int:
	match world:
		0: return 1   # Tutorial
		1: return 3   # Meadow
		2: return 3   # Volcano
		3: return 3   # Sky
		4: return 3   # Ocean
		5: return 3   # Space
		6: return 1   # Bonus
		_: return 0


func get_level_progress(world: int, level: int) -> Dictionary:
	var key := get_level_key(world, level)
	if level_progress.has(key):
		return level_progress[key]
	return {"completed": false, "best_shots": 0, "stars": 0, "times_played": 0}


func is_level_completed(world: int, level: int) -> bool:
	return get_level_progress(world, level).get("completed", false)


# ===========================================================================
#  COLLECTIBLES
# ===========================================================================

func add_collectible(collectible_id: String, points: int) -> void:
	if not collected_items.has(collectible_id):
		collected_items[collectible_id] = {
			"collected": true,
			"points": points,
		}
		total_score += points
		collectible_collected.emit(collectible_id, points)
		save_progress()


func is_collectible_collected(collectible_id: String) -> bool:
	return collected_items.has(collectible_id) and collected_items[collectible_id].get("collected", false)


func get_collectible_count() -> int:
	return collected_items.size()


func add_stars(count: int) -> void:
	total_stars += count


func add_shots(count: int) -> void:
	total_shots += count


# ===========================================================================
#  SAVE/LOAD PROGRESS
# ===========================================================================

func save_progress() -> void:
	var save_data := {
		"version": SAVE_VERSION,
		"current_world": current_world,
		"current_level": current_level,
		"total_shots": total_shots,
		"total_stars": total_stars,
		"total_score": total_score,
		"levels_completed": levels_completed,
		"game_completed": game_completed,
		"play_time_seconds": play_time_seconds,
		"level_progress": level_progress,
		"collected_items": collected_items,
		"unlocked_worlds": unlocked_worlds,
	}
	
	var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		progress_saved.emit()
		print("[GameState] Progress saved")
	else:
		push_error("[GameState] Failed to save progress")


func load_progress() -> void:
	if not FileAccess.file_exists(SAVE_FILE):
		print("[GameState] No save file found, starting fresh")
		return
	
	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		if save_data is Dictionary:
			_apply_save_data(save_data)
			progress_loaded.emit()
			print("[GameState] Progress loaded")
	else:
		push_error("[GameState] Failed to load progress")


func _apply_save_data(data: Dictionary) -> void:
	current_world = data.get("current_world", 0)
	current_level = data.get("current_level", 0)
	total_shots = data.get("total_shots", 0)
	total_stars = data.get("total_stars", 0)
	total_score = data.get("total_score", 0)
	levels_completed = data.get("levels_completed", 0)
	game_completed = data.get("game_completed", false)
	play_time_seconds = data.get("play_time_seconds", 0.0)
	level_progress = data.get("level_progress", {})
	collected_items = data.get("collected_items", {})
	
	var worlds = data.get("unlocked_worlds", [0, 1])
	unlocked_worlds.clear()
	for w in worlds:
		unlocked_worlds.append(w)


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
		print("[GameState] Save file deleted")
	reset()


# ===========================================================================
#  SETTINGS
# ===========================================================================

func save_settings() -> void:
	var file := FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	if file:
		file.store_var(settings)
		file.close()
		print("[GameState] Settings saved")


func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE):
		return
	
	var file := FileAccess.open(SETTINGS_FILE, FileAccess.READ)
	if file:
		var loaded_settings = file.get_var()
		file.close()
		
		if loaded_settings is Dictionary:
			for key in loaded_settings:
				settings[key] = loaded_settings[key]
			_apply_settings()
			print("[GameState] Settings loaded")


func _apply_settings() -> void:
	# Apply fullscreen
	if settings.get("fullscreen", false):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Apply vsync
	if settings.get("vsync", true):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	settings_changed.emit()


func set_setting(key: String, value) -> void:
	settings[key] = value
	_apply_settings()
	save_settings()


func get_setting(key: String, default = null):
	return settings.get(key, default)


# ===========================================================================
#  RESET
# ===========================================================================

func reset() -> void:
	current_world = 0
	current_level = 0
	current_level_shots = 0
	total_shots = 0
	total_stars = 0
	total_score = 0
	levels_completed = 0
	game_completed = false
	play_time_seconds = 0.0
	level_progress.clear()
	collected_items.clear()
	unlocked_worlds = [0, 1]
	print("[GameState] Reset to initial state")


func reset_level() -> void:
	current_level_shots = 0


# ===========================================================================
#  STATISTICS
# ===========================================================================

func get_statistics() -> Dictionary:
	return {
		"total_shots": total_shots,
		"total_stars": total_stars,
		"total_score": total_score,
		"levels_completed": levels_completed,
		"collectibles_found": collected_items.size(),
		"worlds_unlocked": unlocked_worlds.size(),
		"play_time": _format_play_time(),
		"average_shots_per_level": total_shots / max(levels_completed, 1),
	}


func _format_play_time() -> String:
	var hours := int(play_time_seconds / 3600)
	var minutes := int(fmod(play_time_seconds, 3600) / 60)
	var seconds := int(fmod(play_time_seconds, 60))
	
	if hours > 0:
		return "%d:%02d:%02d" % [hours, minutes, seconds]
	else:
		return "%d:%02d" % [minutes, seconds]
