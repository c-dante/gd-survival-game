extends Control

@export var sprite_move: SpriteMove
@export var camera: Camera2D

@onready var _speed_slider = $LeftGrid/Speed/Slider
@onready var _game_speed_slider = $LeftGrid/GameSpeed/Slider
@onready var _zoom_slider = $LeftGrid/Zoom/Slider
@onready var _physics_fps = $RightGrid/PhysicsFps/PhysicsFpsLabel
@onready var _fps = $RightGrid/Fps/FpsLabel

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

func _process(delta):
	_fps.text = fmt_delta_fps(delta)

func _physics_process(delta):
	_physics_fps.text = fmt_delta_fps(delta)

func fmt_delta_fps(delta: float):
	return "%7.2fs" % snappedf(1.0 / delta, 0.05)
