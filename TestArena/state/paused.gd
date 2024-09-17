class_name PausedState
extends StateNode

@export var game_ui: GameUi
@export var test_arena: TestArena

func _enter():
	test_arena._disable_joystick()
	Global.safe_pause(true)
	game_ui.set_pause_state(true)

func _exit():
	Global.safe_pause(false)
