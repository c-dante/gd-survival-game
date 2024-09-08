extends Control

signal new_game(seed: int)

@onready var _seed_input = $MarginContainer/Control/CenterContainer/VBoxContainer/Seed/Value

func _ready():
	randomize_seed()

func randomize_seed():
	_seed_input.text = Global.int_to_base62_str(randi())

func _on_new_game_btn_pressed():
	new_game.emit(Global.base62_str_to_int(_seed_input.text))

func _on_randomize_seed_pressed():
	randomize_seed()
