extends Node2D

@onready var sprite = $arena/Sprite2D
@onready var acc_slider = $ui/Control/MarginContainer/VBoxContainer/HBoxContainer/Acceleration
@onready var arena = $arena
@onready var hammer = $arena/Hammer

const SPEED = 100
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		sprite.position += Vector2.LEFT * delta * SPEED
	if Input.is_action_pressed("ui_right"):
		sprite.position += Vector2.RIGHT * delta * SPEED
	if Input.is_action_pressed("ui_down"):
		sprite.position += Vector2.DOWN * delta * SPEED
	if Input.is_action_pressed("ui_up"):
		sprite.position += Vector2.UP * delta * SPEED
