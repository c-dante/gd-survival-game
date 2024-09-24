extends StateNode

@export var test_arena: TestArena
@export var main_menu_ui: Control

func _enter():
	test_arena._disable_joystick()
	Progress.load()
	Global.safe_pause(true)
	main_menu_ui.show()
	
func _exit():
	Global.safe_pause(false)
	main_menu_ui.hide()
