# Changes

> *A 4th-wall-breaking ball physics game about grief, loss, and acceptance.*

[![Godot Engine](https://img.shields.io/badge/Godot-4.2+-blue.svg)](https://godotengine.org/)
[![License](https://img.shields.io/badge/license-Educational-green.svg)](LICENSE)

---

## Overview

**Changes** is a cursor-controlled physics game where you navigate a ball through increasingly surreal levels while processing the death of a loved one. The game follows the 5 stages of grief, using heavy 4th-wall breaking as a metaphor for how grief intrudes on normal life.

### Core Concept
- **Mechanic**: Pull-and-shoot ball control (like pool/billiards)
- **Theme**: Processing loss and learning to move forward
- **Style**: Minimalist abstract geometry with emotional color grading
- **Length**: 20-30 minutes (14 levels: prologue + 12 + epilogue)

### Emotional Journey
1. **Denial** → "They'll come back"
2. **Anger** → "Why did this happen?!"
3. **Bargaining** → "What if I could change it?"
4. **Depression** → "I can't go on"
5. **Acceptance** → "I'll carry them with me"

### 4th Wall Breaking
The game progressively breaks the 4th wall through:
- Visual glitches and screen distortion
- Window manipulation (shake, move, minimize)
- Cursor tricks (stutter, hide, lock)
- **Direct address** using your OS username
- Fake error dialogs and crash screens
- Death counter acknowledgment

---

## 📦 What's In This Repository

### `/plans` - Complete Design Documentation
Four comprehensive design documents (~15,000 words):
- **[game_design.md](plans/game_design.md)** - Full game concept, mechanics, architecture
- **[narrative.md](plans/narrative.md)** - Story, narrator lines, memory texts
- **[level_design.md](plans/level_design.md)** - Level layouts, puzzles, difficulty
- **[fourth_wall_catalog.md](plans/fourth_wall_catalog.md)** - All meta tricks + code

### `/project` - Godot 4 Game Engine ✅ **FUNCTIONAL**
Complete working base plate:
- ✅ Ball pull-shoot mechanic (RigidBody2D physics)
- ✅ Camera system with smooth follow and shake
- ✅ Level manager with emotional state progression
- ✅ Narrator system with typewriter effect
- ✅ 4th wall manager (window, cursor, system tricks)
- ✅ Death tracker with scare sequence
- ✅ Shaders (glitch, desaturate, invert)

### Documentation
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete overview of what was built
- **[QUICKSTART.md](QUICKSTART.md)** - Setup and testing guide
- **[project/README.md](project/README.md)** - In-depth project documentation

---

## 🚀 Quick Start

### Prerequisites
- **Godot 4.2+** ([Download](https://godotengine.org/download))
- Linux/Windows/macOS (some 4th wall features vary by platform)

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

### Emotional State System
Ball physics change per act:
- **Denial**: Normal (mass=1.0, power=1000)
- **Anger**: Overpowered (power=2000) - hard to control
- **Bargaining**: Normal but glitchy
- **Depression**: Heavy (mass=5.0) - hard to move
- **Acceptance**: Balanced return

### 4th Wall Escalation
| Level | Anomaly | Intensity |
|-------|---------|-----------|
| 1-3 | Subtle (cursor stutter, input delay) | 😌 Low |
| 4-5 | Screen shake, fake errors | 😠 Medium |
| 6-8 | Window drift, username reveal | 😰 High |
| 9-10 | Window minimize, blackouts | 😔 Very High |
| **Death Scare** | Window shake + fake crash + direct address | 😱 **EXTREME** |

---

## 🛠️ Current Status

### ✅ Completed
- [x] Complete design documentation (4 docs, 15k words)
- [x] Godot project structure
- [x] Ball pull-shoot mechanic
- [x] Camera controller with effects
- [x] All autoload systems (LevelManager, Narrator, FourthWall, DeathTracker)
- [x] 4th wall trick implementations
- [x] Shader suite (glitch, desaturate, invert)
- [x] Level template system
- [x] Pause screen (ESC key)

### 🚧 Next Steps
- [ ] Create 14 level scenes
- [ ] Download free assets (Kenney.nl, Freesound)
- [ ] Integrate narrator dialogue
- [ ] Add memory fragment collectibles
- [ ] Background music (5 tracks)
- [ ] Main menu
- [ ] Export builds for testing

---

## 📖 Story (No Spoilers)

You control a ball navigating abstract spaces. You started with someone - another ball - but they're gone. The game never says where they went. You wait. You rage. You bargain. You sink. You accept.

The game itself becomes aware of you - reading your name, moving windows, speaking directly. It's invasive, uncomfortable, just like grief.

By the end, you see them one last time - a ghost, a memory - and then they fade. You roll forward. Alone, but okay.

> *"Change is the only constant. And I'm still here."*

---

## 🎨 Visual Style (To Be Implemented)

- **Minimalist geometry**: Circles, rectangles, simple shapes
- **Emotional colors**:
  - Warm gold (prologue)
  - Blue-gray (denial)
  - Red (anger)
  - Purple glitch (bargaining)
  - Grayscale (depression)
  - Soft pastel (acceptance)
- **Assets**: Use free libraries (Kenney.nl for sprites, Freesound for audio)

---

## 🔧 Technical Details

### Built With
- **Engine**: Godot 4.2
- **Language**: GDScript
- **Physics**: RigidBody2D with custom pull-shoot input
- **4th Wall**: DisplayServer API, OS introspection, shaders

### Platform Compatibility
| Feature | Windows | macOS | Linux |
|---------|---------|-------|-------|
| Core gameplay | ✅ | ✅ | ✅ |
| Window tricks | ✅ | ✅ | ⚠️ WM-dependent |
| Cursor warp | ✅ | ✅ | ⚠️ X11 only |
| Username read | ✅ | ✅ | ✅ |

---

## 📚 Documentation

- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - What was built and why
- **[QUICKSTART.md](QUICKSTART.md)** - Setup guide and testing
- **[plans/game_design.md](plans/game_design.md)** - Full design spec
- **[plans/narrative.md](plans/narrative.md)** - Complete story script
- **[plans/level_design.md](plans/level_design.md)** - Level layouts
- **[plans/fourth_wall_catalog.md](plans/fourth_wall_catalog.md)** - All meta tricks

---

## 🙏 Credits

**Game Design**: Based on collaborative planning  
**Engine**: [Godot Engine](https://godotengine.org/)  
**Inspired By**: Gris, That Dragon Cancer, The Stanley Parable, OneShot

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
- Game mechanics as emotional metaphor
- 4th wall breaking as narrative device
- Physics-based puzzle design
- Minimalist storytelling
- Processing grief through interactive media

---

**Ready to build?** See [QUICKSTART.md](QUICKSTART.md) to get started.

**Want details?** See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for complete breakdown.

**Need help?** All design docs are in `/plans` with full implementation notes.

---

*A game about loss, change, and carrying on.*
