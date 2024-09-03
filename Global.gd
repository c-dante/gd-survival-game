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

## When there's an action to perform on an interval
## Pass in the current "until next" in ms, delta seconds, and a lambda if it should trigger
## Returns the remaining timeout
## This accounts for multiple "procs" in an interval, passing in the remaining time
## Return explicitly "false" from the Callable to exit the interval
## reset_ms      = What to reset the interval to if it procs
## until_next_ms = Remaining time
#func interval_action(
	#reset_ms: int,
	#until_next_ms: int,
	#delta_s: float,
	#proc: Callable
#):
	#var remaining = until_next_ms - delta_s * game_speed * 1000
	## Do this in a loop in case we missed dots between deltas
	## For example, if delta_ms = 1000 and our dot is every 10 ms, we deal 100 ticks!
	#while remaining <= 0:
		#if proc.call(remaining) == false:
			#return remaining
		#remaining = damage_interval_ms + target["timeout"] 
