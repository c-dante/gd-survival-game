extends Node

const LAYER_PLAYER_MOVE = 1
const LAYER_PLAYER_INTERACT = 2

const LAYER_ENEMY_HIT = 9
const LAYER_ENEMY_PUSH = 13

# Global Game Speed
signal on_game_speed_change(new_speed: float)

var game_speed = 1.0;
func set_game_speed(new_speed: float):
	game_speed = new_speed
	on_game_speed_change.emit(new_speed)

func _ready():
	set_game_speed(1.0)
