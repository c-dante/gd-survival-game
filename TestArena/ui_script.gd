class_name GameUi
extends Control

# Forwarded from button
signal new_game()
signal level_up()

@export var sprite_move: SpriteMove
@export var camera: Camera2D
@export var player: Player

@onready var _speed_slider = $LeftGrid/Speed/Slider
@onready var _game_speed_slider = $LeftGrid/GameSpeed/Slider
@onready var _zoom_slider = $LeftGrid/Zoom/Slider

@onready var _physics_fps = $RightGrid/PhysicsFps/PhysicsFpsLabel
@onready var _fps = $RightGrid/Fps/FpsLabel

@onready var _health_bar = $CenterGrid/Health/Bar
@onready var _exp_bar = $CenterGrid/Experience/Bar


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Speed
	_speed_slider.value = sprite_move.speed
	_speed_slider.min_value = sprite_move.min_speed
	_speed_slider.max_value = sprite_move.max_speed
	
	# Set Zoom
	_zoom_slider.value = camera.zoom.x
	
	# Set Game Speed
	_game_speed_slider.value = Engine.time_scale
	
	# Set health + xp
	_health_bar.value = player.get_node("Health").health
	_exp_bar.value = player.experience

func _on_speed_change(value):
	sprite_move.speed = value

func _on_zoom_change(value):
	camera.zoom = Vector2(value, value)

func _on_game_speed_change(value):
	Engine.time_scale = value

func _process(delta):
	_fps.text = fmt_delta_fps(delta)
	_health_bar.value = player.get_node("Health").health
	_exp_bar.value = player.experience

func _physics_process(delta):
	_physics_fps.text = fmt_delta_fps(delta)

func fmt_delta_fps(delta: float):
	return "%7.2fs" % snappedf(1.0 / delta, 0.05)

func _on_new_game_pressed():
	new_game.emit()

func _on_level_up_btn_pressed():
	level_up.emit()
