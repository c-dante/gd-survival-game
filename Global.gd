extends Node

# Group names to help with cleanup and such
const GROUP_ENEMIES = "Enemies"
const GROUP_PICKUPS = "Pickups"
const GROUP_WEAPONS = "Weapons"

# Navigation collision
const LAYER_PLAYER_MOVE = 1

# Things the player can touch
const LAYER_PLAYER_INTERACT = 2

# The player's hitbox
const LAYER_PLAYER_HITBOX = 4

# Enemies listen for hits on this layer
const LAYER_ENEMY_HIT = 9

# Enemies bounce off each other -- pushes enemies away
const LAYER_ENEMY_PUSH = 13

# Game Stats
func _ready():
	reset()

var game_stats = {}
func reset():
	game_stats = {
		"dmg_taken": 0,
		"dmg_delt": 0,
		"kills": 0,
		"player_level": 0,
		"killed_by": ""
	}

# Utility Methods
## Wipes all the connections from a signal
func clear_connections(from: Signal):
	for dict in from.get_connections():
		from.disconnect(dict["callable"])
