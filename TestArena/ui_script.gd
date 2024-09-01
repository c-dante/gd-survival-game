extends Control

@export var sprite_move: SpriteMove
@export var camera: Camera2D

@onready var _speed_slider = $GridContainer/Speed/Slider
@onready var _game_speed_slider = $GridContainer/GameSpeed/Slider
@onready var _zoom_slider = $GridContainer/Zoom/Slider

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Speed
	_speed_slider.value = sprite_move.speed
	_speed_slider.min_value = sprite_move.min_speed
	_speed_slider.max_value = sprite_move.max_speed
	
	# Set Zoom
	_zoom_slider.value = camera.zoom.x
	
	# Set Game Speed
	_game_speed_slider.value = Global.game_speed

func _on_speed_change(value):
	sprite_move.set_speed(value)

func _on_zoom_change(value):
	camera.zoom = Vector2(value, value)

func _on_game_speed_change(value):
	Global.set_game_speed(value)
