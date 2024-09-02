Playing with making a survival game a' la Magic Survival and Vampire Survivors etc.

## Differentiating Game design ideas:
- Proc gen floors like diablo 1
- Use stair system to constrain movement but allow quick level select
- Enemies respawn when entering a floor -- there is no safety
- Floors proc gen set pieces for events, first clear bonus
- No town runs and inventory clearing per se, decisions roll forward

## TOOD:
- (code) Refactor signal/stat aggregation: `Enemy.gd`, `Global.gd`
- (code) Fix the game start/restart logic: `TestScene.gd`
- (juice) Make a cool pickup animation: `Player.gd`
- (code) Standardize reactions to taking/dealing damage: `Player.gd`
  - Stat aggregation
  - Visual effects
- (code) Centralize "global" effect/action summoning: `TestScene.gd`
  - Dropping pickups
  - Triggering effects
  - Timeout-style juice like tweened/triggered animations
