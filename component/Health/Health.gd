class_name Health
extends Node

@export var max_health: int = 100;
@export var health: int = 10;

signal on_change(change: int, value: int)
signal on_death(target: Node, killer: Node);

func update_health(change: int, origin: Node):
	set_health(health + change, origin)

func set_health(value: int, origin: Node):
	if can_process():
		var new_health = clamp(value, 0, max_health)
		var change = value - new_health
		health = new_health
		on_change.emit(change, health)
		if health <= 0:
			on_death.emit(owner, origin)
