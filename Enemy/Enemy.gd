class_name Enemy
extends CharacterBody2D

@export var target: Node2D
@onready var _sprite_move = $SpriteMove

func _physics_process(delta):
	if target:
		_sprite_move.input_vector = Vector2.from_angle(get_angle_to(target.position))
	
	_sprite_move.tick(delta)
	move_and_slide()

func _on_area_2d_body_entered(body):
	print("Enemy Collide Body: ", body)

func _on_area_2d_area_entered(area):
	print("Enemy Collide Area: ", area)
