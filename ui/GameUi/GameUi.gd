class_name GameUi
extends Control

# Forwarded from button
signal new_game()
signal level_up()
signal toggle_pause()
signal damage_toggle(toggled_on: bool)

@export var game_hsm: StateMachine:
	set(value):
		if game_hsm:
			game_hsm.active_state_changed.disconnect(_on_active_state_changed)
		if value:
			value.active_state_changed.connect(_on_active_state_changed)
		game_hsm = value
@export var sprite_move: SpriteMove
@export var camera: Camera2D
@export var player: Player

@onready var _speed_slider = $LeftGrid/Speed/Slider
@onready var _game_speed_slider = $LeftGrid/GameSpeed/Slider
@onready var _zoom_slider = $LeftGrid/Zoom/Slider

@onready var _physics_fps = $RightGrid/PhysicsFps/Value
@onready var _fps = $RightGrid/Fps/Value
@onready var _play_time = $RightGrid/PlayTime/Value
@onready var _game_state = $RightGrid/GameState/Value

@onready var _health_bar = $CenterGrid/Health/Bar
@onready var _exp_bar = $CenterGrid/Experience/Bar

@onready var pause_underlay = $Paused
@onready var pause_btn = $LeftGrid/HFlowContainer/PauseBtn

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
	
	set_pause_state(false)
	
	if game_hsm && game_hsm.is_active():
		_game_state.text = game_hsm.get_active_state().name

func _process(delta):
	_fps.text = fmt_delta_fps(delta)
	_play_time.text = Global.format_elapsed_time(Global.game_stats["play_time"])
	_health_bar.value = player.get_node("Health").health
	_exp_bar.value = player.experience

func _physics_process(delta):
	_physics_fps.text = fmt_delta_fps(delta)

func fmt_delta_fps(delta: float):
	return "%7.2fs" % snappedf(1.0 / delta, 0.05)

func set_pause_state(is_paused: bool):
	if is_paused:
		pause_btn.text = "Resume"
		pause_underlay.show()
	else:
		pause_btn.text = "Pause"
		pause_underlay.hide()

func _on_speed_change(value):
	sprite_move.speed = value

func _on_zoom_change(value):
	camera.zoom = Vector2(value, value)

func _on_game_speed_change(value):
	Engine.time_scale = value
	Engine.physics_ticks_per_second = 60 * min(1, snapped(value, 0.05))

func _on_new_game_pressed():
	new_game.emit()

func _on_level_up_btn_pressed():
	level_up.emit()

func _on_pause_btn_pressed():
	toggle_pause.emit()

func _on_player_damage_toggled(toggled_on):
	damage_toggle.emit(toggled_on)

func _on_active_state_changed(current: StateNode, _previous: StateNode):
	_game_state.text = current.name
