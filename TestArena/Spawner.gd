class_name Spawner
extends Node

@export var spawn_rate: Curve:
	set(new_value):
		spawn_rate = new_value
		_update_rate()

func _update_rate():
	print(spawn_rate)
	print(spawn_rate.min_value, ", ", spawn_rate.max_value)
	spawn_rate.bake()
	for i in range(0, 100):
		print(snapped(spawn_rate.sample(i/100.0), 0.01), "  |  ", snapped(spawn_rate.sample_baked(i/100.0), 0.01))
	
