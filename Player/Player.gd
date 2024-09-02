class_name Player
extends CharacterBody2D

@onready var _sprite_move = $SpriteMove

var experience: int = 0

func _physics_process(_delta):
	_sprite_move.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_sprite_move.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = _sprite_move.tick(_delta)
	
	if move_and_slide():
		_handle_collision()

func _handle_collision():
	print(get_slide_collision_count())

func _on_pickup_area_area_entered(area):
	var pickup: Pickup = area.owner
	if pickup.kind == Pickup.PickupKind.EXP:
		experience += 10
		# TODO: Fun pickup animation, fly to the bar or to the player or something
		pickup.queue_free()
	else:
		print("Unhandled pickup: ", pickup)
