class_name HammerProjectile
extends CharacterBody2D

@export var target: Node2D
var rotation_speed = PI
var knockback = 10.0

@onready var _sprite: Sprite2D = $Sprite2D

var acceleration = 100
var min_acceleration = 100
var acc_range = 25
var last_direction = Vector2.ZERO

const MAX_VELOCITY = 100

func _physics_process(delta):
	# Always spinny effect
	_sprite.rotation += rotation_speed * delta

	if target:
		var d = global_position.distance_to(target.global_position)
		if d > acc_range:
			last_direction = global_position.direction_to(target.global_position)

	velocity = (velocity + last_direction * acceleration * delta).limit_length(MAX_VELOCITY)
	move_and_slide()
