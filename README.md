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
- I still don't like LimboAI... But better than what I had before.

# TODO

## QOL
- Delay to re-start action after level up
- Quit/Save/Resume

## Balance
- (code-game) Abstract difficulty/game progress from TestArena, spawner specifically
  - Enemies get stronger / faster / more kinds

## Code
- (code-game) Figure out spawning enemies / attaching weapons outside of TestArena?
  - Component code most likely? A "Game" Component?
- Standardize reactions to taking/dealing damage: `Player.gd`, `Enemy.gd`, `Global.gd`, `TestArena.gd`
- Figure out a better signal forwarding patter with composition -- constant internal exposed to external with delegate forwarding
- SpriteMover component is weird
  - (code-speed) speed buff thing this is funky, write of speed updates only base but read is adjusted...
- Clean up set_health and "_alive" flag (footgun if you re-use things)

## Juice
- Make a cool pickup animation: `Player.gd`
  - Like exp flies to the bar and the bar transitions instead of pops into place
  - All hp and xp bars lerp instead of snap
- Damage numbers
- Timeout-style juice like tweened/triggered animations

# Credits

These are the libraries/assets/tutorials that I've used while developing this project.
Many thanks for the creators! Check them out!

## Plugins
- godot-git-plugin
- LimboAI
- PixelPen

## Assets

- [Tiny Icon Pack](https://vryell.itch.io/tiny-adventure-pack-plus) by [Vryell](https://www.patreon.com/vryell)
- [Kenny Game Assets](https://kenney.itch.io/kenney-game-assets-1) by [Kenney](www.kenney.nl)
- [Heroic Assets Series - Icon Pack v1.2](https://iknowkingrabbit.itch.io/heroic-icon-pack) by [Aleksandr Makarov](https://www.patreon.com/iknowkingrabbit)

## Tutorials

- [Godot 4 TileMap Tutorial](https://www.youtube.com/playlist?list=PLflAYKtRJ7dwtqA0FsZadrQGal8lWp-MM) by [Jackie Codes](https://www.patreon.com/jackiecodes)
- [Godot Docs](https://docs.godotengine.org/en/stable/index.html), thank you community!
