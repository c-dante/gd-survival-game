Various notes and things that surprised me

## Testing

Oh look! Easy test/deploy on export mediums: [one-click deploy](https://docs.godotengine.org/en/stable/tutorials/export/one-click_deploy.html)

To remote debug, needed to check Debug > Deploy with Remote Debug to get it to work :|

## Display / Aspect Ratio

Doesn't seem to be anything that emits events when mobile changes view mode.

### Viewpoert resize callback

(undocumenterd) If you have the Stretch mode set to Viewport, you never get resize events.
This is likely because the viewport never changes size. Which sucks for detcting resize of the window.

Okay, this callback is trash -- it's not the WINDOW it's the VIEWPORT :|

### Orientation Change (Landscape -> Portrait)

Basically, this isn't a thing. The only way is to observe the width/height and if it flips, assume.

Setting the orientation to sensor doesn't do much it sees?
Portrait sensor doesn't flip the render screen as I'd expect... Full sensor does work

Docs on these bits:

- [PR to add window size signal](https://github.com/godotengine/godot/pull/87210)
- [Window](https://docs.godotengine.org/en/stable/classes/class_window.html)
  - All the window scaling/stretch/orientation stuff
  - Access via `get_tree().root`
  - Window IS a viewport!!
- [Viewport](https://docs.godotengine.org/en/stable/classes/class_viewport.html)
  - All the render sizing and things
  - Access via `get_viewport()`
- [DisplayServer](https://docs.godotengine.org/en/stable/classes/class_displayserver.html)
  - Has `screen_get_orientation` but no listener....
