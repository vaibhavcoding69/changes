# Changes - Game Design Document

## Concept
A cursor-controlled ball physics game in Godot about grief and loss. Players use a pull-and-shoot mechanic (like pool/billiards) to navigate through levels that progressively "break" as the game addresses the player directly through heavy 4th-wall intrusions.

## Theme
Processing the death of a loved one — the waiting, the hope they'll return, the realization they won't, and learning to move forward. The game never explicitly mentions death until near the end.

## Core Mechanic: Pull-and-Shoot Ball Control

### Physics
- **RigidBody2D** with **CircleShape2D** collider
- **PhysicsMaterial**: bounce=0.8, friction=0.1
- **CCD enabled** to prevent tunneling at high speeds
- **Gravity-based** 2D side-view physics

### Input
1. Click near ball (within 100px radius)
2. Drag to set angle and power
3. Release to launch (`apply_central_impulse`)
4. Ball freezes while dragging
5. Line2D shows trajectory preview (dashed line)

### Tuning Parameters
```gdscript
max_power = 1000  # Base (changes per emotional act)
mass = 1.0        # Base (increases in depression act)
drag_radius = 100 # Distance from ball to initiate drag
```

## Emotional Structure: 5 Acts = 5 Stages of Grief

### **Prologue: Before**
- **Scene**: Two balls together in warm, colorful space
- **Gameplay**: Simple goal — reach each other
- **Tutorial**: Learn pull-shoot mechanic
- **End**: Fade to black. Text: *"Then everything changed."*

---

### **Act 1: Denial (Levels 1–3)**
**Visual**: Slightly muted colors, "normal" world  
**Ball Physics**: Standard (mass=1.0, power=1000)  
**Narrator Tone**: Confused, in denial  

**Level 1 - Empty Room**
- Basic tutorial reinforcement
- Simple platforms, one goal
- Narrator: *"It's fine. Everything's fine."*

**Level 2 - The Hallway**
- Linear path with small gaps
- First anomaly: cursor stutters briefly
- Narrator: *"Where did you go?"*

**Level 3 - Waiting Room**
- Circular level, return to start
- Ball sometimes doesn't respond to input
- Narrator: *"You'll come back. You always do."*

---

### **Act 2: Anger (Levels 4–5)**
**Visual**: Red color wash, screen shakes, cracks appear  
**Ball Physics**: Overpowered (power=2000)  
**Narrator Tone**: Rage, frustration  

**Level 4 - Breakable**
- Walls crack when hit hard
- Screen shake on collision
- Narrator: *"WHY? Why did this happen?"*

**Level 5 - Error**
- Mid-level: Fake error dialog appears
  - *"Error: expected_person.exe not found"*
- Overshooting targets becomes a puzzle
- Narrator: *"This isn't fair! None of this is fair!"*

---

### **Act 3: Bargaining (Levels 6–8)**
**Visual**: Glitch effects, window drift, visual distortion  
**Ball Physics**: Standard but unpredictable  
**Narrator Tone**: Desperate, pleading  

**Level 6 - Branching Paths**
- Multiple routes that converge to same exit
- Illusion of choice
- Narrator: *"If I just try this way... maybe..."*

**Level 7 - Memory Lane**
- Memory fragments appear (collectibles)
- Each shows flashback text: *"We used to..."*
- Window starts drifting slowly
- Narrator: *"If I could just go back..."*

**Level 8 - [USERNAME]**
- Cursor disappears briefly (3 seconds)
- Game reads OS username, narrator addresses player:
  - *"[USERNAME], maybe if we both try..."*
- Heavy glitch shader
- Narrator: *"Please. I need them back."*

---

### **Act 4: Depression (Levels 9–10)**
**Visual**: Grayscale (desaturate shader), oppressive maze-like design  
**Ball Physics**: Heavy (mass=5.0), hard to move  
**Narrator Tone**: Silent or whispers  

**Level 9 - The Void**
- Dark, empty space
- Ball barely moves
- Long silences between narrator lines
- Window minimizes itself briefly, then restores
- Narrator (whisper): *"I'm so tired."*

**Level 10 - Blackout**
- Screen goes black mid-level
- Text appears in center: *"[USERNAME], are you still there?"*
- 5-second pause
- Level resumes
- Narrator (barely audible): *"...maybe it's time to stop fighting."*

---

### **Act 5: Acceptance (Levels 11–12)**
**Visual**: Color slowly returns (muted, not full saturation), open spaces  
**Ball Physics**: Balanced (mass=1.0, power=1000)  
**Narrator Tone**: Calm, reflective, sad but at peace  

**Level 11 - Release**
- Simple open space, minimal obstacles
- Ball moves lighter again
- Narrator: *"They're not coming back."*
- Pause.
- Narrator: *"...and that's okay."*

**Level 12 - Forward**
- Single long platform
- Goal at far end
- Narrator: *"I can't change what happened. But I can keep moving."*
- On reaching goal: Ghost ball appears briefly, fades
- Narrator: *"I'll carry you with me."*

---

### **Epilogue: After**
- Ball rolls forward automatically (no player control)
- Gentle music, soft light
- Camera follows peacefully
- Credits as text fragments
- Final text: *"Change is the only constant. And I'm still here."*

---

## Death Scare System

**Trigger**: Player dies **10+ times** in Act 3 or Act 4

**Sequence**:
1. Screen freezes, glitch shader at max intensity
2. Window shakes violently (10 rapid position changes)
3. Cursor warps to center, locks
4. Colors invert
5. Fake crash screen (blue background, monospace white text):
   ```
   FATAL ERROR 0x000000GRIEF
   
   [USERNAME], STOP.
   
   You're not supposed to give up.
   Not like this.
   Not after everything.
   ```
6. 5-second freeze
7. Fade to black
8. Game restarts at current level checkpoint
9. Music changes to ominous drone for remainder of act

**Purpose**: Heavy 4th-wall punishment for repeated failure — the game itself intervenes to prevent player from giving up, mirroring the grief journey.

---

## Memory Fragment System

**Count**: 12 memory fragments (1 per main level)  
**Type**: Collectible Area2D items  
**Visual**: Glowing orbs or abstract shapes (use placeholder sprites)

**On Collection**:
1. Screen fades slightly
2. Popup window appears (semi-transparent panel)
3. Text displays for 5 seconds:
   - *"We used to sit here for hours."*
   - *"You always laughed at that."*
   - *"I miss your voice."*
   - *"Remember when we..."*
   - *(etc. — 12 unique memories)*
4. Popup fades
5. Narrator reads memory aloud

**Purpose**: Optional deeper storytelling. Not required to progress, but reveals relationship with lost loved one.

---

## Technical Architecture

### Autoload Singletons
1. **LevelManager** (`level_manager.gd`)
   - Tracks current level, emotional act
   - Handles scene transitions
   - Stores global state (deaths, memories collected)
   
2. **Narrator** (`narrator.gd`)
   - Text queue system
   - Typewriter effect for RichTextLabel
   - Positioned bottom-center with semi-transparent background
   
3. **FourthWall** (`fourth_wall/fourth_wall_manager.gd`)
   - Coordinates all 4th-wall tricks
   - References sub-modules (window_tricks, glitch_effects, death_tracker)

### Core Scenes
- **ball.tscn**: RigidBody2D with pull-shoot script, trajectory Line2D
- **camera_controller.tscn**: Camera2D with smooth follow, shake function
- **glitch_overlay.tscn**: Full-screen ColorRect with glitch shader
- **narrator_label.tscn**: RichTextLabel for bottom-screen text
- **memory_popup.tscn**: Panel + Label for flashback display

### Level Structure
Each level is a scene (`level_XX.tscn`) containing:
- StaticBody2D platforms and walls (TileMap or individual polygons)
- Ball spawn point (Position2D marker)
- Goal zone (Area2D)
- Optional: Memory fragment collectible
- Optional: Hazards (kill zones, moving obstacles)

---

## Asset Libraries to Use

### Sprites
- **Kenney.nl** (free asset packs): Circles, platforms, UI elements
- **OpenGameArt.org**: Abstract shapes, particle effects
- **Placeholder**: Use Godot's built-in shapes (Circle, Rectangle) with solid colors

### Audio
- **Freesound.org**: SFX (ball bounce, shoot, collect, glitch)
- **Incompetech / Kevin MacLeod**: Ambient music (CC BY)
- **Zapsplat**: Additional SFX library

### Fonts
- **Google Fonts**: 
  - Roboto Mono (narrator, error messages)
  - Press Start 2P (pixel-style if desired)

---

## Implementation Phases

### Phase 1: Foundation (Current)
- [x] Create plans folder
- [ ] Initialize Godot 4 project
- [ ] Implement ball pull-shoot mechanic
- [ ] Create camera controller
- [ ] Build autoload singletons (LevelManager, Narrator)

### Phase 2: Core Systems
- [ ] Implement 4th-wall module (window tricks, glitch effects)
- [ ] Create glitch and desaturate shaders
- [ ] Build death tracker and scare system
- [ ] Implement memory fragment system

### Phase 3: Content
- [ ] Create Prologue scene
- [ ] Build Act 1 levels (1-3)
- [ ] Build Act 2 levels (4-5)
- [ ] Build Act 3 levels (6-8)
- [ ] Build Act 4 levels (9-10)
- [ ] Build Act 5 levels (11-12)
- [ ] Create Epilogue scene

### Phase 4: Polish
- [ ] Integrate all narrator lines
- [ ] Add audio (music per act, SFX)
- [ ] Tune ball physics per emotional act
- [ ] Test full playthrough
- [ ] Export build, test cross-platform

---

## Key Design Pillars

1. **Mechanical Metaphor**: Ball physics directly reflect emotional state (heavy = depression, overpowered = anger)
2. **Environmental Storytelling**: Level design reflects grief stages (circular denial level, branching bargaining paths, void-like depression spaces)
3. **4th-Wall as Desperation**: Anomalies escalate as narrator becomes more desperate to connect with player
4. **Subtlety Before Clarity**: Never say "death" until Act 5 — allow players to infer
5. **Player Agency in Spectacle**: Epilogue removes control — watching the ball move forward symbolizes acceptance and letting go

---

## Success Criteria

- [ ] Pull-shoot mechanic feels satisfying and controllable
- [ ] Emotional arc is clear through visual/mechanical changes
- [ ] 4th-wall tricks surprise but don't frustrate (except death scare)
- [ ] Story is understandable without explicit exposition
- [ ] Death scare is genuinely unsettling
- [ ] Epilogue provides closure and emotional resolution
- [ ] Game is completable in 20-30 minutes
