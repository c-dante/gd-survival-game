class_name Player
extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const MIN_SPEED: int = 10
const MAX_SPEED: int = 500
const BASE_SPEED: int = 50
var _speed: float = 100.0

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

		# Calculate velocity based on angle
		# Move the character
		set_velocity(input_vector * _speed);
	else:
		# Stop the character if there's no input
		velocity.x = move_toward(velocity.x, 0, _speed);
		velocity.y = move_toward(velocity.y, 0, _speed);
	
	if input_vector.x > 0:
		_animated_sprite.play("walk_right")
	elif input_vector.x < 0:
		_animated_sprite.play("walk_left")
	elif input_vector.y > 0:
		_animated_sprite.play("walk_down")
	elif input_vector.y < 0:
		_animated_sprite.play("walk_up")
	else:
		_animated_sprite.play("default")

	move_and_slide()
	
	
func set_speed(value: float):
	_speed = value
	
	var desired = ease(_speed / MAX_SPEED, -0.2) * 5
	_animated_sprite.speed_scale = clamp(snapped(desired, 0.1), 0.3, 5);
	
