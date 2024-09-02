class_name Sword
extends Node2D

@export var target: Node2D

@export_group("Rotation")
@export var rotation_speed = PI
@export var orbit_distance = 64
@export var orbit_speed = PI / 4
@export var angle: float = 0.0

@onready var _sprite: Sprite2D = $Sprite2D

func _physics_process(delta):
	var _delta = delta * Global.game_speed
	# Always spinny sword
	_sprite.rotation += rotation_speed * _delta

	if target:
		angle = wrap(angle + orbit_speed * _delta, 0, TAU)
		position = target.position + orbit_distance * Vector2.from_angle(angle)
