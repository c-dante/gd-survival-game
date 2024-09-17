class_name Display
extends Node

static var LongSide = 1280
static var ShortSide = 720
static var CurrentMode = DisplayMode.LANDSCAPE
# 16:9

enum DisplayMode {
	LANDSCAPE,
	PORTRAIT
}

signal display_mode_changed(display_mode: DisplayMode)

var _size
var _dpi
var _display_mode

func _ready():
	display_mode_changed.connect(_update_display)
	_dpi = DisplayServer.screen_get_dpi()
	_on_check()

func _on_check():
	var last_mode = _display_mode
	# _scale = DisplayServer.screen_get_scale() # Disabled because it spams logs with "Selected screen scale"...
	_size = get_window().size

	# Prefer landscape if square
	if _size.y > _size.x:
		_display_mode = DisplayMode.PORTRAIT
	else:
		_display_mode = DisplayMode.LANDSCAPE
		
	Display.CurrentMode = _display_mode
	if last_mode != _display_mode:
		display_mode_changed.emit(_display_mode)

func _update_display(display_mode: DisplayMode):
	match display_mode:
		DisplayMode.LANDSCAPE:
			get_window().content_scale_size.x = LongSide
			get_window().content_scale_size.y = ShortSide
		DisplayMode.PORTRAIT:
			get_window().content_scale_size.x = ShortSide
			get_window().content_scale_size.y = LongSide

# Mobile Landscale
#-- window ---
#VP Size: (2220, 1080)
#Win Size: (2220, 1080)
#Aspect: 1
#Scale Mode: 2
#-- Screen
#Orientation: 6
#DPI: 374
#Refresh: 60.0000038146973
#Selected screen scale:  1.79999995231628
#Scale: 1.79999995231628
#Size: (2220, 1080)
#Useable: [P: (0, 0), S: (2220, 1080)]

# Mobile Portrait
#--- window ---
#VP Size: (1080, 2220)
#Win Size: (1080, 2220)
#Aspect: 1
#Scale Mode: 2
#-- Screen
#Orientation: 6
#DPI: 374
#Refresh: 60.0000038146973
#Selected screen scale:  1.35000002384186
#Scale: 1.35000002384186
#Size: (1080, 2220)
#Useable: [P: (0, 0), S: (1080, 2220)]

# Desktop
#--- window ---
#VP Size: (1280, 720)
#Win Size: (1280, 720)
#Aspect: 1
#Scale Mode: 2
#-- Screen
#Orientation: 0
#DPI: 96
#Refresh: 143.998001098633
#Scale: 1
#Size: (2560, 1440)
#Useable: [P: (0, 0), S: (2560, 1440)]
