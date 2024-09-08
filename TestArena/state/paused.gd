class_name PausedState
extends StateNode

@export var game_ui: GameUi

func _enter():
	Global.safe_pause(true)
	game_ui.set_pause_state(true)

func _exit():
	Global.safe_pause(false)
