class_name SpriteMove
extends Node

@export_group("Nodes")
@export var body: CharacterBody2D
@export var animated: AnimatedSprite2D

@export_group("Speed")
@export var min_speed: float = 0
@export var max_speed: float = 100
@export var speed: float = 20

var input_vector: Vector2 = Vector2.ZERO

func tick(_delta: float):
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

		# Calculate velocity based on angle
		# Move the character
		body.set_velocity(input_vector * speed);
	else:
		# Stop the character if there's no input
		body.velocity.x = move_toward(body.velocity.x, 0, speed);
		body.velocity.y = move_toward(body.velocity.y, 0, speed);
	
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

func set_speed(value: float):
	speed = value
	
	var desired = ease(speed / max_speed, -0.2) * 5
	animated.speed_scale = clamp(snapped(desired, 0.1), 0.3, 5);
	
