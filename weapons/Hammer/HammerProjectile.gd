class_name HammerProjectile
extends CharacterBody2D

signal hammer_complete(projectile: HammerProjectile)

const MAX_VELOCITY = 200

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _timer: Timer = $Timer

@export var target: Node2D
var rotation_speed = PI
var knockback = 10.0
var acceleration = 300
var direction: Vector2 = Vector2.ZERO
var lifetime_seconds = 5.0
var disappear_seconds = 2.0
var alive = true

func _ready():
	_timer.start(lifetime_seconds)

func _physics_process(delta):
	# Always spinny effect
	_sprite.rotation += rotation_speed * delta
	
	if !target:
		return
	
	# Fly toward the target, if alive
	if alive:
		direction = global_position.direction_to(target.position)
	
	velocity = (velocity + direction * acceleration * delta).limit_length(MAX_VELOCITY)
	move_and_slide()

func _on_timer_timeout():
	if alive:
		alive = false
		_timer.start(disappear_seconds)
	else:
		hammer_complete.emit()

func _on_damaging_on_target_acquire(target):
	var t = target as Node2D
	if t:
		var hit_strength = remap(velocity.length(), 0, MAX_VELOCITY, 0, knockback)
		t.position += velocity.normalized() * hit_strength
	
