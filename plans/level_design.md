# Changes - Level Design Document

## Design Principles

1. **Minimalism**: Levels are abstract spaces, not realistic environments
2. **Clarity**: Goal should always be visible (even if path is unclear)
3. **Variety**: Each world introduces new mechanics and visual themes
4. **Difficulty Curve**: Smooth ramp — easy to learn, satisfying to master

---

## Level Layout Notation

```
[S] = Start (ball spawn point)
[G] = Goal zone
[P] = Platform (StaticBody2D)
[W] = Wall
[C] = Collectible (coin/star)
[H] = Hazard (kill zone, spikes, etc.)
[~] = Wind zone
[≈] = Water/current zone
```

---

## Tutorial: Learn the Basics

**Dimensions**: 800x600px
**Visual**: Warm golden background, soft lighting
**Music**: Cheerful upbeat melody

```
    [S]               [G]
     ●                 □
    [=========P=========]
       Simple platform
```

**Objective**: Shoot the ball to reach the goal
**No obstacles** — pure tutorial of pull-shoot mechanic
**Hint text**: "Click near the ball, drag to aim, release to shoot!"

---

## World 1: Meadow

### Level 1 - First Steps

**Dimensions**: 1200x800px
**Visual**: Lush green platforms, warm yellow background
**Ball Physics**: Standard (mass=1.0, power=1600)

```
    [S]
     ●


    [===P===]     [====P====]


                          [====P====]
                                      [G]
```

**Obstacles**: 3 static platforms, small gaps
**Difficulty**: Very easy — teaching momentum and drag distance
**Collectible**: Star on middle platform
**Par**: 2 shots

---

### Level 2 - Ricochet

**Dimensions**: 1200x800px
**Visual**: Green platforms, angled walls

```
    [S]
     ●     [W]
           [W]
    [===P===]
                [W]
                [W]
                     [====P====]
                                [G]
```

**Obstacles**: Angled walls for ricochet shots
**Difficulty**: Easy — introduces wall bouncing
**Collectible**: Star behind wall (requires bank shot)
**Par**: 2 shots

---

### Level 3 - Moving Target

**Dimensions**: 1400x800px
**Visual**: Green platforms, one platform moves left-right

```
[S]
 ●
 [===P===]

              [====P====] ← Moves left/right
              
                             [===P===]
                                        [G]
```

**Obstacles**: One moving platform
**Difficulty**: Easy-medium — introduces timing
**Collectible**: Star on the moving platform
**Par**: 3 shots

---

## World 2: Volcano

### Level 4 - Lava Floor

**Dimensions**: 1400x900px
**Visual**: Deep red/orange, glowing lava below, dark rocky platforms
**Ball Physics**: Standard

```
    [S]
     ●

    [====P====]        [====P====]

    [HHHHHHHHHHHHHHHHHHHHHHHHHHHH] ← Lava (hazard)

                [====P====]
                               [G]
```

**Obstacles**: Lava floor (instant restart), platforms above
**Difficulty**: Medium — falling into lava resets level
**Screen shake**: On hard landings for juice
**Collectible**: Star on lower platform near lava
**Par**: 3 shots

---

### Level 5 - Fire Bridge

**Dimensions**: 1400x1000px
**Visual**: Volcanic rock, moving bridges over lava

```
[S]
 ●
    [P]
        ←[P]→  ← Moving platform over lava

    [HHHHHHHHHHHHHHHHH] ← Lava

              ←[P]→  ← Another moving platform
                             
                             [P]
                                [G]
```

**Obstacles**: Moving platforms over lava
**Difficulty**: Medium — timing + precision
**Collectible**: Star requires landing on fast-moving platform
**Par**: 3 shots

---

## World 3: Sky

### Level 6 - Cloud Hop

**Dimensions**: 1600x1200px
**Visual**: Bright blue sky, white fluffy cloud platforms
**Ball Physics**: Slightly floaty feel

```
                        [P]
                   [P]       [G]
              [P]
    [S]  [P]
     ●
    [P]
```

**Obstacles**: Ascending cloud platforms, open air
**Difficulty**: Medium — vertical challenge
**Collectible**: Star on highest side platform
**Par**: 3 shots

---

### Level 7 - Wind Tunnel

**Dimensions**: 1800x800px
**Visual**: Blue sky with visible wind streaks

```
[S]                                               [G]
 ●                                                 □
[P]    [~~~>~~~]    [P]    [<~~~<~~~]    [P]       [P]
       Wind right          Wind left
```

**Obstacles**: Wind zones push ball mid-flight
**Difficulty**: Medium-hard — must account for wind
**Collectible**: Star in the wind zone (tricky to grab)
**Par**: 3 shots

---

### Level 8 - Trampoline

**Dimensions**: 1200x1200px
**Visual**: Blue sky, bouncy cloud platforms (yellow/springy)

```
                              [G]
                              
                        [B] ← Bouncy platform
                        
              [B] ← Bouncy
              
    [S]  [B] ← Bouncy
     ●
    [P]
```

**Obstacles**: Bouncy platforms (high bounce coefficient)
**Difficulty**: Medium — chain bounces upward
**Collectible**: Star off to the side, requires controlled bounce
**Par**: 2 shots

---

## World 4: Ocean

### Level 9 - Current Rider

**Dimensions**: 1600x1000px
**Visual**: Teal/aquamarine, underwater bubbles, wavy platforms
**Ball Physics**: Slower movement in water zones

```
[S]
 ●
[P]     [≈≈≈≈>≈≈≈≈]     Current pushes right
        
              [P]
              
        [≈≈≈≈<≈≈≈≈]     Current pushes left
        
[P]                      [G]
```

**Obstacles**: Water current zones push ball
**Difficulty**: Hard — use currents strategically
**Collectible**: Star against the current
**Par**: 4 shots

---

### Level 10 - Deep Dive

**Dimensions**: 1400x1400px
**Visual**: Deep ocean, darker teal, bubbles rising
**Ball Physics**: Float upward in water zones

```
[S]
 ●
[P]

    [≈≈≈≈≈≈≈≈≈≈]  ← Ball floats up in water
    [≈≈≈≈≈≈≈≈≈≈]
    
         [P]       ← Platform in water
         
    [≈≈≈≈≈≈≈≈≈≈]
    [≈≈≈≈≈≈≈≈≈≈]
    
              [G]
```

**Obstacles**: Water zones with buoyancy
**Difficulty**: Hard — combine shooting with floating
**Collectible**: Star deep in water zone
**Par**: 4 shots

---

## World 5: Space

### Level 11 - Low Orbit

**Dimensions**: 2000x1200px
**Visual**: Deep purple/black, stars, nebula background
**Ball Physics**: Low gravity (0.5x normal)

```
    [S]
     ●
     
    [P]          [P]          [P]
    
    
    
                                        [P]
                                        
                                              [G]
```

**Obstacles**: Low gravity — shots travel much further
**Difficulty**: Hard — must use less power
**Collectible**: Star on distant floating platform
**Par**: 3 shots

---

### Level 12 - Final Frontier

**Dimensions**: 2000x2000px
**Visual**: Space with orbiting asteroid platforms
**Ball Physics**: Low gravity, some rotating platforms

```
              [P]  ← Orbiting
         /         \
    [S] [P]         [P]
     ●                    [P]
    [P]              /
         \     [P]
              
                    [G]
```

**Obstacles**: Platforms in orbital arrangement, rotating slowly
**Difficulty**: Expert — combines everything learned
**Collectible**: Star on a moving orbital platform
**Par**: 4 shots

---

## Bonus: Victory

**Dimensions**: 1200x800px
**Visual**: Colorful celebration, particles everywhere

```
              ★ ★ ★
         CONGRATULATIONS!
         
    Total Stars: XX/36
    Total Shots: XX
    Levels Completed: 14/14
```

**No gameplay** — stats display and celebration
**Options**: "Play Again" or "Level Select"

---

## Difficulty Tuning

### Easy Levels (Tutorial, World 1)
- Large platforms (200-400px wide)
- Short gaps (50-100px)
- Forgiving landing zones
- Clear visual paths

### Medium Levels (World 2, World 3)
- Medium platforms (100-200px)
- Moderate gaps (100-150px)
- Some precision required
- New mechanics introduced gradually

### Hard Levels (World 4, World 5)
- Small platforms (50-100px)
- Large gaps (150-300px)
- Requires precise power/angle
- Multiple mechanics combined

---

## Hazard Design

### Lava (World 2)
- Red/orange glowing surface
- Instant restart on contact
- Visual particles (floating embers)
- Respawn at level start

### Kill Zones (All worlds)
- Invisible Area2D below visible level
- If ball falls off screen → restart
- Brief fade-out effect

### Moving Platforms
- Use AnimatableBody2D
- Predictable patterns (left-right or up-down)
- Speed increases in later worlds

### Wind Zones (World 3)
- Visible wind streaks/particles
- Apply force to ball while inside zone
- Direction indicated by arrows

### Water Zones (World 4)
- Semi-transparent blue overlay
- Slow ball movement
- Buoyancy pushes ball upward
- Current zones push left/right

---

## Collectible Placement

**Rules**:
1. Always visible from nearby
2. Requires slight detour or skill shot (not on critical path)
3. Safe to attempt (failure doesn't punish harshly)
4. Glowing particle effect for visibility

**Visual**:
- Star or coin sprite (from Kenney.nl)
- Pulsing glow effect
- Particle trail
- 3 collectibles per level = 36 total

---

## Level Transition Design

**Between Levels**:
1. Fade to black (0.5 seconds)
2. Level complete card shows:
   - Shot count
   - Star rating (★★★, ★★☆, etc.)
3. Player presses Enter to continue
4. Fade in to new level (0.5 seconds)

**Between Worlds**:
1. Fade to black (1 second)
2. World title card (e.g., "World 2: Volcano")
3. World color motif
4. Hold for 1.5 seconds
5. Fade to first level of world

---

## Camera Design

**Default Behavior**:
- **Smooth follow**: Camera lerps to ball position
- **Look-ahead**: Shifts in direction of ball velocity
- **Impact shake**: Brief screen shake on hard collisions

**Per-World Adjustments**:
- **Meadow**: Standard zoom (1.0x)
- **Volcano**: Slight zoom in (1.1x) for intensity
- **Sky**: Zoom out (0.9x) to show more sky
- **Ocean**: Standard with slight sway
- **Space**: Zoom out (0.8x) to show vastness

---

## Placeholder Asset Colors

**Ball**: Warm cream `#F2E0B8`
**Goal**: Green `#48D97C` (pulsing glow)

**Platform Colors by World**:
- Meadow: Green `#5FAD56`
- Volcano: Dark red `#8B2500`
- Sky: White/light blue `#E8F4FD`
- Ocean: Teal `#2A9D8F`
- Space: Dark purple `#2D1B69`

**Background Colors**:
- Tutorial: Warm gold `#F5DEB3`
- Meadow: Sky blue `#87CEEB`
- Volcano: Dark `#1A0A00` with orange glow
- Sky: Bright blue `#4FC3F7`
- Ocean: Deep teal `#004D40`
- Space: Near black `#0D0221`

---

## Level Sequencing

1. **Tutorial** → World 1 Start
2. **Level 1** (Meadow) → Level 2
3. **Level 2** (Meadow) → Level 3
4. **Level 3** (Meadow) → World 2 Transition → Level 4
5. **Level 4** (Volcano) → Level 5
6. **Level 5** (Volcano) → World 3 Transition → Level 6
7. **Level 6** (Sky) → Level 7
8. **Level 7** (Sky) → Level 8
9. **Level 8** (Sky) → World 4 Transition → Level 9
10. **Level 9** (Ocean) → Level 10
11. **Level 10** (Ocean) → World 5 Transition → Level 11
12. **Level 11** (Space) → Level 12
13. **Level 12** (Space) → Bonus Victory Screen
14. **Bonus** → Level Select / Main Menu

---

## Testing Checklist

- [ ] All levels are completable
- [ ] Goal zones trigger level transitions
- [ ] Collectibles collect correctly
- [ ] Hazard zones restart level properly
- [ ] Ball physics feel consistent per world
- [ ] Camera stays in bounds
- [ ] Trajectory preview renders correctly
- [ ] No soft-locks or unreachable areas
- [ ] Star ratings display correctly
- [ ] All 3-star ratings are achievable
