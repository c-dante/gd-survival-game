extends StateNode

@export var game_ui: GameUi
@export var test_arena: TestArena


func _enter():
	test_arena._enable_joystick()
	game_ui.show()
	game_ui.set_pause_state(false)
