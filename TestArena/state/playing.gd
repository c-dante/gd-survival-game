extends StateNode

@export var game_ui: GameUi

func _enter():
	game_ui.show()
	game_ui.set_pause_state(false)
