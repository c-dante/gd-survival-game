class_name SwordProjectile
extends Node2D

var target: Node2D
var rotation_speed = PI
var orbit_distance = 64
var orbit_speed = PI / 4
var angle: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D

func _physics_process(delta):
	# Always spinny sword
	_sprite.rotation += rotation_speed * delta

	if target:
		angle = wrap(angle + orbit_speed * delta, 0, TAU)
		position = target.position + orbit_distance * Vector2.from_angle(angle)
