Playing with making a survival game a' la Magic Survival and Vampire Survivors etc.

## Differentiating Game design ideas:
- Proc gen floors like diablo 1
- Use stair system to constrain movement but allow quick level select
- Enemies respawn when entering a floor -- there is no safety
- Floors proc gen set pieces for events, first clear bonus
- No town runs and inventory clearing per se, decisions roll forward

### 2024-09-02:
- (code) Figure out a better signal forwarding patter with composition, health for ex
- (bug-pause) Pausing in a signal, even deferred, has weird ordering, make a minimal example
- (code) Bring in a state machine (MAYBE) for the broad pause/playing/level-up states
- (design) Set up a database for the floating values to balance + chart out -- playing with [nocodb](https://app.nocodb.com/#/w3w4abb2/p7o1mz2h56mv7gl/mtssmvtqh9sy6hh)

## TOOD:
- (code) Refactor signal/stat aggregation: `Enemy.gd`, `Global.gd`
- (juice) Make a cool pickup animation: `Player.gd`
- (code) Standardize reactions to taking/dealing damage: `Player.gd`
  - Stat aggregation
  - (design) Visual effects
	- Damage numbers
- (code) Centralize "global" effect/action summoning: `TestScene.gd`
  - Dropping pickups
  - Timeout-style juice like tweened/triggered animations

# Credits
These are the libraries/assets/tutorials that I've used while developing this project.
Many thanks for the creators! Check them out!

## Assets
- [Tiny Icon Pack](https://vryell.itch.io/tiny-adventure-pack-plus) by [Vryell](https://www.patreon.com/vryell)
- [Kenny Game Assets](https://kenney.itch.io/kenney-game-assets-1) by [Kenney](www.kenney.nl)
- [Heroic Assets Series - Icon Pack v1.2](https://iknowkingrabbit.itch.io/heroic-icon-pack) by [Aleksandr Makarov](https://www.patreon.com/iknowkingrabbit)

## Tutorials
- [Godot 4 TileMap Tutorial](https://www.youtube.com/playlist?list=PLflAYKtRJ7dwtqA0FsZadrQGal8lWp-MM) by [Jackie Codes](https://www.patreon.com/jackiecodes)
- [Godot Docs](https://docs.godotengine.org/en/stable/index.html), thank you community!
