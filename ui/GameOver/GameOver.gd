class_name GameOver
extends Control

# Game Over Screen
@onready var _game_over_killed_by = $Centered/MarginContainer/VBoxContainer/Killer/Value
@onready var _game_over_damage = $Centered/MarginContainer/VBoxContainer/Damage/Value
@onready var _game_over_level = $Centered/MarginContainer/VBoxContainer/Level/Value
@onready var _game_over_defeated = $Centered/MarginContainer/VBoxContainer/Defeated/Value
@onready var _game_over_dealt = $Centered/MarginContainer/VBoxContainer/DamageDealt/Value
@onready var _game_over_survived = $Centered/MarginContainer/VBoxContainer/Survived/Value

signal new_game();

func _on_visibility_changed():
	if is_node_ready() && visible:
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


func _on_new_game_pressed():
	new_game.emit()
