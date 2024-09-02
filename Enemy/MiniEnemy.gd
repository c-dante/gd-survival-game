class_name MiniEnemy
extends Node2D

@export var target: Node2D
@onready var _sprite_move = $SpriteMove
@onready var _overlap_pusher = $OverlapPusher

func _physics_process(delta):
	if target:
		_sprite_move.input_vector = Vector2.from_angle(get_angle_to(target.position))
	
	var movement = _sprite_move.tick(delta)
	var pushed = _overlap_pusher.tick(delta)
	if pushed != Vector2.ZERO:
		position += pushed * delta
	else:
		position += movement * delta
