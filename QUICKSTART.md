# Changes - Quick Start Guide

## Setup Instructions

### 1. Install Godot 4.2+

**Linux (Ubuntu/Debian)**:
```bash
# Download Godot 4.2 (Standard edition)
wget https://github.com/godotengine/godot/releases/download/4.2-stable/Godot_v4.2-stable_linux.x86_64.zip

# Extract
unzip Godot_v4.2-stable_linux.x86_64.zip -d ~/godot

# Make executable
chmod +x ~/godot/Godot_v4.2-stable_linux.x86_64

# Optional: Create symlink
sudo ln -s ~/godot/Godot_v4.2-stable_linux.x86_64 /usr/local/bin/godot
```

**Alternative - Flatpak**:
```bash
flatpak install flathub org.godotengine.Godot
```

### 2. Open the Project

```bash
cd /workspaces/changes/project
godot project.godot
```

Or from Godot Project Manager:
- Click "Import"
- Navigate to `/workspaces/changes/project`
- Select `project.godot`
- Click "Import & Edit"

### 3. Project Structure at a Glance

```
project/
├── scripts/          ← All GDScript files (autoloads, ball, camera, etc.)
├── scenes/           ← .tscn scene files (levels, UI, effects)
├── shaders/          ← .gdshader files (glitch, desaturate, invert)
└── assets/           ← Sprites, audio, fonts (populate with free assets)
```

## Creating Your First Level

### Option 1: Use the Editor

1. In Godot, create a new scene: **Scene → New Scene**
2. Add root node: **Node2D** (rename to "Level01")
3. Add child nodes:
   - **Marker2D** (rename to "BallSpawn") - position where ball starts
   - **Area2D** (rename to "GoalZone") - goal to reach
     - Add child **CollisionShape2D** with RectangleShape2D
   - **StaticBody2D** (rename to "Platform") - add to group "platform"
     - Add child **CollisionShape2D** with RectangleShape2D
     - Add child **ColorRect** for visual (size to match collision)

4. Attach script `res://scripts/level_template.gd` to root node
5. Save as `res://scenes/levels/level_01.tscn`

### Option 2: Minimal Scene Template

Create a `.tscn` file manually (text editor):

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/level_template.gd" id="1"]

[node name="Level01" type="Node2D"]
script = ExtResource("1")
level_number = 1

[node name="BallSpawn" type="Marker2D" parent="."]
position = Vector2(100, 500)

[node name="GoalZone" type="Area2D" parent="."]
position = Vector2(1100, 500)

[node name="CollisionShape2D" type="CollisionShape2D" parent="GoalZone"]
# TODO: Add shape resource

[node name="Platform" type="StaticBody2D" parent="." groups=["platform"]]
position = Vector2(640, 600)

[node name="CollisionShape2D" type="CollisionShape2D" parent="Platform"]
# TODO: Add shape resource
```

## Testing the Ball Mechanic

1. Create a simple test scene with:
   - A platform (StaticBody2D)
   - Ball spawn point (Marker2D)
   - Goal zone (Area2D)

2. Run the scene (**F6** for current scene, **F5** for project)

3. **Controls**:
   - Click near ball to grab
   - Drag to aim (dotted line shows trajectory)
   - Release to shoot
   - Press **R** to restart level
   - Press **ESC** to pause

## Adding Assets

### Free Asset Sources

**Sprites** (from Kenney.nl):
```bash
# Download and extract to project/assets/sprites/
wget https://kenney.nl/content/3-assets/2-kenney-abstract-platformer/kenney_abstract-platformer.zip
```

**Fonts** (Google Fonts):
```bash
# Download Roboto Mono
cd project/assets/fonts/
wget https://github.com/google/fonts/raw/main/apache/robotomono/RobotoMono-Regular.ttf
```

**Audio** (from Freesound):
- Search for "bounce", "impact", "collect", "glitch"
- Download as .ogg or .wav
- Place in `project/assets/audio/sfx/`

### Using Assets in Godot

1. Import happens automatically when files are added to `assets/`
2. To use a sprite:
   ```gdscript
   sprite.texture = load("res://assets/sprites/ball.png")
   ```
3. To use a font in Label:
   - Select Label node
   - In Inspector → Theme Overrides → Fonts
   - Load `res://assets/fonts/RobotoMono-Regular.ttf`

## Autoload System

The game uses 2 autoloads (singletons) that are always available:

| Autoload | Purpose | Example Usage |
|----------|---------|---------------|
| **LevelManager** | Level progression | `LevelManager.load_next_level()` |
| **GameState** | Track progress | `GameState.current_world` |

These are configured in `project.godot` and load automatically.

## Next Steps

### Phase 1: Core Gameplay
- [x] Ball pull-shoot mechanic works
- [ ] Create 3 test levels to verify physics feel
- [ ] Tune power/mass parameters
- [ ] Add ball sprite and platform visuals

### Phase 2: Level Design
- [ ] Design and build all 14 levels (tutorial + 12 levels + bonus)
- [ ] Add collectible stars/coins
- [ ] Implement goal zones with transitions

### Phase 3: World Themes
- [ ] Meadow world (green, gentle)
- [ ] Volcano world (moving platforms, hazards)
- [ ] Sky world (wind mechanics, floating islands)
- [ ] Ocean world (currents, buoyancy)
- [ ] Space world (low gravity)

### Phase 4: Polish
- [ ] Download and integrate free audio
- [ ] Add particles for collectibles
- [ ] Create fade transitions between levels
- [ ] Add main menu and pause screen
- [ ] Export build and test

## Common Issues

### "Autoload script not found"
- Ensure all autoload scripts exist in `project/scripts/`
- Check `project.godot` autoload section has correct paths

### "Ball doesn't shoot"
- Check scene has correct script attached
- Check collision layers and masks

### Window or fullscreen issues
- Test in windowed mode first
- Check project.godot display settings

## Documentation

- **Full game design**: `/plans/game_design.md`
- **Level layouts**: `/plans/level_design.md`
- **API reference**: See Godot docs for RigidBody2D, Area2D

## Support

If you encounter issues:
1. Check Godot version (requires 4.2+)
2. Review console output in Godot (Output tab)
3. Verify file paths in scripts match project structure
4. Test on target platform (Linux recommended for development)

---

**Ready to start?**
1. Open project in Godot: `godot project.godot`
2. Create your first level scene
3. Test the ball mechanic
4. Build levels world by world

*Aim. Launch. Bounce. Repeat.*
