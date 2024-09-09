@tool
class_name Playground
extends EditorScript

func _init():
	print(randi_range(0, 1))
	
	var x = Pickup.PickupKind.EXP
	match x:
		Pickup.PickupKind.HEALTH:
			print("hp")
		Pickup.PickupKind.EXP:
			print("exp")
