extends Node

@export_flags_2d_physics var overlap_layers: int;
@export var body: CharacterBody2D;
@export var push_speed: float = 20.0

var _overlapping_areas = {}

func tick(_delta):
	var push = _handle_overlaps()
	if push != Vector2.ZERO:
		body.velocity = push
		body.move_and_slide()

func _handle_overlaps() -> Vector2:
	if _overlapping_areas.is_empty():
		return Vector2.ZERO
	
	# Find the closest overlap
	var closest_d = INF
	var closest = INF
	for key in _overlapping_areas:
		var node: Node2D = _overlapping_areas[key]
		var d = body.global_position.distance_squared_to(node.global_position)
		if d < closest_d:
			closest_d = d
			closest = node

	# Return a vector pushing away
	return -Vector2.from_angle(body.get_angle_to(closest.position)) * push_speed * Global.game_speed

func on_area_enter(area: Area2D):
	if area.collision_layer & overlap_layers:
		_overlapping_areas[area.get_instance_id()] = area.get_parent()

func on_area_exit(area: Area2D):
	_overlapping_areas.erase(area.get_instance_id())
