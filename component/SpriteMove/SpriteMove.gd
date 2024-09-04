class_name SpriteMove
extends Node

@export_group("Nodes")
@export var body: Node2D
@export var animated: AnimatedSprite2D

@export_group("Speed")
@export var min_speed: float = 0
@export var max_speed: float = 100
@export var base_speed: float = 20

var _speed_adjustment: float = 0
@export var speed_adjustment: float:
	get:
		return _speed_adjustment
	set(value):
		_speed_adjustment = value
		update_animation()

## TODO (code-speed) this is funky, write of speed updates only base but read is adjusted...
var speed: float:
	get:
		return base_speed + speed_adjustment
	set(value):
		base_speed = value
		update_animation()
	
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	update_animation()

func tick(_delta: float) -> Vector2:	
	var output_vector = Vector2.ZERO
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		output_vector = input_vector * speed;
	
	if input_vector.x > 0:
		animated.play("walk_right")
	elif input_vector.x < 0:
		animated.play("walk_left")
	elif input_vector.y > 0:
		animated.play("walk_down")
	elif input_vector.y < 0:
		animated.play("walk_up")
	else:
		animated.play("default")
	
	return output_vector

func update_animation():
	if animated:
		var desired = ease(speed / max_speed, -0.2) * 5
		animated.speed_scale = clamp(snapped(desired, 0.1), 0.3, 5);
