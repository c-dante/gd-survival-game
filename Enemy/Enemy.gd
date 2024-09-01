class_name Enemy
extends CharacterBody2D

func _physics_process(delta):
	pass

func _on_area_2d_body_entered(body):
	print(body)
