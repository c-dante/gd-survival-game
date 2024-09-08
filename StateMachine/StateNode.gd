class_name StateNode
extends Node

func get_root():
	# TODO (code-hack): crawl the tree
	return get_parent()

func _enter():
	pass
	
func _exit():
	pass

func dispatch(action: StringName):
	get_root().dispatch(action)

func named(new_name: String):
	name = new_name
	return self
