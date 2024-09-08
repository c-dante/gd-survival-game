extends StateNode

@export var test_arena: TestArena
@export var game_over_ui: GameOver

func _enter():
	Global.safe_pause(true)
	game_over_ui.show()

func _exit():
	Global.safe_pause(false)
	game_over_ui.hide()
