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

# Noting down z-index stuff
## blaze, pickup
const Z_INDEX_FLOOR = 5
## enemy, player
const Z_INDEX_WALK = 10
## sword
const Z_INDEX_FLOAT = 20

# Game Stats
func _ready():
	reset()

var game_stats = {}
func reset():
	game_stats = {
		"play_time": 0,
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

func diff_percent(new: Variant, old: Variant) -> float:
	if old == 0:
		return 0.0

	return (new - old) / float(old)

func format_percent(percent: float) -> String:
	return "%d%%" % snapped(percent * 100, 1)

func format_elapsed_time(time_seconds: float) -> String:
	var seconds = Global.game_stats["play_time"]
	var hours = snapped(seconds / 3600.0, 0)
	seconds -= hours * 3600
	var mins = snapped(seconds / 60.0, 0)
	seconds -= mins * 60
	return "%dh %dm %ds" % [hours, mins, seconds]

## Generate a random point in a rectangle
func pt_in_rect(rect: Rect2, margin: float = 1.0) -> Vector2:
	var normalized = Vector2(
		randf_range(margin, rect.size.x - margin),
		randf_range(margin, rect.size.y - margin)
	)
	return rect.position + normalized
