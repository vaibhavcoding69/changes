# Changes - Game Design Document

## Concept
A cursor-controlled ball physics puzzle game in Godot. Players use a pull-and-shoot mechanic (like pool/billiards) to navigate through increasingly creative levels across 5 themed worlds. Simple to learn, satisfying to master.

## Theme
A fun, colorful puzzle adventure. The joy of nailing the perfect shot, discovering creative solutions, and chasing 3-star ratings.

## Core Mechanic: Pull-and-Shoot Ball Control

### Physics
- **RigidBody2D** with **CircleShape2D** collider
- **PhysicsMaterial**: bounce=0.6, friction=0.3
- **CCD enabled** to prevent tunneling at high speeds
- **Gravity-based** 2D side-view physics

### Input
1. Click near ball (within 100px radius)
2. Drag to set angle and power
3. Release to launch (`apply_central_impulse`)
4. Ball freezes while dragging
5. Parabolic dot trajectory preview shows predicted path

### Tuning Parameters
```gdscript
max_power = 1600  # Maximum launch force
mass = 1.0        # Standard ball mass
drag_radius = 100 # Distance from ball to initiate drag
bounce = 0.6      # Bounce coefficient
friction = 0.3    # Surface friction
```

## World Structure: 5 Themed Worlds

### **Tutorial: Learn the Basics**
- **Scene**: Simple warm-colored space
- **Gameplay**: Reach the goal
- **Tutorial**: Learn pull-shoot mechanic
- **End**: Transition to World 1

---

### **World 1: Meadow (Levels 1–3)**
**Visual**: Lush greens, warm yellows, gentle rolling hills
**Ball Physics**: Standard (mass=1.0, power=1600)

**Level 1 - First Steps**
- Basic platform hopping
- Simple platforms, one goal
- Learn momentum and drag distance

**Level 2 - Angled Walls**
- Introduce wall bouncing
- Ricochet shots required
- Teaches banking angles

**Level 3 - Moving Platforms**
- First moving platform introduction
- Timing-based shots
- Platform moves slowly left-right

---

### **World 2: Volcano (Levels 4–5)**
**Visual**: Deep reds, oranges, glowing lava, cracks
**Ball Physics**: Standard with lava hazard zones

**Level 4 - Lava Floor**
- Platforms over lava (hazard = restart)
- Multiple safe platforms
- Screen shake on hard landings for juice

**Level 5 - Moving Bridges**
- Moving platforms over lava
- Timing precision required
- Multiple paths with different difficulty

---

### **World 3: Sky (Levels 6–8)**
**Visual**: Bright blues, whites, fluffy cloud platforms
**Ball Physics**: Slightly floaty (lower gravity optional)

**Level 6 - Floating Islands**
- Platforms suspended in sky
- Gaps require precise power control
- Open feel with lots of air

**Level 7 - Wind Gusts**
- Wind zones push ball mid-flight
- Must account for wind in trajectory
- Adds a physics layer to puzzle-solving

**Level 8 - Bouncy Clouds**
- Cloud platforms with high bounce coefficient
- Chain bounces to reach the goal
- Fun, springy feel

---

### **World 4: Ocean (Levels 9–10)**
**Visual**: Teals, aquamarine, underwater bubbles
**Ball Physics**: Slower movement, current zones

**Level 9 - Underwater Currents**
- Current zones push ball in specific directions
- Use currents to reach otherwise impossible goals
- Puzzle element: ride the flow

**Level 10 - Buoyancy**
- Ball floats upward in water zones
- Combine shooting with floating mechanics
- Creative path-finding

---

### **World 5: Space (Levels 11–12)**
**Visual**: Deep purple, starlight, nebula backgrounds
**Ball Physics**: Low gravity, longer hang time

**Level 11 - Zero-G**
- Reduced gravity makes shots travel further
- Must adjust power down
- Open arena with floating obstacles

**Level 12 - Orbital Challenge**
- Circular platforms with orbital-like paths
- Final challenge combining all learned skills
- Satisfying difficulty curve payoff

---

### **Bonus: Victory**
- Celebration scene
- Total stats: shots, stars, levels completed
- "Play again" or return to level select

---

## Star Rating System

**Per Level**:
- ★★★ Perfect — 1 shot
- ★★☆ Great — 2-3 shots
- ★☆☆ Good — 4-5 shots
- ☆☆☆ Keep trying — 6+ shots

**Global Tracking**:
- Total stars earned across all levels
- Total shots fired
- Levels completed
- Fastest completion (optional)

---

## Technical Architecture

### Autoload Singletons
1. **GameState** (`game_state.gd`)
   - Tracks current world, level, stats
   - Persists across scene changes
   
2. **LevelManager** (`level_manager.gd`)
   - Handles scene transitions
   - World/level progression logic
   - Methods: `load_world()`, `load_next_level()`

### Core Scripts
- **player.gd**: RigidBody2D with pull-shoot input, squash/stretch animations, trail
- **camera.gd**: Camera2D with smooth follow, impact screen shake
- **goal.gd**: Area2D with pulsing animation, celebration particles
- **game_manager.gd**: Level UI, shot tracking, star ratings, completion flow

### Level Structure
Each level is a scene (`level_XX.tscn`) containing:
- StaticBody2D platforms and walls
- Player (RigidBody2D with player.gd)
- Goal zone (Area2D with goal.gd)
- Camera (Camera2D with camera.gd)
- UI layer (managed by game_manager.gd)
- Optional: Moving platforms, hazard zones, wind zones

---

## Asset Libraries to Use

### Sprites
- **Kenney.nl** (free asset packs): Circles, platforms, UI elements
- **OpenGameArt.org**: Abstract shapes, particle effects
- **Placeholder**: Use Godot's built-in shapes with solid colors

### Audio
- **Freesound.org**: SFX (ball bounce, shoot, collect, goal)
- **Incompetech / Kevin MacLeod**: Upbeat music (CC BY)
- **Zapsplat**: Additional SFX library

### Fonts
- **Google Fonts**: 
  - Roboto Mono (UI, counters)
  - Press Start 2P (pixel-style if desired)

---

## Implementation Phases

### Phase 1: Foundation (Completed)
- [x] Create plans folder
- [x] Initialize Godot 4 project
- [x] Implement ball pull-shoot mechanic
- [x] Create camera controller
- [x] Build autoload singletons (GameState, LevelManager)

### Phase 2: Content
- [ ] Create Tutorial scene
- [ ] Build World 1 levels (1-3: Meadow)
- [ ] Build World 2 levels (4-5: Volcano)
- [ ] Build World 3 levels (6-8: Sky)
- [ ] Build World 4 levels (9-10: Ocean)
- [ ] Build World 5 levels (11-12: Space)
- [ ] Create Bonus/Victory scene

### Phase 3: World Mechanics
- [ ] Implement lava hazard zones
- [ ] Implement wind gust zones
- [ ] Implement water current zones
- [ ] Implement low gravity zones
- [ ] Implement moving platforms
- [ ] Implement bouncy surfaces

### Phase 4: Polish
- [ ] Add audio (music per world, SFX)
- [ ] Tune ball physics per world
- [ ] Add collectibles (coins/stars)
- [ ] Test full playthrough
- [ ] Export build

---

## Key Design Pillars

1. **Satisfying Feel**: Every shot should feel good — squash/stretch, particles, screen shake, trajectory preview
2. **Easy to Learn, Hard to Master**: Simple mechanic with deep skill ceiling
3. **Visual Variety**: Each world has a distinct color palette and aesthetic
4. **Fair Challenge**: Difficulty ramps smoothly, failures feel earned not cheap
5. **Replayability**: Star ratings encourage revisiting levels for perfect scores

---

## Success Criteria

- [ ] Pull-shoot mechanic feels satisfying and controllable
- [ ] Each world feels visually distinct and fresh
- [ ] Difficulty curve is smooth and fair
- [ ] Star ratings motivate replay
- [ ] Game is completable in 20-30 minutes
- [ ] Players say "one more try" frequently
