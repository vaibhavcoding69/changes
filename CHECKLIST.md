# Implementation Checklist

## ✅ Phase 1: Foundation (COMPLETED)

### Design Documentation
- [x] Create `plans/game_design.md` - Full game concept and architecture
- [x] Create `plans/narrative.md` - Complete story and dialogue
- [x] Create `plans/level_design.md` - Level layouts and puzzles
- [x] Create `plans/fourth_wall_catalog.md` - All meta tricks

### Project Structure
- [x] Initialize Godot 4 project
- [x] Create folder structure (scenes, scripts, shaders, assets)
- [x] Configure project.godot with autoloads
- [x] Create .gitignore
- [x] Create icon.svg

### Core Scripts
- [x] Implement `ball.gd` - Pull-and-shoot mechanic
- [x] Implement `camera_controller.gd` - Smooth follow + shake
- [x] Implement `level_manager.gd` autoload - Level progression
- [x] Implement `narrator.gd` autoload - Dialogue system
- [x] Implement `fourth_wall/fourth_wall_manager.gd` autoload
- [x] Implement `fourth_wall/death_tracker.gd` autoload
- [x] Create `level_template.gd` for new levels

### Visual Effects
- [x] Create `glitch.gdshader` - Chromatic aberration effect
- [x] Create `desaturate.gdshader` - Grayscale for depression
- [x] Create `invert.gdshader` - Color inversion for scare

### Documentation
- [x] Write PROJECT_SUMMARY.md
- [x] Write QUICKSTART.md
- [x] Write project/README.md
- [x] Write root readme.md

---

## 🚧 Phase 2: Content Creation (NEXT)

### Scene Setup
- [ ] Open project in Godot 4.2+
- [ ] Verify all autoloads load without errors
- [ ] Test ball.gd in a simple test scene
- [ ] Create ball.tscn scene with sprite and trajectory line
- [ ] Create camera_controller.tscn
- [ ] Create narrator_label.tscn UI overlay
- [ ] Create glitch_overlay.tscn with shader
- [ ] Create desaturate_overlay.tscn with shader

### Asset Integration
- [ ] Download Kenney.nl Abstract Platformer pack
- [ ] Download Roboto Mono font from Google Fonts
- [ ] Download ball sprite or create placeholder circle
- [ ] Download platform/wall textures
- [ ] Find 5 music tracks (one per act) from Incompetech
- [ ] Download SFX: bounce, shoot, collect, glitch from Freesound

### Level Building (14 levels total)
- [ ] Create prologue.tscn - Two balls together tutorial
- [ ] Create level_01.tscn - Empty Room (Denial start)
- [ ] Create level_02.tscn - The Hallway (cursor stutter)
- [ ] Create level_03.tscn - Waiting Room (circular design)
- [ ] Create level_04.tscn - Breakable (Anger start, screen shake)
- [ ] Create level_05.tscn - Error (fake error dialog)
- [ ] Create level_06.tscn - Branching Paths (Bargaining start)
- [ ] Create level_07.tscn - Memory Lane (window drift)
- [ ] Create level_08.tscn - [USERNAME] (heavy glitch)
- [ ] Create level_09.tscn - The Void (Depression start, heavy ball)
- [ ] Create level_10.tscn - Blackout (screen goes black)
- [ ] Create level_11.tscn - Release (Acceptance start)
- [ ] Create level_12.tscn - Forward (long platform + ghost ball)
- [ ] Create epilogue.tscn - Auto-scrolling ending

---

## 🎨 Phase 3: Polish & Integration

### Narrative Integration
- [ ] Add narrator lines to level_manager.gd per level
- [ ] Create memory_fragment.tscn collectible scene
- [ ] Add 12 memory texts to collectibles
- [ ] Implement memory popup overlay
- [ ] Test all dialogue displays correctly

### 4th Wall Testing
- [ ] Test cursor stutter on Level 2
- [ ] Test fake error on Level 5
- [ ] Test window drift on Level 6-7
- [ ] Test cursor hide on Level 7
- [ ] Test username reveal on Level 8
- [ ] Test window minimize on Level 9
- [ ] Test blackout overlay on Level 10
- [ ] Test death scare sequence (trigger after 10 deaths)
- [ ] Test ghost ball appearance on Level 12

### Audio Integration
- [ ] Add background music to each act (5 tracks)
- [ ] Add ball bounce SFX
- [ ] Add ball shoot SFX
- [ ] Add memory collect SFX
- [ ] Add glitch/anomaly SFX
- [ ] Add goal reached SFX

### Visual Polish
- [ ] Add particle effects to memory fragments
- [ ] Add glow effect to goal zones
- [ ] Implement fade_in/fade_out transitions in level_manager.gd
- [ ] Add act title cards between acts
- [ ] Test color grading per act (red tint, grayscale, etc.)
- [ ] Add trail effect to ball (optional)

---

## 🎯 Phase 4: Menus & UX

### Main Menu
- [ ] Create main_menu.tscn
- [ ] Add "Start" button
- [ ] Add "Quit" button
- [ ] Add subtle content warning about grief themes
- [ ] Set as main scene in project.godot

### Pause System
- [ ] Implement pause menu (ESC key)
- [ ] Add "Resume" button
- [ ] Add "Restart Level" button
- [ ] Add "Main Menu" button

### HUD Elements
- [ ] Create HUD.tscn
- [ ] Add death counter display (small, corner)
- [ ] Add memory counter (X/12)
- [ ] Optional: Add timer display

---

## 🔧 Phase 5: Tuning & Testing

### Physics Tuning
- [ ] Test ball mass=1.0 feels right in Denial/Acceptance
- [ ] Test ball mass=5.0 feels heavy in Depression
- [ ] Test max_power=2000 feels chaotic in Anger
- [ ] Adjust bounce coefficient if needed
- [ ] Adjust friction if ball rolls too much/little

### Difficulty Balancing
- [ ] Ensure Level 1-3 are easy (tutorial)
- [ ] Ensure Level 4-5 are medium (anger challenge)
- [ ] Ensure Level 6-8 are medium-hard (bargaining puzzles)
- [ ] Ensure Level 9-10 are hard (depression difficulty spike)
- [ ] Ensure Level 11-12 are easy (acceptance calm)

### Platform Testing
- [ ] Test on Linux (X11) - primary platform
- [ ] Test window manipulation works
- [ ] Test cursor warp works
- [ ] Test username reads correctly
- [ ] Optional: Test on Windows
- [ ] Optional: Test on Wayland (note limitations)

### Playtesting
- [ ] Full playthrough without dying
- [ ] Full playthrough collecting all memories
- [ ] Test death scare triggers correctly
- [ ] Test emotional arc is clear
- [ ] Test 20-30 minute completion time
- [ ] Get external feedback

---

## 📦 Phase 6: Export & Distribution

### Build Configuration
- [ ] Configure export presets in Godot
- [ ] Set appropriate window size (1280x720)
- [ ] Enable embed textures
- [ ] Set export filters for unused assets

### Export Builds
- [ ] Export Linux build (.x86_64)
- [ ] Test exported build (not just editor)
- [ ] Optional: Export Windows build (.exe)
- [ ] Optional: Export macOS build (.app)

### Distribution
- [ ] Create itch.io page (optional)
- [ ] Write game description
- [ ] Add screenshots
- [ ] Add content warning
- [ ] Upload builds

---

## ✨ Optional Enhancements

### Extra Features (If Time)
- [ ] Add achievements for collecting all memories
- [ ] Implement alternate ending for no-death run
- [ ] Add chapter select (after first completion)
- [ ] Create debug mode with level skip
- [ ] Add accessibility options (disable 4th wall, colorblind mode)

### Advanced 4th Wall
- [ ] Read desktop wallpaper and reference it
- [ ] Create fake files in game directory
- [ ] Monitor mouse idle time and comment
- [ ] Detect recording software and mention it
- [ ] Time-of-day specific dialogue

---

## 🎓 Learning Goals Achieved

Through this project, you will have:
- [x] Planned a complete narrative-driven game
- [x] Designed mechanics as emotional metaphor
- [x] Implemented physics-based controls
- [x] Created autoload singleton systems
- [x] Worked with Godot shaders
- [ ] Built 14 complete levels
- [ ] Integrated audio and visual assets
- [ ] Balanced difficulty across acts
- [ ] Exported a playable game

---

## 📊 Progress Tracker

**Current Phase**: 2 - Content Creation  
**Completion**: ~40% of total project

| Phase | Status | Progress |
|-------|--------|----------|
| 1. Foundation | ✅ Complete | 100% |
| 2. Content Creation | 🚧 In Progress | 0% |
| 3. Polish & Integration | ⏸️ Not Started | 0% |
| 4. Menus & UX | ⏸️ Not Started | 0% |
| 5. Tuning & Testing | ⏸️ Not Started | 0% |
| 6. Export | ⏸️ Not Started | 0% |

---

## 🚀 Next Immediate Steps

1. **Open project in Godot 4.2+**
   ```bash
   cd project
   godot project.godot
   ```

2. **Create ball.tscn scene**
   - Add RigidBody2D root
   - Attach ball.gd script
   - Add Sprite2D child (placeholder circle)
   - Add Line2D child (trajectory line)
   - Save as res://scenes/ball.tscn

3. **Create a simple test level**
   - New scene: Node2D
   - Add Marker2D (ball spawn)
   - Add StaticBody2D (platform)
   - Add Area2D (goal)
   - Attach level_template.gd
   - Test with F6

4. **Download first asset pack**
   - Visit kenney.nl/assets
   - Download "Abstract Platformer"
   - Extract to project/assets/sprites/
   - Import happens automatically in Godot

5. **Build Level 1**
   - Use layout from plans/level_design.md
   - Add narrator line from plans/narrative.md
   - Test completion

**Estimated time to first playable prototype**: 4-8 hours

---

*Everything is ready. Time to build.*
