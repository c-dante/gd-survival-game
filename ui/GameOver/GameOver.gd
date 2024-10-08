class_name GameOver
extends Control

# Game Over Screen
@onready var _game_over_killed_by = $Centered/Control/VBoxContainer/Killer/Value
@onready var _game_over_damage = $Centered/Control/VBoxContainer/Damage/Value
@onready var _game_over_level = $Centered/Control/VBoxContainer/Level/Value
@onready var _game_over_defeated = $Centered/Control/VBoxContainer/Defeated/Value
@onready var _game_over_dealt = $Centered/Control/VBoxContainer/DamageDealt/Value
@onready var _game_over_survived = $Centered/Control/VBoxContainer/Survived/Value
@onready var _game_over_heirloom = $Centered/Control/VBoxContainer/Heirloom/Value
@onready var _game_over_seed = $Centered/Control/VBoxContainer/Seed/Value

signal continue_game();

func _on_visibility_changed():
	if is_node_ready() && visible:
		_game_over_killed_by.text = "%s" % Global.game_stats.killed_by
		_game_over_damage.text = "%s" % Global.game_stats.dmg_taken
		_game_over_level.text = "%s" % Global.game_stats.player_level
		_game_over_defeated.text = "%s" % Global.game_stats.kills
		_game_over_dealt.text = "%s" % Global.game_stats.dmg_delt
		_game_over_survived.text = Format.format_elapsed_time(Global.game_stats.play_time_seconds)
		_game_over_heirloom.text = Format.format_number_grouped(Global.game_stats.heirloom)
		_game_over_seed.text = Global.int_to_base62_str(Global.game_stats.game_seed)

func _on_continue_pressed():
	continue_game.emit()

func _on_copy_seed():
	DisplayServer.clipboard_set(Global.int_to_base62_str(Global.game_stats.game_seed))
