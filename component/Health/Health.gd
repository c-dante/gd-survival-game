class_name Health
extends Node

@export var max_health: int = 100;
@export var health: int = 10;

var _alive = true

signal on_change(change: int, value: int)
signal on_death(target: Node, killer: Node);

func update_health(change: int, origin: Node):
	set_health(health + change, origin)

func set_health(value: int, origin: Node):
	if can_process() && _alive:
		var new_health = clamp(value, 0, max_health)
		var change = new_health - health
		health = new_health
		on_change.emit(change, health)
		if health <= 0:
			_alive = false
			on_death.emit(owner, origin)
