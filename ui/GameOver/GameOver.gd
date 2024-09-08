class_name GameOver
extends Control

# Game Over Screen
@onready var _game_over_killed_by = $Centered/MarginContainer/VBoxContainer/Killer/Value
@onready var _game_over_damage = $Centered/MarginContainer/VBoxContainer/Damage/Value
@onready var _game_over_level = $Centered/MarginContainer/VBoxContainer/Level/Value
@onready var _game_over_defeated = $Centered/MarginContainer/VBoxContainer/Defeated/Value
@onready var _game_over_dealt = $Centered/MarginContainer/VBoxContainer/DamageDealt/Value
@onready var _game_over_survived = $Centered/MarginContainer/VBoxContainer/Survived/Value
@onready var _seed_input = $Centered/MarginContainer/VBoxContainer/Seed/Value

signal new_game(seed: int);

func _on_visibility_changed():
	if is_node_ready() && visible:
		_game_over_killed_by.text = "%s" % Global.game_stats["killed_by"]
		_game_over_damage.text = "%s" % Global.game_stats["dmg_taken"]
		_game_over_level.text = "%s" % Global.game_stats["player_level"]
		_game_over_defeated.text = "%s" % Global.game_stats["kills"]
		_game_over_dealt.text = "%s" % Global.game_stats["dmg_delt"]
		_game_over_survived.text = Global.format_elapsed_time(Global.game_stats["play_time"])
		_seed_input.text = Global.int_to_base62_str(Global.game_stats["seed"])

func _on_new_game_pressed():
	new_game.emit(Global.base62_str_to_int(_seed_input.text))

func _on_randomize_seed_pressed():
	_seed_input.text = Global.int_to_base62_str(randi())
