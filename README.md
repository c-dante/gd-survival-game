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
- No extensions!!!! And no LimboAI.

# TODO

- Balance changes
- More weapons (see idea pad)
- New enemies?
- Support android portait mode
  - https://docs.godotengine.org/en/4.3/classes/class_projectsettings.html#class-projectsettings-property-display-window-handheld-orientation
  - https://docs.godotengine.org/en/4.3/classes/class_displayserver.html#class-displayserver-method-screen-get-orientation

## QOL
- Delay to re-start action after level up
- Quit/Save/Resume

## Balance
- (code-game) Abstract difficulty/game progress from TestArena, spawner specifically
  - Enemies get stronger / faster / more kinds

## Code
- Standardize reactions to taking/dealing damage: `Player.gd`, `Enemy.gd`, `Global.gd`, `TestArena.gd`
- Figure out a better signal forwarding patter with composition -- constant internal exposed to external with delegate forwarding
- SpriteMover component is weird
  - (code-speed) speed buff thing this is funky, write of speed updates only base but read is adjusted...
- Clean up set_health and "_alive" flag (footgun if you re-use things)
- Improve the state machine's API since the hacked in facade around Limbo's sucks

## Juice
- Figure out animations. Doodad attachments, etc.
  - Animation player and stuff is hard to use... At least for me.
- Make a cool pickup animation: `Player.gd`
  - Like exp flies to the bar and the bar transitions instead of pops into place
  - All hp and xp bars lerp instead of snap
- Damage numbers
- Timeout-style juice like tweened/triggered animations

# Credits

These are the libraries/assets/tutorials that I've used while developing this project.
Many thanks for the creators! Check them out!

## Plugins
- [godot-git-plugin](https://godotengine.org/asset-library/asset/1581) by twaritwaikar
- [PixelPen](https://godotengine.org/asset-library/asset/3023) by bayu-sw
- [Virtual Joystick](https://godotengine.org/asset-library/asset/1787) by MarcoFazio

## Assets

- [Tiny Icon Pack](https://vryell.itch.io/tiny-adventure-pack-plus) by [Vryell](https://www.patreon.com/vryell)
- [Kenny Game Assets](https://kenney.itch.io/kenney-game-assets-1) by [Kenney](www.kenney.nl)
- [Heroic Assets Series - Icon Pack v1.2](https://iknowkingrabbit.itch.io/heroic-icon-pack) by [Aleksandr Makarov](https://www.patreon.com/iknowkingrabbit)
- [RPG Items - Retro Pack](https://blodyavenger.itch.io/rpg-items-retro-pack) by [Blodyavenger](https://blodyavenger.itch.io/)

## Tutorials

- [Godot 4 TileMap Tutorial](https://www.youtube.com/playlist?list=PLflAYKtRJ7dwtqA0FsZadrQGal8lWp-MM) by [Jackie Codes](https://www.patreon.com/jackiecodes)
- [Godot Docs](https://docs.godotengine.org/en/stable/index.html), thank you community!
