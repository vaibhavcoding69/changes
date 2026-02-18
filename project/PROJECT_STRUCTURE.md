# Changes — Godot Project Structure

```
project/
├── project.godot          # Main Godot config (autoloads, settings, input)
│
├── scenes/                # All game scenes (visual + behavior)
│   ├── prologue.tscn      # Tutorial intro scene (learn to shoot)
│   └── levels/
│       └── level_1.tscn   # World 1, Level 1 (Meadow)
│
└── scripts/               # All game logic (GDScript)
    ├── game_state.gd      # [AUTOLOAD] Global state (world, level, stats)
    ├── level_manager.gd   # [AUTOLOAD] Scene/level progression
    ├── prologue.gd        # Tutorial scene controller
    ├── game_manager.gd    # Level UI & progression (used by all levels)
    ├── player.gd          # Ball physics & controls (pull-and-shoot)
    ├── camera.gd          # Camera follow with screen shake
    └── goal.gd            # Goal zone & celebration effects
```

## File Purposes

### Core Config
- **project.godot** — Engine settings, input maps, window size, autoloads

### Autoloads (Persist Across Scenes)
- **GameState** — Global progress tracker (current world/level, shots, stars, etc.)
- **LevelManager** — Handles scene transitions and progression through worlds

### Scenes
- **prologue.tscn** — Tutorial scene (learn pull-and-shoot controls)
- **level_1.tscn** — First level of World 1 (Meadow)
  - 5 platforms, player, goal, UI, particles
  - Uses all the ball/camera/goal scripts

### Scripts

#### System Managers
- **game_state.gd** (Autoload)
  - Current world (0=tutorial, 1-5=worlds, 6=bonus)
  - Current level within world
  - Player stats (total shots, stars earned, levels completed)
  - Methods: `next_world()`, `next_level()`, `reset()`

- **level_manager.gd** (Autoload)
  - Map of available level scenes per world
  - Scene transitions
  - Methods: `load_world(n)`, `load_next_level()`, `load_level_by_path()`

#### Scene Controllers
- **prologue.gd**
  - Tutorial scene behavior (learn to aim and shoot)
  - Detects when player reaches the goal
  - Transitions to World 1 via LevelManager

- **game_manager.gd**
  - Used by all level scenes
  - Tracks shot counter, level completion, star rating system
  - Input: Enter = next level, R = restart
  - Calls LevelManager.load_next_level()

#### Mechanics
- **player.gd**
  - RigidBody2D ball with pull-and-shoot input
  - Physics: gravity, bounce, collision
  - Animations: squash/stretch, idle glow, trail
  - Particles: launch burst, impact cloud, trail effects
  - Emits: `shot_fired(count)`, `impact_occurred(speed)`

- **goal.gd**
  - Area2D that detects when player reaches it
  - Pulsing animation with rotating dashes
  - Celebration particles on completion
  - Emits: `goal_reached`

- **camera.gd**
  - Smooth follow camera with look-ahead
  - Screen shake on ball collision
  - Receives impact signals from player

---

## Game Flow

```
Tutorial (intro scene)
    ↓ (player reaches goal)
    ↓ (transition to World 1)
    ↓
World 1: Meadow → Level 1
    ↓ (complete level)
    ↓
World 1: Meadow → Level 2
    ↓ (complete level)
    ↓
World 1: Meadow → Level 3
    ↓ (complete all levels in world)
    ↓
World 2: Volcano → Level 1
    ... (repeat for Worlds 3, 4, 5)
    ↓
Bonus (final scene)
    ↓
Game Complete
```

---

## How to Add a New Scene

1. **Create the scene file**: `scenes/levels/world1_meadow_level2.tscn`
   - Add Player (RigidBody2D with player.gd script)
   - Add Goal (Area2D with goal.gd script)
   - Add platforms/obstacles (StaticBody2D)
   - Add Camera2D with camera.gd script
   - Add UI Canvas with labels (use game_manager.gd for controller)

2. **Register in level_manager.gd**:
   ```gdscript
   1: [
     "res://scenes/levels/world1_meadow_level1.tscn",
     "res://scenes/levels/world1_meadow_level2.tscn",  # ← Add here
     "res://scenes/levels/world1_meadow_level3.tscn",
   ],
   ```

3. **Attach game_manager.gd to the level scene root** for progression handling

4. **Test**:
   - Run in editor (F5)
   - Use LevelManager to skip: `LevelManager.load_level_by_path("res://...")`

---

## Current Status

✅ **Completed**
- Tutorial scene with intro mechanics
- Level 1 (World 1 - Meadow) with full gameplay
- Player with animations and particles
- Goal with celebration effects
- Camera with screen shake
- Global progression system (GameState, LevelManager)
- Scene auto-transitions

🚧 **To Build**
- World 1 Level 2 & 3
- Worlds 2-5 scenes (12 more levels)
- Bonus scene
- World-specific mechanics (wind, lava, currents, gravity)
- Audio system

---

## Testing Shortcuts

In the Godot editor, you can:
- **F5** — Run from current scene
- **F6** — Run scene (without switching)
- Attach LevelManager calls to buttons to jump between scenes

Example in console:
```gdscript
LevelManager.load_world(2)  # Jump to World 2
LevelManager.load_level_by_path("res://scenes/prologue.tscn")
```

---

## Notes

- All scenes properly inherit from the right node types (Node2D, RigidBody2D, Area2D)
- Autoloads persist across scene changes (GameState, LevelManager)
- Physics settings in project.godot: gravity=980, default 2D physics
- Input maps: click (mouse left), reset (R key), move (arrow keys for future)
