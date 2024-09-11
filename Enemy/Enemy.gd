class_name Enemy
extends AnimatableBody2D

@export var target: Node2D
@export var level: int = 1:
	set(value):
		level = value
		set_level(value)

@onready var _sprite_move = $SpriteMove
@onready var _overlap_pusher = $OverlapPusher
@onready var _sprite = $AnimatedSprite2D
@onready var _health = $Health

func _ready():
	set_level(level)

func _physics_process(delta):
	if target:
		_sprite_move.input_vector = Vector2.from_angle(get_angle_to(target.position))
	
	var move = _sprite_move.tick(delta)
	var push = _overlap_pusher.tick(delta)
	
	if move != Vector2.ZERO:
		position += move * delta
	
	if push != Vector2.ZERO:
		position += push * delta

func set_level(level):
	if !_sprite:
		return

	match level:
		1:
			_health.health = 10
			_sprite_move.speed = 20
		2:
			_sprite.material = Shaders.get_outline(Color.BLUE)
			_health.health = 20
			_sprite_move.speed = 25
		3:
			_sprite.material = Shaders.get_outline(Color.GREEN)
			_health.health = 40
			_sprite_move.speed = 30
		_:
			_sprite.material = Shaders.get_outline(Color.RED)
			_health.health = 100
			_sprite_move.speed = 30
			

func _on_health_on_death(_target, _killer):
	queue_free()

# TODO: Refactor health/damage to reflect on aggregates on declare side instead of on usage side
func _on_health_on_change(change, _value):
	Global.game_stats["dmg_delt"] += abs(change)
