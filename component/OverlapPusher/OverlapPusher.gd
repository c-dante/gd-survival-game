extends Node

const MAX_OVERLAPS = 5

@export_flags_2d_physics var overlap_layers: int;
@export var body: Node2D;
@export var source_area: Area2D;
@export var push_speed: float = 10.0

var _overlapping: Node2D

func tick(_delta):
	return _handle_overlaps()

func _handle_overlaps() -> Vector2:
	if _overlapping == null:
		return Vector2.ZERO
	
	# Return a vector pushing away
	return -Vector2.from_angle(body.get_angle_to(_overlapping.global_position)) * push_speed * Global.game_speed

func on_area_enter(area: Area2D):
	if area.collision_layer & overlap_layers:
		var target: Node2D = area.get_parent()
		if _overlapping == null:
			_overlapping = target
		elif _overlapping.global_position.distance_squared_to(body.global_position) > target.global_position.distance_squared_to(body.global_position):
			_overlapping = target

func on_area_exit(area: Area2D):
	if area.get_parent() == _overlapping:
		_overlapping = null
		for candidate in source_area.get_overlapping_areas():
			if candidate.collision_layer & overlap_layers:
				_overlapping = candidate.get_parent()
				return
