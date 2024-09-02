class_name Damaging
extends Node

@export var damage: int = 10;

func on_body_enter(body: Node2D):
	var health: Health = body.get_node("Health")
	if health != null:
		health.update_health(-damage, get_parent())
