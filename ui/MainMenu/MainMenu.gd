extends Control

signal new_game()

@onready var _seed_input = $MarginContainer/Control/CenterContainer/VBoxContainer/Seed/Value

func _ready():
	randomize_seed()

func randomize_seed():
	_seed_input.text = Global.int_to_base62_str(randi())

func _on_new_game_btn_pressed():
	new_game.emit()

func _on_randomize_seed_pressed():
	randomize_seed()
