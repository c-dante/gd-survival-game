extends Node2D

@onready var sprite = $arena/Sprite2D
@onready var hammer = $arena/HammerProjectile
@onready var acc_slider = $ui/Control/MarginContainer/VBoxContainer/HBoxContainer/Acceleration
@onready var scale_slider = $ui/Control/MarginContainer/VBoxContainer/HBoxContainer2/Scale

# Called when the node enters the scene tree for the first time.
func _ready():
	acc_slider.value = hammer.acceleration
	scale_slider.value = hammer.acc_range

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

func _on_acceleration_value_changed(value):
	hammer.acceleration = value

func _on_scale_value_changed(value):
	hammer.acc_range = value
