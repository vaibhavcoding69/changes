# Changes - 4th Wall Catalog

## Overview
This document catalogs every 4th-wall-breaking element in the game, organized by type with implementation details for Godot 4.

---

## Categories

1. **Visual Glitches** - Screen/shader effects
2. **Window Manipulation** - OS-level window control
3. **Cursor Tricks** - Input device manipulation
4. **System Intrusion** - Reading player data
5. **Fake Errors** - Dialog boxes, crash screens
6. **Meta-Narrative** - Direct address, awareness

---

## 1. Visual Glitches

### A. Screen Shake
**Trigger**: Ball collision in Act 2 (Levels 4-5)  
**Effect**: Camera position offset randomly for 0.2 seconds  
**Intensity**: ±10px horizontal/vertical

**Implementation** (`camera_controller.gd`):
```gdscript
func shake(duration: float = 0.2, intensity: float = 10.0):
    var original_pos = position
    var timer = 0.0
    
    while timer < duration:
        offset = Vector2(
            randf_range(-intensity, intensity),
            randf_range(-intensity, intensity)
        )
        timer += get_process_delta_time()
        await get_tree().process_frame
    
    offset = Vector2.ZERO
```

---

### B. Glitch Shader (Chromatic Aberration + Scanlines)
**Trigger**: Act 3 (escalating), max in Level 8  
**Effect**: RGB color separation, horizontal displacement

**Shader** (`shaders/glitch.gdshader`):
```glsl
shader_type canvas_item;

uniform float glitch_strength : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    
    // Chromatic aberration
    float r = texture(screen_texture, uv + vec2(0.01 * glitch_strength, 0.0)).r;
    float g = texture(screen_texture, uv).g;
    float b = texture(screen_texture, uv - vec2(0.01 * glitch_strength, 0.0)).b;
    
    // Scanlines
    float scanline = sin(uv.y * 800.0) * 0.1 * glitch_strength;
    
    // Random displacement
    if (fract(sin(uv.y * 10.0 + TIME) * 43758.5) < glitch_strength * 0.3) {
        uv.x += sin(TIME * 20.0) * 0.05;
    }
    
    COLOR = vec4(r + scanline, g + scanline, b + scanline, 1.0);
}
```

**Usage** (`glitch_overlay.tscn`):
- Full-screen `ColorRect` with shader
- Initially at `glitch_strength = 0.0`
- Tween strength up as acts progress

---

### C. Desaturate Shader (Grayscale)
**Trigger**: Act 4 (Levels 9-10)  
**Effect**: World loses color, grayscale conversion

**Shader** (`shaders/desaturate.gdshader`):
```glsl
shader_type canvas_item;

uniform float saturation : hint_range(0.0, 1.0) = 1.0;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    COLOR.rgb = mix(vec3(gray), color.rgb, saturation);
    COLOR.a = color.a;
}
```

**Usage**:
- Apply to `CanvasLayer` shader
- Tween `saturation` from 1.0 → 0.3 over 5 seconds at Act 4 start
- Tween back to 0.7 in Act 5 (partial color return)

---

### D. Color Inversion
**Trigger**: Death scare sequence  
**Effect**: Invert all colors briefly

**Implementation** (`fourth_wall/glitch_effects.gd`):
```gdscript
func invert_colors():
    var env = get_viewport().get_canvas_transform()
    # Use ColorRect with blend mode or shader
    var invert_shader = preload("res://shaders/invert.gdshader")
    overlay.material.shader = invert_shader
```

---

## 2. Window Manipulation

### A. Window Drift
**Trigger**: Level 6-7 (Act 3)  
**Effect**: Window slowly moves on screen (5px/second)

**Implementation** (`fourth_wall/window_tricks.gd`):
```gdscript
func drift_window(duration: float = 10.0):
    var start_pos = DisplayServer.window_get_position()
    var timer = 0.0
    
    while timer < duration:
        var offset = Vector2i(
            int(sin(timer) * 50),
            int(cos(timer) * 50)
        )
        DisplayServer.window_set_position(start_pos + offset)
        timer += 0.1
        await get_tree().create_timer(0.1).timeout
    
    DisplayServer.window_set_position(start_pos)
```

---

### B. Window Shake (Violent)
**Trigger**: Death scare sequence  
**Effect**: Window position changes rapidly

**Implementation**:
```gdscript
func shake_window(duration: float = 1.0):
    var original_pos = DisplayServer.window_get_position()
    var timer = 0.0
    
    while timer < duration:
        var offset = Vector2i(
            randi_range(-20, 20),
            randi_range(-20, 20)
        )
        DisplayServer.window_set_position(original_pos + offset)
        timer += 0.05
        await get_tree().create_timer(0.05).timeout
    
    DisplayServer.window_set_position(original_pos)
```

---

### C. Window Minimize
**Trigger**: Level 9 (Act 4)  
**Effect**: Window minimizes for 2 seconds, then restores

**Implementation**:
```gdscript
func minimize_window():
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
    await get_tree().create_timer(2.0).timeout
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
```

**Note**: On Linux, this behavior varies by window manager. Test with GNOME/KDE.

---

### D. Window Resize (Optional)
**Trigger**: Not currently used (could add to Level 8)  
**Effect**: Window shrinks/grows

```gdscript
func resize_window(new_size: Vector2i):
    DisplayServer.window_set_size(new_size)
```

---

## 3. Cursor Tricks

### A. Cursor Stutter
**Trigger**: Level 2 (Act 1)  
**Effect**: Cursor position jumps randomly for 2 seconds

**Implementation** (`fourth_wall/cursor_tricks.gd`):
```gdscript
func stutter_cursor(duration: float = 2.0):
    var timer = 0.0
    
    while timer < duration:
        var current_pos = get_viewport().get_mouse_position()
        var offset = Vector2(
            randf_range(-10, 10),
            randf_range(-10, 10)
        )
        Input.warp_mouse(current_pos + offset)
        timer += 0.1
        await get_tree().create_timer(0.1).timeout
```

---

### B. Cursor Hide
**Trigger**: Level 7 (Act 3)  
**Effect**: Cursor disappears for 3 seconds

**Implementation**:
```gdscript
func hide_cursor(duration: float = 3.0):
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
    await get_tree().create_timer(duration).timeout
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
```

---

### C. Cursor Lock (Death Scare)
**Trigger**: Death scare sequence  
**Effect**: Cursor warps to center, confined to window

**Implementation**:
```gdscript
func lock_cursor():
    var screen_center = get_viewport().get_visible_rect().size / 2
    Input.warp_mouse(screen_center)
    Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
    
    # Release after scare
    await get_tree().create_timer(5.0).timeout
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
```

---

## 4. System Intrusion

### A. Username Read
**Trigger**: Level 8 (Act 3)  
**Effect**: Narrator addresses player by OS username

**Implementation** (`fourth_wall/os_intrusion.gd`):
```gdscript
func get_username() -> String:
    var username = OS.get_environment("USER")  # Linux/Mac
    if username.is_empty():
        username = OS.get_environment("USERNAME")  # Windows
    if username.is_empty():
        username = "Player"  # Fallback
    return username
```

**Usage**:
```gdscript
var username = FourthWall.get_username()
Narrator.show_text("%s, please. Help me." % username)
```

---

### B. System Time Read (Optional)
**Trigger**: Not currently used (could add meta-commentary)  
**Effect**: Game references real-world time

```gdscript
func get_real_time() -> String:
    var time = Time.get_datetime_dict_from_system()
    return "%02d:%02d" % [time.hour, time.minute]
```

---

## 5. Fake Errors

### A. OS Alert Dialog
**Trigger**: Level 5 (Act 2)  
**Effect**: System error dialog appears

**Implementation**:
```gdscript
func show_fake_error():
    OS.alert("Error: expected_person.exe not found", "System Error")
```

**Appearance**: Native OS dialog (varies by platform)

---

### B. Fake Crash Screen (Death Scare)
**Trigger**: Death scare sequence (10+ deaths)  
**Effect**: Full-screen blue "BSOD" style error

**Implementation** (`scenes/effects/fake_crash.tscn`):
- Full-screen `ColorRect` (blue `#0000AA`)
- `Label` with monospace font, white text
- Text content from narrative.md

**Script** (`fake_crash.gd`):
```gdscript
extends ColorRect

func _ready():
    visible = false

func trigger_crash():
    var username = FourthWall.get_username()
    $Label.text = """
═══════════════════════════════════════════
 FATAL ERROR 0x000000GRIEF
═══════════════════════════════════════════

%s, STOP.

You're not supposed to give up.
Not like this.
Not after everything.

They wouldn't want this.

You know they wouldn't.

Keep going.

═══════════════════════════════════════════
Press any key to continue...
═══════════════════════════════════════════
    """ % username
    
    visible = true
    await get_tree().create_timer(5.0).timeout
    # Wait for input after 5 seconds
    await get_tree().process_frame  # Listen for keypress
    visible = false
```

---

### C. Fake "Game Not Responding" (Optional)
**Trigger**: Not used (too frustrating)  
**Effect**: Game freezes UI but keeps running

```gdscript
func fake_freeze(duration: float = 3.0):
    get_tree().paused = true  # Pause scene tree
    # But keep rendering
    await get_tree().create_timer(duration).timeout
    get_tree().paused = false
```

---

## 6. Meta-Narrative

### A. Direct Address (Username)
**Trigger**: Level 8, Level 10, Death Scare  
**Effect**: Narrator uses player's OS username

**Examples**:
- *"[USERNAME], please. Maybe if we both try..."*
- *"[USERNAME], are you still there?"*
- *"[USERNAME], STOP."*

---

### B. Death Counter Acknowledgment
**Trigger**: After 5+ deaths in any level  
**Effect**: Narrator comments on repeated failure

**Implementation** (`fourth_wall/death_tracker.gd`):
```gdscript
extends Node

var death_count = 0
var level_death_count = 0

func on_death():
    death_count += 1
    level_death_count += 1
    
    if level_death_count == 5:
        Narrator.show_text("You've tried this %d times now." % level_death_count)
    elif death_count == 10:
        trigger_death_scare()

func trigger_death_scare():
    # See narrative.md and fake_crash implementation
    get_tree().paused = true
    FourthWall.shake_window(1.0)
    FourthWall.lock_cursor()
    $FakeCrashScreen.trigger_crash()
    await $FakeCrashScreen.finished
    get_tree().paused = false
    LevelManager.restart_level()
```

---

### C. Blackout Text Overlay
**Trigger**: Level 10 (Act 4)  
**Effect**: Screen goes black, text appears in center

**Implementation** (`scenes/effects/black_screen.tscn`):
- Full-screen black `ColorRect`
- Centered `Label` with white text

**Script**:
```gdscript
func show_blackout_text():
    var username = FourthWall.get_username()
    $Label.text = "%s, are you still there?\n\n\n\nI can't see anymore." % username
    visible = true
    await get_tree().create_timer(5.0).timeout
    visible = false
```

---

### D. Ghost Ball (Level 12)
**Trigger**: Reaching goal in Level 12  
**Effect**: Second ball appears as memory, fades

**Implementation** (`scenes/ghost_ball.tscn`):
- Duplicate of ball sprite
- `modulate.a` starts at 0.5 (semi-transparent)
- No physics (Sprite2D only)

**Script**:
```gdscript
func appear_and_fade():
    modulate.a = 0.0
    visible = true
    
    var tween = create_tween()
    tween.tween_property(self, "modulate:a", 0.5, 1.0)
    tween.tween_interval(3.0)
    tween.tween_property(self, "modulate:a", 0.0, 2.0)
    await tween.finished
    queue_free()
```

---

## Anomaly Sequencing per Level

| Level | Anomalies | Intensity (1-10) |
|-------|-----------|------------------|
| Prologue | None | 0 |
| 1 | None | 0 |
| 2 | Cursor stutter | 2 |
| 3 | Ball input delay | 3 |
| 4 | Screen shake, wall cracks | 5 |
| 5 | Fake OS error | 6 |
| 6 | Window drift | 6 |
| 7 | Cursor hide, window drift | 7 |
| 8 | Username reveal, heavy glitch, cursor hide | 9 |
| 9 | Window minimize, heavy ball physics | 8 |
| 10 | Blackout text, grayscale | 9 |
| 11 | None (calm) | 2 |
| 12 | Ghost ball (positive) | 3 |
| Epilogue | None | 0 |
| Death Scare | ALL (window shake, cursor lock, fake crash, color invert) | 10 |

---

## Integration Points

### In `level_manager.gd` (Autoload):
```gdscript
func on_level_start(level_num: int):
    match level_num:
        2:
            await get_tree().create_timer(5.0).timeout
            FourthWall.stutter_cursor(2.0)
        5:
            await get_tree().create_timer(8.0).timeout
            FourthWall.show_fake_error()
        8:
            FourthWall.start_glitch(0.8)
            await get_tree().create_timer(10.0).timeout
            var username = FourthWall.get_username()
            Narrator.show_text("%s, please..." % username)
        # etc.
```

---

## Performance Considerations

1. **Shader overhead**: Glitch shader uses screen texture — keep it lightweight
2. **Window manipulation**: `DisplayServer` calls can be slow on some Linux WMs
3. **Cursor warping**: May not work in fullscreen or on Wayland
4. **Tween cleanup**: Always use `tween.kill()` on scene exit to prevent memory leaks

---

## Platform Compatibility

| Feature | Windows | macOS | Linux |
|---------|---------|-------|-------|
| Window move | ✅ | ✅ | ⚠️ (WM-dependent) |
| Window minimize | ✅ | ✅ | ⚠️ (WM-dependent) |
| Cursor warp | ✅ | ✅ | ⚠️ (Not on Wayland) |
| OS.alert | ✅ | ✅ | ✅ |
| Username read | ✅ | ✅ | ✅ |
| Shaders | ✅ | ✅ | ✅ |

**Note**: Test on Linux (GNOME/KDE) specifically for window manipulation. May need fallback behavior for Wayland.

---

## Testing Checklist

- [ ] Glitch shader renders correctly at various intensities
- [ ] Window drift returns to original position
- [ ] Window shake doesn't move window off-screen
- [ ] Cursor stutter doesn't break input permanently
- [ ] Cursor hide always restores visibility
- [ ] Username reads correctly on current OS
- [ ] Fake error dialog doesn't block game loop
- [ ] Death scare triggers at exactly 10 deaths
- [ ] Fake crash screen displays username correctly
- [ ] Blackout text is centered and readable
- [ ] Ghost ball appears and fades smoothly
- [ ] All anomalies reset properly on level restart
- [ ] No performance drops during shader effects
- [ ] Window manipulation works on target platform (Linux confirmed)
