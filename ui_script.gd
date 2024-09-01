extends Control

@export var sprite_move: SpriteMove;

@onready var _speed_slider = $GridContainer/Speed/SpeedSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	_speed_slider.value = sprite_move.speed
	_speed_slider.min_value = sprite_move.min_speed
	_speed_slider.max_value = sprite_move.max_speed

func _on_speed_change(value):
	sprite_move.set_speed(value)
