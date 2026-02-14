# Changes - Narrative Script

## Story Summary
The player controls a ball navigating through abstract spaces while processing the death of a loved one (implied to be a partner or close friend). The game begins with two balls together, then one vanishes. The player assumes they'll return, but through the 5 stages of grief, comes to accept they're gone forever. The game itself becomes "aware" and addresses the player directly, breaking the 4th wall as a metaphor for how grief intrudes on normal life.

---

## Prologue: Before

**Scene**: Two balls in warm, golden-lit space. Soft ambient music.

**Visual Text (no narrator voice)**:
- *"We were always together."*

**Tutorial Prompt** (on-screen):
- *"Click and drag to move"*

**On Reaching Other Ball**:
- Both balls pulse with light
- Fade to white
- Text: *"Then everything changed."*
- Cut to black

---

## Act 1: Denial

### Level 1 - Empty Room

**On Start**:
> *"It's fine. Everything's fine."*

**Mid-Level** (after 10 seconds):
> *"You're just... somewhere else right now."*

**On Goal**:
> *"See? I can still do this without you."*

---

### Level 2 - The Hallway

**On Start**:
> *"Where did you go?"*

**After Cursor Stutter Anomaly**:
> *"That was... strange."*

**Mid-Level**:
> *"You didn't say goodbye."*

**On Goal**:
> *"You'll be back soon. I know you will."*

---

### Level 3 - Waiting Room

**On Start**:
> *"I'll wait here."*

**After Ball Doesn't Respond to Input**:
> *"Come on..."*

**First Loop Back to Start**:
> *"Any minute now."*

**Second Loop** (if player circles back):
> *"You always come back."*

**On Goal** (finally leaving):
> *"Maybe you're just ahead of me."*

---

## Act 2: Anger

### Level 4 - Breakable

**On Start**:
> *"Why?"*

**First Wall Break**:
> *"WHY DID THIS HAPPEN?"*

**After Screen Shake**:
> *"I don't understand!"*

**On Death**:
> *"NOTHING MAKES SENSE!"*

**On Goal**:
> *"This isn't fair. None of this is fair."*

---

### Level 5 - Error

**On Start**:
> *"Everything's broken."*

**When Fake Error Appears** ("Error: expected_person.exe not found"):
> *[Silence for 3 seconds]*
> *"Even the world knows you're gone."*

**After Overshooting Target**:
> *"I can't control anything anymore!"*

**On Goal**:
> *"Who do I even blame for this?"*

---

## Act 3: Bargaining

### Level 6 - Branching Paths

**On Start**:
> *"If I just... try this way instead."*

**At First Path Split**:
> *"Maybe this choice matters."*

**When Paths Converge**:
> *"It doesn't matter, does it?"*

**On Goal**:
> *"What if I could go back and choose differently?"*

---

### Level 7 - Memory Lane

**On Start**:
> *"I keep thinking about before."*

**Memory Fragment 1** (on collection):
> *"We used to sit here for hours, doing nothing. Just... being together."*

**Memory Fragment 2**:
> *"You always laughed at the smallest things. I miss that sound."*

**When Window Starts Drifting**:
> *"Everything feels unstable now."*

**On Goal**:
> *"If I could just rewind time..."*

---

### Level 8 - [USERNAME]

**On Start**:
> *"Maybe if I try harder."*

**When Cursor Disappears**:
> *[Silence]*

**When Cursor Returns + Username Reveal**:
> *"[USERNAME], please. Help me. Maybe if we both try... maybe we can bring them back."*

**Heavy Glitch Effect**:
> *"I know it doesn't make sense. I know they're gone. But I need them back."*

**On Goal**:
> *"What do I have to do? What do I have to sacrifice?"*

---

## Act 4: Depression

### Level 9 - The Void

**On Start**:
> *[Whisper]* *"I'm so tired."*

**After 20 Seconds** (long silence):
> *[Barely audible]* *"What's the point?"*

**When Window Minimizes**:
> *[No text — just silence]*

**When Window Restores**:
> *"Even escaping doesn't work."*

**On Goal**:
> *"I don't want to keep going."*

---

### Level 10 - Blackout

**On Start**:
> *[Whisper]* *"It's so dark."*

**When Screen Goes Black**:
- **Text (center screen, no narrator voice)**:
  ```
  [USERNAME], are you still there?
  
  
  
  I can't see anymore.
  ```

**After 5-Second Pause, Level Resumes**:
> *[Whisper]* *"Maybe it's time to stop fighting."*

**On Goal**:
> *[Silence — no text]*

---

## Act 5: Acceptance

### Level 11 - Release

**On Start**:
> *[Calm, clear voice]* *"They're not coming back."*

**After 5 Seconds**:
> *[Pause]* *"...and that's okay."*

**Mid-Level**:
> *"I can't change what happened."*

**On Goal**:
> *"But I can choose what I do next."*

---

### Level 12 - Forward

**On Start**:
> *"This is the last time I'll look back."*

**Mid-Level**:
> *"I'll carry you with me."*

**Near Goal** (ghost ball appears):
> *[No words — just music swells]*

**Ghost Ball Fades**:
> *"Goodbye."*

**On Goal**:
> *"I'm ready now."*

---

## Epilogue: After

**Ball Moves Automatically** (no player control):

**Text appears gradually, fading in and out**:
- *"Change is the only constant."*
- *"And I'm still here."*
- *"I'll keep moving forward."*
- *"For both of us."*

**Final Frame**:
- Ball continues rolling into light
- Fade to white
- Credits (simple text scroll)

---

## Death Scare Event Script

**Trigger**: 10+ deaths in Act 3 or Act 4

**Screen Freezes, Glitch Intensifies, Window Shakes**

**Full Screen Text** (blue background, white monospace text):
```
═══════════════════════════════════════════
 FATAL ERROR 0x000000GRIEF
═══════════════════════════════════════════

[USERNAME], STOP.

You're not supposed to give up.
Not like this.
Not after everything.

They wouldn't want this.

You know they wouldn't.

Keep going.

═══════════════════════════════════════════
Press any key to continue...
═══════════════════════════════════════════
```

**After 5 Seconds or Key Press**:
- Fade to black
- Restart at current level
- Music changes to low, ominous drone for rest of act

---

## Memory Fragment Texts

**Memory 1** (Level 1):
> *"We used to race to see who could finish first. You always won."*

**Memory 2** (Level 2):
> *"Remember that time we got lost? We laughed the whole way home."*

**Memory 3** (Level 3):
> *"You said we'd always be together. I believed you."*

**Memory 4** (Level 4):
> *"Your favorite color was the same as mine. We didn't even plan it."*

**Memory 5** (Level 5):
> *"I can still hear your voice sometimes. Then I remember it's just an echo."*

**Memory 6** (Level 6):
> *"You told me to keep going, no matter what. Did you know, even then?"*

**Memory 7** (Level 7):
> *"I found your note yesterday. I can't bring myself to read it again."*

**Memory 8** (Level 8):
> *"Everyone says it gets easier. They're lying, aren't they?"*

**Memory 9** (Level 9):
> *"I don't know who I am without you."*

**Memory 10** (Level 10):
> *"I'm trying. I promise I'm trying."*

**Memory 11** (Level 11):
> *"Maybe I can learn to be whole again. Differently whole."*

**Memory 12** (Level 12):
> *"Thank you for everything. I'll never forget."*

---

## Narrator Tone Direction

### Act 1 (Denial)
- Confused, uncertain
- Trying to sound normal but failing
- Pauses between words, like processing

### Act 2 (Anger)
- Loud, aggressive
- Sentences cut short
- Emphasis on WHY and UNFAIR

### Act 3 (Bargaining)
- Desperate, pleading
- Addresses player directly
- Faster pacing, overlapping thoughts

### Act 4 (Depression)
- Whispers
- Long silences (10+ seconds)
- Barely audible, like giving up

### Act 5 (Acceptance)
- Calm, steady
- Sad but at peace
- Clear enunciation, no hesitation

---

## Easter Eggs (Optional)

1. **If player stays idle for 60 seconds in any level**:
   > *"Take your time. There's no rush."*

2. **If player collects all 12 memory fragments**:
   - Epilogue adds extra line:
     > *"I'll remember everything. The good and the bad. All of it mattered."*

3. **If player beats game without dying**:
   - Epilogue adds:
     > *"You were stronger than I thought. Thank you."*

---

## Emotional Beats

The story follows a clear arc:
1. **Denial**: "They'll come back"
2. **Anger**: "Why did this happen to me?"
3. **Bargaining**: "What if I could change it?"
4. **Depression**: "I can't go on"
5. **Acceptance**: "I'll carry them with me and keep moving"

The 4th-wall breaks mirror the intrusive nature of grief — it doesn't respect boundaries, it interrupts normal life, it addresses you directly when you least expect it. By the end, the narrator (the player's internal voice) makes peace with both the loss and the breaking of reality itself.
