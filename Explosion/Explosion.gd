class_name Explosion
extends Node2D

@onready var particles = $Particles

signal finished()

func _ready():
	particles.one_shot = true
	particles.finished.connect(finished.emit)

func fire_at(pos: Vector2):
	position = pos	
	particles.restart()
