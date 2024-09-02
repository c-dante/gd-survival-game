class_name SpriteMove
extends Node

@export_group("Nodes")
@export var body: Node2D
@export var animated: AnimatedSprite2D

@export_group("Speed")
@export var min_speed: float = 0
@export var max_speed: float = 100
@export var speed: float = 20

var input_vector: Vector2 = Vector2.ZERO

func tick(_delta: float) -> Vector2:
	var _speed = speed * Global.game_speed
	
	var output_vector = Vector2.ZERO
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		output_vector = input_vector * _speed;
	
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

func set_speed(value: float):
	speed = value
	_update_animation_speed(Global.game_speed)

func _update_animation_speed(game_speed):
	var desired = ease(speed / max_speed, -0.2) * 5
	animated.speed_scale = clamp(snapped(desired, 0.1), 0.3, 5) * game_speed;

func _ready():
	Global.on_game_speed_change.connect(_update_animation_speed)
