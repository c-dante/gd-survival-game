class_name Effects
extends Node2D

const ExplosionScene: PackedScene = preload("res://Explosion/Explosion.tscn")

# Object pool for particle effects, maintaining a max size in the pool but always bursting as high as it needs
const MAX_PARTICLE_POOL = 50

var particle_pool = []

func explode(pos: Vector2):
	var explosion: Explosion = particle_pool.pop_front()
	if explosion == null:
		explosion = ExplosionScene.instantiate()
		explosion.finished.connect(
			func ():
				if particle_pool.size() > MAX_PARTICLE_POOL:
					explosion.queue_free()
				else:
					particle_pool.push_back(explosion)
		)
		add_child(explosion)
	
	explosion.fire_at(pos)
