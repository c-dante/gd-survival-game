class_name Enemy
extends AnimatableBody2D

@export var target: Node2D
@onready var _sprite_move = $SpriteMove
@onready var _overlap_pusher = $OverlapPusher

func _physics_process(delta):
	if target:
		_sprite_move.input_vector = Vector2.from_angle(get_angle_to(target.position))
	
	var vector = _sprite_move.tick(delta) * delta
	vector += _overlap_pusher.tick(delta)
	position += vector
	print(vector)

func _on_area_2d_area_entered(area: Area2D):
	if area.get_collision_layer_value(Global.LAYER_ENEMY_HIT):
		print("Hit!")
