class_name BlazePatch
extends Node2D

@onready var timeout: Timer = $Timer
@onready var damaging: Damaging = $Damaging

@export var damage: int:
	get:
		return damaging.damage
	set(value):
		damaging.damage = value
		
@export var damage_rate_ms: int:
	get:
		return damaging.damage_rate_ms
	set(value):
		damaging.damage_rate_ms = value

@export var duration_ms: int:
	get:
		return timeout.wait_time * 1000.0
	set(value):
		timeout.start(value / 1000.0)

func _on_expire():
	queue_free()
