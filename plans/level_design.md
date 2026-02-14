# Changes - Level Design Document

## Design Principles

1. **Minimalism**: Levels are abstract spaces, not realistic environments
2. **Clarity**: Goal should always be visible (even if path is unclear)
3. **Mechanical Metaphor**: Layout reflects emotional state of each act
4. **Difficulty Curve**: Gentle — focus is on narrative, not challenge

---

## Level Layout Notation

```
[S] = Start (ball spawn point)
[G] = Goal zone
[P] = Platform (StaticBody2D)
[W] = Wall
[M] = Memory fragment collectible
[H] = Hazard (kill zone, spikes, etc.)
```

---

## Prologue: Before

**Dimensions**: 800x600px  
**Visual**: Warm golden background, soft lighting  
**Music**: Gentle piano melody

```
      [You]        [Other Ball]
       (S)              (●)
        |                |
    [==========P==========]
         Golden platform
```

**Objective**: Simply roll/shoot toward the other ball  
**No obstacles** — pure tutorial of pull-shoot mechanic  
**On contact**: Both balls pulse light → fade

---

## Act 1: Denial

### Level 1 - Empty Room

**Dimensions**: 1200x800px  
**Visual**: Muted blue-gray, simple geometric shapes  
**Ball Physics**: Standard (mass=1.0, power=1000)

```
    [S]
     ●
     
     
    [===P===]     [====P====]
    
    
                          [====P====]
                                      [G]
```

**Obstacles**: 3 static platforms, small gaps  
**Difficulty**: Very easy — teaching momentum and drag distance  
**Anomaly**: None  
**Memory**: Level 1 fragment on middle platform

---

### Level 2 - The Hallway

**Dimensions**: 2000x600px (horizontal level)  
**Visual**: Long narrow corridor

```
[S]                                                    [G]
 ●    [P]    [P]    [P]    [P]    [P]    [P]    [P]    □
 |____|  |____|  |____|  |____|  |____|  |____|  |____|
```

**Obstacles**: 7 platforms with small gaps between  
**Difficulty**: Easy — linear path, rhythm-based  
**Anomaly**: **Cursor stutter** (at midpoint, cursor jumps 10px randomly for 2 seconds)  
**Memory**: Level 2 fragment at 3rd platform

---

### Level 3 - Waiting Room

**Dimensions**: 1000x1000px  
**Visual**: Circular design

```
             [===P===]
            /         \
          [P]         [P]
          |             |
    [G]--[P]    [S]    [P]
          |      ●      |
          [P]         [P]
            \         /
             [===P===]
```

**Obstacles**: Circular platform arrangement  
**Difficulty**: Easy but confusing — multiple paths all lead back to start  
**Anomaly**: **Ball input delay** (1-second lag on mouse input, random)  
**Memory**: Level 3 fragment at top platform  
**Goal**: Break the circle, reach exit on left

---

## Act 2: Anger

### Level 4 - Breakable

**Dimensions**: 1400x900px  
**Visual**: Red tint, cracked textures  
**Ball Physics**: Overpowered (power=2000)

```
    [S]
     ●
     
    [====W====] <- Breakable wall (cracks on impact)
    
    [H] [H] [H] <- Spikes
    
    [====P====]
    
    [====W====] <- Breakable
                                [G]
                        [====P====]
```

**Obstacles**: Breakable walls, spike hazards  
**Difficulty**: Medium — overshooting is the challenge  
**Anomaly**: **Screen shake** on collision, **walls visibly crack**  
**Memory**: Level 4 fragment behind first wall

---

### Level 5 - Error

**Dimensions**: 1200x1000px  
**Visual**: Glitching red sprites

```
[S]
 ●
    [P]
           [P]  <- Very small platforms
    
          [M]
    
              [P]
    
                      [P]
                            [G]
```

**Obstacles**: Tiny platforms, requires precise power  
**Difficulty**: Medium-hard — overpowered ball + small targets  
**Anomaly**: **Fake OS error dialog** appears mid-level ("expected_person.exe not found")  
**Memory**: Level 5 fragment on middle platform

---

## Act 3: Bargaining

### Level 6 - Branching Paths

**Dimensions**: 1600x1200px  
**Visual**: Purple glitch effect, split paths

```
                    [P]==\
                          \
    [S]            [P]=====[P]====[G]
     ●            /
    [P]==[P]==[P]
              \
               [P]==\
                     \
                      [P]====[P]====[G]
```

**Obstacles**: Three paths (top, middle, bottom) that ALL converge at same goal  
**Difficulty**: Easy — illusion of choice  
**Anomaly**: **Window drift** (window position shifts 5px/sec slowly)  
**Memory**: Level 6 fragment at path split point

---

### Level 7 - Memory Lane

**Dimensions**: 1800x1000px  
**Visual**: Faded colors, nostalgic tone

```
[S]     [M]         [M]         [M]         [G]
 ●       ●           ●           ●           □
 [P]=====[P]========[P]=========[P]=========[P]
 
    Long bridge with 3 memory fragments
```

**Obstacles**: Linear path with memory collectibles  
**Difficulty**: Easy — narrative focus  
**Anomaly**: **Window drift continues**, **cursor vanishes briefly** (3 seconds)  
**Memory**: 3 fragments (Levels 7, 8, 9 memories)

---

### Level 8 - [USERNAME]

**Dimensions**: 1200x1200px  
**Visual**: Heavy glitch shader, chromatic aberration

```
        [P]     [P]
         \       /
    [S]   [P] [P]   [G]
     ●     \ | /     □
    [P]=====[P]=====[P]
```

**Obstacles**: Converging platforms, requires multi-shot strategy  
**Difficulty**: Medium — spatial puzzle  
**Anomaly**: **Username reveal**, **cursor disappears**, **heavy glitch**  
**Memory**: Level 8 fragment at center platform

---

## Act 4: Depression

### Level 9 - The Void

**Dimensions**: 2000x2000px (large, empty)  
**Visual**: Black background, minimal lighting  
**Ball Physics**: Heavy (mass=5.0)

```
[S]
 ●





            [P]  <- Tiny distant platform




                            [P]




                                        [G]
```

**Obstacles**: Very few platforms, lots of empty space  
**Difficulty**: Hard — heavy ball + long shots  
**Anomaly**: **Window minimizes** briefly then restores  
**Memory**: Level 9 fragment on middle platform (hard to reach)

---

### Level 10 - Blackout

**Dimensions**: 1400x1000px  
**Visual**: Starts normal, goes pitch black mid-level

```
    [S]
     ●
     
    [===P===]
    
    [====P====]  <- When ball lands here, screen goes BLACK
    
         ?      <- Player must shoot blind
         
    [====P====]  <- Screen returns here
    
                        [G]
```

**Obstacles**: Mid-level blackout (screen goes fully black for 5 seconds)  
**Difficulty**: Hard — requires memorization or luck  
**Anomaly**: **Full screen blackout** with text overlay  
**Memory**: Level 10 fragment before blackout zone

---

## Act 5: Acceptance

### Level 11 - Release

**Dimensions**: 1600x800px  
**Visual**: Soft colors returning, open sky background  
**Ball Physics**: Balanced (mass=1.0, power=1000)

```
[S]                                             [G]
 ●          [P]          [P]          [P]        □
[P]========[P+M]========[P]===========[P]========[P]
```

**Obstacles**: Simple linear path, wide platforms  
**Difficulty**: Easy — cathartic after difficulty spike  
**Anomaly**: None (calmness after chaos)  
**Memory**: Level 11 fragment on second platform

---

### Level 12 - Forward

**Dimensions**: 2400x600px (very long horizontal)  
**Visual**: Transitioning from gray to soft pastel, sunrise gradient

```
[S]                                                                    [G]
 ●                                                                      □
[P]=====================================================================[P]

             One long, unbroken platform
```

**Obstacles**: None — single long platform  
**Difficulty**: Trivial — narrative moment, not gameplay challenge  
**Anomaly**: **Ghost ball appears near goal**, fades after 3 seconds  
**Memory**: Level 12 fragment at 3/4 distance

**Special Event**: When ball reaches goal:
1. Ghost ball (semi-transparent) appears above goal
2. Hovers for 3 seconds
3. Fades out slowly
4. Narrator: *"Goodbye."*
5. Transition to Epilogue

---

## Epilogue: After

**Dimensions**: Infinite scroll (camera follows ball)  
**Visual**: Soft white/gold gradient, minimalist

```
                  ●  <- Ball (moves automatically)
[P]================================================================>
                  
              Infinite platform, ball auto-moves right
```

**Mechanics**: Ball has constant forward velocity, no player input  
**Camera**: Smoothly follows ball  
**Text**: Fades in/out periodically (see narrative.md)  
**Duration**: ~60 seconds of auto-scroll  
**End**: Fade to white → Credits

---

## Difficulty Tuning

### Easy Levels (Tutorial, Act 5)
- Large platforms (200-400px wide)
- Short gaps (50-100px)
- Forgiving landing zones
- Clear visual paths

### Medium Levels (Acts 1-3)
- Medium platforms (100-200px)
- Moderate gaps (100-150px)
- Some precision required
- Multiple path options

### Hard Levels (Act 4, some Act 2)
- Small platforms (50-100px)
- Large gaps (150-300px)
- Requires power/angle calculation
- Limited platforms (more void space)

---

## Hazard Design

### Spikes (Act 2 only)
- Triangle shapes, red color
- Instant death on contact
- Respawn at level start
- Increment death counter

### Kill Zones (All acts)
- Invisible Area2D below visible level
- If ball falls off screen → death
- Same respawn behavior

### Moving Platforms (Optional, Act 3)
- Use AnimatableBody2D
- Slow horizontal/vertical movement
- Adds timing challenge

---

## Memory Fragment Placement

**Rules**:
1. Always visible from start or early in level
2. Requires slight detour (not on critical path)
3. Safe to collect (not near hazards)
4. Glowing particle effect for visibility

**Visual**:
- Small orb/sphere (use Godot's CSG or sprite from Kenney.nl)
- Pulsing glow shader
- Particle trail

---

## Level Transition Design

**Between Levels**:
1. Fade to black (0.5 seconds)
2. Level name appears (e.g., "Level 4 - Breakable")
3. Hold for 1 second
4. Fade in to new level (0.5 seconds)

**Between Acts**:
1. Fade to black (1 second)
2. Act title (e.g., "Act 2: Anger")
3. Visual motif (red wash, grayscale, etc.)
4. Hold for 2 seconds
5. Fade to first level of act

---

## Camera Design

**Default Behavior**:
- **Smooth follow**: Camera lerps to ball position (weight=0.1)
- **Zoom**: 1.0x (can zoom out to 0.8x for large levels)
- **Bounds**: Clamped to level TileMap/boundaries

**Special Behaviors**:
- **Shake** (Act 2): On collision, offset camera ±10px for 0.2 seconds
- **Drift** (Act 3): Slowly pan away from ball (5px/sec), then snap back
- **Zoom out** (Act 4): Gradual zoom to 0.7x to emphasize void

---

## Accessibility Considerations

1. **Trajectory preview**: Always show Line2D path while dragging
2. **Goal highlight**: Goal zone glows/pulses
3. **Restart option**: Press R to restart level at any time
4. **Checkpoints**: Each level is a checkpoint (no mid-level checkpoints)
5. **Death counter visible**: Small HUD element shows deaths (for scare trigger)

---

## Placeholder Asset Usage

**From Kenney.nl**:
- **Platformer Pack**: Use colored rectangles for platforms
- **Abstract Platformer**: Circles, geometric shapes for ball/collectibles
- **UI Pack**: Goal markers, HUD elements

**Built-in Godot**:
- **ColorRect**: Solid color platforms (temp)
- **CSGSphere**: 3D-to-2D sprite for ball
- **Polygon2D**: Custom platform shapes

**Colors**:
- Ball: White/light gray
- Platforms (Act 1): Blue-gray `#7F8C9A`
- Platforms (Act 2): Red `#D94848`
- Platforms (Act 3): Purple `#9448D9`
- Platforms (Act 4): Dark gray `#2E2E2E`
- Platforms (Act 5): Soft blue `#A8D8EA`
- Goal: Green `#48D97C` (pulsing glow)

---

## Level Sequencing

1. **Prologue** → Act 1 Start
2. **Level 1** → Level 2
3. **Level 2** → Level 3
4. **Level 3** → Act 2 Transition → Level 4
5. **Level 4** → Level 5
6. **Level 5** → Act 3 Transition → Level 6
7. **Level 6** → Level 7
8. **Level 7** → Level 8
9. **Level 8** → Act 4 Transition → Level 9
10. **Level 9** → Level 10
11. **Level 10** → Act 5 Transition → Level 11
12. **Level 11** → Level 12
13. **Level 12** → Epilogue
14. **Epilogue** → Credits → Main Menu

---

## Testing Checklist

- [ ] All levels are completable without dying
- [ ] Goal zones trigger level transitions
- [ ] Memory fragments collect correctly
- [ ] Death zones respawn ball at start
- [ ] Ball physics feel consistent (except intentional act changes)
- [ ] Camera stays in bounds
- [ ] Trajectory preview renders correctly
- [ ] No soft-locks or unreachable areas
