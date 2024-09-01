extends Control

@export var player: Player;

@onready var _speed_slider = $GridContainer/Speed/SpeedSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	_speed_slider.value = player._speed
	_speed_slider.min_value = player.MIN_SPEED
	_speed_slider.max_value = player.MAX_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_speed_change(value):
	player.set_speed(value)
