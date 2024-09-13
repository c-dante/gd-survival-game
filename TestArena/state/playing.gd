extends StateNode

@export var game_ui: GameUi
@export var virtual_joystick: VirtualJoystick


func _enter():
	if DisplayServer.is_touchscreen_available():
		virtual_joystick.process_mode = Node.PROCESS_MODE_INHERIT
	game_ui.show()
	game_ui.set_pause_state(false)

func _exit():
	# TODO (bug-input): Joystick touch jitter
	if DisplayServer.is_touchscreen_available():
		virtual_joystick._reset()
		virtual_joystick.visible = false
		virtual_joystick.process_mode = Node.PROCESS_MODE_DISABLED
