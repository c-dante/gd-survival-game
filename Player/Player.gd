class_name Player
extends CharacterBody2D

@onready var _sprite_move = $SpriteMove

func _physics_process(_delta):
	_sprite_move.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_sprite_move.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = _sprite_move.tick(_delta)
	
	if move_and_slide():
		_handle_collision()

func _handle_collision():
	print(get_slide_collision_count())
