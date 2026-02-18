# Changes

> *A satisfying pull-and-shoot ball physics puzzle game.*

[![Godot Engine](https://img.shields.io/badge/Godot-4.2+-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/license-Educational-green.svg)](LICENSE)

---

## Overview

**Changes** is a cursor-controlled physics puzzle game where you launch a ball through creative obstacle courses. Master the pull-and-shoot mechanic, solve tricky level layouts, and aim for the fewest shots possible to earn a 3-star rating.

### Core Concept
- **Mechanic**: Pull-and-shoot ball control (like pool/billiards)
- **Theme**: Fun, colorful puzzle adventure
- **Style**: Minimalist abstract geometry with vibrant colors
- **Length**: 20-30 minutes (14 levels across 5 themed worlds)

### Themed Worlds
1. **Meadow** → Gentle rolling hills, easy introduction
2. **Volcano** → Fiery obstacles, moving platforms
3. **Sky** → Floating islands, wind mechanics
4. **Ocean** → Underwater physics, currents
5. **Space** → Low gravity, orbital puzzles

---

## 📦 What's In This Repository

### `/plans` - Design Documentation
- **[game_design.md](plans/game_design.md)** - Game concept, mechanics, architecture
- **[level_design.md](plans/level_design.md)** - Level layouts, puzzles, difficulty

### `/project` - Godot 4 Game Engine ✅ **FUNCTIONAL**
Complete working base plate:
- ✅ Ball pull-shoot mechanic (RigidBody2D physics)
- ✅ Camera system with smooth follow and shake
- ✅ Level manager with world progression
- ✅ Star rating system (based on shot count)
- ✅ Satisfying ball animations (squash/stretch, trail, particles)
- ✅ Goal zones with celebration effects

### Documentation
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete overview of what was built
- **[QUICKSTART.md](QUICKSTART.md)** - Setup and testing guide

---

## 🚀 Quick Start

### Prerequisites
- **Godot 4.2+** ([Download](https://godotengine.org/download))
- Linux/Windows/macOS

### Run the Project
```bash
# Clone this repository
git clone https://github.com/vaibhavcoding69/changes.git
cd changes

# Open in Godot
cd project
godot project.godot
```

### Test the Mechanics
1. Create a simple test level (see [QUICKSTART.md](QUICKSTART.md))
2. Add a ball spawn point and platform
3. Press **F6** to test
4. **Click near ball** → drag → release to shoot

---

## 🎮 Game Mechanics

### Pull-and-Shoot Ball Control
```
1. Click near ball (within 100px)
2. Drag to set angle and power
3. White line shows trajectory
4. Release to launch
5. Ball bounces realistically
```

### Star Rating System
Earn stars based on how few shots you use:
- ★★★ Perfect — 1 shot
- ★★☆ Great — 2-3 shots
- ★☆☆ Good — 4-5 shots
- ☆☆☆ Keep trying — 6+ shots

### World Variety
| World | Theme | Twist |
|-------|-------|-------|
| 1 | Meadow | Gentle intro, learn mechanics |
| 2 | Volcano | Moving platforms, lava hazards |
| 3 | Sky | Floating islands, wind gusts |
| 4 | Ocean | Underwater currents, buoyancy |
| 5 | Space | Low gravity, orbital paths |

---

## 🛠️ Current Status

### ✅ Completed
- [x] Complete design documentation
- [x] Godot project structure
- [x] Ball pull-shoot mechanic with animations
- [x] Camera controller with smooth follow and impact shake
- [x] Level manager with world progression
- [x] Star rating system
- [x] Goal zones with celebration particles
- [x] Level template system
- [x] Pause screen (ESC key)
- [x] Title screen with level select

### 🚧 Next Steps
- [ ] Create 14 level scenes across 5 worlds
- [ ] Download free assets (Kenney.nl, Freesound)
- [ ] Add world-specific obstacles (wind, lava, currents, low-gravity)
- [ ] Background music (5 tracks, one per world)
- [ ] Sound effects (bounce, launch, goal)
- [ ] Export builds for testing

---

## 📖 About the Game

You're a ball on a journey through colorful worlds. Each level is a physics puzzle — launch yourself toward the goal using as few shots as possible. The levels start simple but get creative fast: dodge moving platforms, ride wind currents, bounce off walls at just the right angle, and master tricky shots in low gravity.

It's easy to pick up, hard to master, and satisfying every time you nail a perfect shot.

> *"One more try..."*

---

## 🎨 Visual Style (To Be Implemented)

- **Minimalist geometry**: Circles, rectangles, simple shapes
- **Vibrant world colors**:
  - Meadow: Lush greens and warm yellows
  - Volcano: Deep reds and oranges
  - Sky: Bright blues and whites
  - Ocean: Teals and aquamarine
  - Space: Deep purple and starlight
- **Assets**: Use free libraries (Kenney.nl for sprites, Freesound for audio)

---

## 🔧 Technical Details

### Built With
- **Engine**: Godot 4.2
- **Language**: GDScript
- **Physics**: RigidBody2D with custom pull-shoot input

### Platform Compatibility
| Feature | Windows | macOS | Linux |
|---------|---------|-------|-------|
| Core gameplay | ✅ | ✅ | ✅ |
| Full physics | ✅ | ✅ | ✅ |
| Particles | ✅ | ✅ | ✅ |

---

## 📚 Documentation

- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - What was built and why
- **[QUICKSTART.md](QUICKSTART.md)** - Setup guide and testing
- **[plans/game_design.md](plans/game_design.md)** - Full design spec
- **[plans/level_design.md](plans/level_design.md)** - Level layouts

---

## 🙏 Credits

**Engine**: [Godot Engine](https://godotengine.org/)
**Inspired By**: Angry Birds, Golf It!, Desert Golfing, Cut the Rope

### Asset Sources (To Be Used)
- **Sprites**: [Kenney.nl](https://kenney.nl) (CC0)
- **Music**: [Incompetech](https://incompetech.com) (CC BY)
- **SFX**: [Freesound.org](https://freesound.org) (Various)

---

## 📄 License

Educational/personal project. External assets retain their original licenses.

---

## 🎯 Goals

This project explores:
- Physics-based puzzle design
- Satisfying game feel (juice, polish, feedback)
- Pull-and-shoot mechanics
- Level design across themed worlds
- Minimalist visual style

---

**Ready to build?** See [QUICKSTART.md](QUICKSTART.md) to get started.

**Want details?** See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for complete breakdown.

---

*Aim. Launch. Bounce. Repeat.*
