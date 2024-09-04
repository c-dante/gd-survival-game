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

# Game Over Screen
@onready var _game_over = $GameOver
@onready var _game_over_killed_by = $GameOver/Centered/MarginContainer/VBoxContainer/Killer/Value
@onready var _game_over_damage = $GameOver/Centered/MarginContainer/VBoxContainer/Damage/Value
@onready var _game_over_level = $GameOver/Centered/MarginContainer/VBoxContainer/Level/Value
@onready var _game_over_defeated = $GameOver/Centered/MarginContainer/VBoxContainer/Defeated/Value
@onready var _game_over_dealt = $GameOver/Centered/MarginContainer/VBoxContainer/DamageDealt/Value
@onready var _game_over_survived = $GameOver/Centered/MarginContainer/VBoxContainer/Survived/Value

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
	
	# Clear game over screen
	hide_game_over()

func _on_speed_change(value):
	sprite_move.set_speed(value)

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

func show_game_over():
	_game_over.show()
	_game_over_killed_by.text = "%s" % Global.game_stats["killed_by"]
	_game_over_damage.text = "%s" % Global.game_stats["dmg_taken"]
	_game_over_level.text = "%s" % Global.game_stats["player_level"]
	_game_over_defeated.text = "%s" % Global.game_stats["kills"]
	_game_over_dealt.text = "%s" % Global.game_stats["dmg_delt"]
	
	var seconds = Global.game_stats["play_time"]
	var hours = snapped(seconds / 3600.0, 0)
	seconds -= hours * 3600
	var mins = snapped(seconds / 60.0, 0)
	seconds -= mins * 60
	_game_over_survived.text = "%dh %dm %ds" % [hours, mins, seconds]

func hide_game_over():
	_game_over.hide()

func _on_new_game_pressed():
	new_game.emit()

func _on_level_up_btn_pressed():
	level_up.emit()
