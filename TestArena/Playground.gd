@tool
class_name Playground
extends EditorScript

func _init():		
	print(rand_bump(-123.99))
	
func rand_success(probability: float, success: Variant = true, fail: Variant = false) -> Variant:
	if randf() <= probability:
		return success
	return fail


func rand_bump(partial: float):
	var aligned = snappedi(partial, 1)
	var remain = partial - aligned
	if aligned == partial:
		return partial
	return aligned + rand_success(abs(remain), sign(aligned), 0)
