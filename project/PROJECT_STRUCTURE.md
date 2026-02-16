# Changes — Godot Project Structure

```
project/
├── project.godot          # Main Godot config (autoloads, settings, input)
│
├── scenes/                # All game scenes (visual + behavior)
│   ├── prologue.tscn      # "Before" intro scene (warm, two balls)
│   └── levels/
│       └── level_1.tscn   # Act 1, Level 1 (Denial - empty room)
│
└── scripts/               # All game logic (GDScript)
    ├── game_state.gd      # [AUTOLOAD] Global state (act, level, stats)
    ├── level_manager.gd   # [AUTOLOAD] Scene/level progression
    ├── prologue.gd        # Prologue scene controller
    ├── game_manager.gd    # Level UI & progression (used by all levels)
    ├── player.gd          # Ball physics & controls (pull-and-shoot)
    ├── camera.gd          # Camera follow with screen shake
    └── goal.gd            # Goal zone & celebration effects
```

## File Purposes

### Core Config
- **project.godot** — Engine settings, input maps, window size, autoloads

### Autoloads (Persist Across Scenes)
- **GameState** — Global progress tracker (current act/level, death count, shots, etc.)
- **LevelManager** — Handles scene transitions and progression through acts

### Scenes
- **prologue.tscn** — Intro scene (two balls, introduction to controls)
- **level_1.tscn** — First level of Act 1 (Denial)
  - 5 platforms, player, goal, UI, particles
  - Uses all the ball/camera/goal scripts

### Scripts

#### System Managers
- **game_state.gd** (Autoload)
  - Current act (0=prologue, 1-5=acts, 6=epilogue)
  - Current level within act
  - Player stats (total shots, deaths, memories collected)
  - Methods: `next_act()`, `next_level()`, `reset()`

- **level_manager.gd** (Autoload)
  - Map of available level scenes per act
  - Scene transitions with fade
  - Methods: `load_act(n)`, `load_next_level()`, `load_level_by_path()`

#### Scene Controllers
- **prologue.gd**
  - Intro scene behavior (two balls approaching each other)
  - Detects when player reaches companion
  - Fade-to-black sequence with "Then everything changed." text
  - Transitions to Act 1 via LevelManager

- **game_manager.gd**
  - Used by all level scenes
  - Tracks shot counter, level completion, rating system
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
Prologue (intro scene)
    ↓ (player reaches companion)
    ↓ (fade to black + "Then everything changed.")
    ↓
Act 1: Denial → Level 1
    ↓ (complete level)
    ↓
Act 1: Denial → Level 2
    ↓ (complete level)
    ↓
Act 1: Denial → Level 3
    ↓ (complete all levels in act)
    ↓
Act 2: Anger → Level 1
    ... (repeat for Acts 3, 4, 5)
    ↓
Epilogue (final scene)
    ↓
Game Complete
```

---

## How to Add a New Scene

1. **Create the scene file**: `scenes/levels/act1_denial_level2.tscn`
   - Add Player (RigidBody2D with player.gd script)
   - Add Goal (Area2D with goal.gd script)
   - Add platforms/obstacles (StaticBody2D)
   - Add Camera2D with camera.gd script
   - Add UI Canvas with labels (use game_manager.gd for controller)

2. **Register in level_manager.gd**:
   ```gdscript
   1: [
     "res://scenes/levels/act1_denial_level1.tscn",
     "res://scenes/levels/act1_denial_level2.tscn",  # ← Add here
     "res://scenes/levels/act1_denial_level3.tscn",
   ],
   ```

3. **Attach game_manager.gd to the level scene root** for progression handling

4. **Test**:
   - Run in editor (F5)
   - Use LevelManager to skip: `LevelManager.load_level_by_path("res://...")`

---

## Current Status

✅ **Completed**
- Prologue scene with intro mechanics
- Level 1 (Act 1 - Denial) with full gameplay
- Player with animations and particles
- Goal with celebration effects
- Camera with screen shake
- Global progression system (GameState, LevelManager)
- Scene auto-transitions

🚧 **To Build**
- Act 1 Level 2 & 3
- Acts 2-5 scenes (12 more levels)
- Epilogue scene
- 4th wall breaking effects
- Shaders (glitch, desaturate)
- Audio system

---

## Testing Shortcuts

In the Godot editor, you can:
- **F5** — Run from current scene
- **F6** — Run scene (without switching)
- Attach LevelManager calls to buttons to jump between scenes

Example in console:
```gdscript
LevelManager.load_act(2)  # Jump to Act 2
LevelManager.load_level_by_path("res://scenes/prologue.tscn")
```

---

## Notes

- All scenes properly inherit from the right node types (Node2D, RigidBody2D, Area2D)
- Autoloads persist across scene changes (GameState, LevelManager)
- Physics settings in project.godot: gravity=980, default 2D physics
- Input maps: click (mouse left), reset (R key), move (arrow keys for future)
