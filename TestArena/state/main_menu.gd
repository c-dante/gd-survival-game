extends LimboState

@export var main_menu_ui: Control;

func _enter():
	Global.safe_pause(true)
	main_menu_ui.show()
	blackboard.clear()
	
func _exit():
	Global.safe_pause(false)
	main_menu_ui.hide()
