Playing with making a survival game a' la Magic Survival and Vampire Survivors etc.

- [Balancing Data Sheet](https://docs.google.com/spreadsheets/d/1FkvFWZtLFzFhl9jPzdnoybg0r700ZM4g6ZOwygkKAIY/edit?usp=sharing)

## Differentiating Game design ideas:

- Proc gen floors like diablo 1
- Use stair system to constrain movement but allow quick level select
- Enemies respawn when entering a floor -- there is no safety
- Floors proc gen set pieces for events, first clear bonus
- No town runs and inventory clearing per se, decisions roll forward

## Notes

- Data sheets are in sheets: https://docs.google.com/spreadsheets/d/1FkvFWZtLFzFhl9jPzdnoybg0r700ZM4g6ZOwygkKAIY/edit?gid=0#gid=0
- z-index ordering and other constants are in Global
- ArenaTest is our main scene for everything
- Game is marked pausable -- anything sub-tree of that should be the thing

# TODO

- (feat) Enemies get stronger / faster / healthier

## 2024-09-03:

- (qol) Quit/Save/Resume
- (qol) Pausing
- (qol) New Game Screen instead of "level up"
- (qol) Delay to re-start action after level up
- (code-game) Abstract difficulty/game progress from TestArena, spawner specifically
  - Bring in a state machine (MAYBE) for the broad pause/playing/level-up states
- (code) Split "GameUi" into individual screens, like LevelUpUi is
- (code-level-up) Abstract/make a system for weapon and level up choices
- (code-speed) this is funky, write of speed updates only base but read is adjusted...

## 2024-09-02:

- (code) Figure out a better signal forwarding patter with composition, health for ex
- (bug-pause) Pausing in a signal, even deferred, has weird ordering, make a minimal example

## 2024-09-01:

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
