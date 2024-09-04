class_name Enemy
extends AnimatableBody2D

@export var target: Node2D
@onready var _sprite_move = $SpriteMove
@onready var _overlap_pusher = $OverlapPusher

func _physics_process(delta):
	if target:
		_sprite_move.input_vector = Vector2.from_angle(get_angle_to(target.position))
	
	var move = _sprite_move.tick(delta)
	var push = _overlap_pusher.tick(delta)
	
	if move != Vector2.ZERO:
		position += move * delta
	
	if push != Vector2.ZERO:
		position += push * delta

func _on_health_on_death(_target, _killer):
	queue_free()

# TODO: Refactor health/damage to reflect on aggregates on declare side instead of on usage side
func _on_health_on_change(change, _value):
	Global.game_stats["dmg_delt"] += abs(change)
