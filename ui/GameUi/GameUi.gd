class_name GameUi
extends Control

var PauseIcon = preload("res://shared/sprites/ui/pause-flatdark.png")
var PlayIcon = preload("res://shared/sprites/ui/play-flatdark.png")

# Forwarded from button
signal new_game()
signal level_up()
signal toggle_pause()
signal end_run()
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

@onready var desktop = $MarginContainer/Control/Desktop
@onready var mobile = $MarginContainer/Control/Mobile

@onready var _speed_slider = $MarginContainer/Control/Desktop/LeftGrid/Speed/Slider
@onready var _game_speed_slider = $MarginContainer/Control/Desktop/LeftGrid/GameSpeed/Slider
@onready var _zoom_slider = $MarginContainer/Control/Desktop/LeftGrid/Zoom/Slider

@onready var _physics_fps = $MarginContainer/Control/Desktop/RightGrid/PhysicsFps/Value
@onready var _fps = $MarginContainer/Control/Desktop/RightGrid/Fps/Value
@onready var _play_time = $MarginContainer/Control/Desktop/RightGrid/PlayTime/Value
@onready var _game_state = $MarginContainer/Control/Desktop/RightGrid/GameState/Value

# HP/XP are on both screens
@onready var _hp_xp_container = $MarginContainer/Control/CenterGrid
@onready var _health_bar = $MarginContainer/Control/CenterGrid/Health/Bar
@onready var _exp_bar = $MarginContainer/Control/CenterGrid/Experience/Bar

@onready var pause_underlay = $Paused
@onready var pause_btn = $MarginContainer/Control/Desktop/LeftGrid/HFlowContainer/PauseBtn
@onready var pause_btn_mobile = $MarginContainer/Control/Mobile/HFlowContainer/PauseBtn

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_control_values()
	
	set_pause_state(false)
	
	_on_display_display_mode_changed(Display.CurrentMode)
	
	if game_hsm && game_hsm.is_active():
		_game_state.text = game_hsm.get_active_state().name

func _init_control_values():
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

func _process(delta):
	_fps.text = fmt_delta_fps(delta)
	_play_time.text = Format.format_elapsed_time(Global.game_stats.play_time_seconds)

func _physics_process(delta):
	_physics_fps.text = fmt_delta_fps(delta)
	lerp_bar(_health_bar, player.get_node("Health").health, delta)
	lerp_bar(_exp_bar, player.experience, delta)

func lerp_bar(bar: Range, target, delta):
	bar.value = lerp(bar.value, float(target), delta)

func fmt_delta_fps(delta: float):
	return "%7.2fs" % snappedf(1.0 / delta, 0.05)

func set_pause_state(is_paused: bool):
	if is_paused:
		pause_btn.text = "Resume"
		pause_btn_mobile.icon = PlayIcon
		pause_underlay.show()
	else:
		pause_btn.text = "Pause"
		pause_btn_mobile.icon = PauseIcon
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

func _on_end_run_pressed():
	end_run.emit()

func _on_active_state_changed(current: StateNode, _previous: StateNode):
	_game_state.text = current.name

func _on_display_display_mode_changed(display_mode: Display.DisplayMode):
	match display_mode:
		Display.DisplayMode.LANDSCAPE:
			desktop.visible = true
			mobile.visible = false
			_hp_xp_container.custom_minimum_size.x = 256
			return
		Display.DisplayMode.PORTRAIT:
			desktop.visible = false
			mobile.visible = true
			_hp_xp_container.custom_minimum_size.x = 512
			return
		_:
			push_warning("Unhandled display mode: ", display_mode)
