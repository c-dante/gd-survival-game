class_name Damaging
extends Node

@export var damage: int = 10;
@export var damage_rate_ms: int = 1000;

var targets = {}

func _process(delta):
	# Do nothing if I'm supposed to be dead
	if get_parent().is_queued_for_deletion():
		return

	# Capture keys becasuse removal while iterating is undefined
	var keys = targets.keys()
	for key in keys:
		var target = targets[key]
		# Clean up after ourself if the target is gone
		if !target || !target["health"] || target["health"].is_queued_for_deletion():
			target.erase(key)
		else:
			target["timeout"] -= delta * 1000
			# Do this in a loop in case we missed dots between deltas
			# For example, if delta_ms = 1000 and our dot is every 10 ms, we deal 100 ticks!
			while target["timeout"] <= 0:
				target["health"].update_health(-damage, get_parent())
				# Add the remainder so we don't cheap out due to lag for stacked missed DOTs
				target["timeout"] = damage_rate_ms + target["timeout"] 

func on_body_enter(body: Node2D):
	var health: Health = body.get_node("Health")
	if health != null:
		targets[body.get_instance_id()] = {
			"health": health,
			"timeout": 0
		}

func on_body_exit(body: Node2D):
	targets.erase(body.get_instance_id())
