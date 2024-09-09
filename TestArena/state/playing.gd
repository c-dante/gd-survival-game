extends StateNode

@export var game_ui: GameUi
@export var virtual_joystick: VirtualJoystick


func _enter():
	virtual_joystick.process_mode = Node.PROCESS_MODE_INHERIT
	game_ui.show()
	game_ui.set_pause_state(false)

func _exit():
	virtual_joystick._reset()
	virtual_joystick.visible = false
	virtual_joystick.process_mode = Node.PROCESS_MODE_DISABLED
	
