class_name Spawner
extends Node

const GAME_LENGTH = 5.0

@onready var timer: Timer = $SpawnTimer

@export var spawn_rate: Curve:
	set(new_value):
		spawn_rate = new_value
		update_timer()
	
func _ready():
	update_timer()
	
func update_timer():
	if !timer:
		return
		
	print(spawn_rate, " ", Global.game_stats["play_time"])
	timer.start(10.0)


func _on_debug_timer_timeout():
	var game_time_20_min = Global.game_stats["play_time"] / (GAME_LENGTH * 60.0)
	print(snapped(spawn_rate.sample(game_time_20_min), 0.05))
