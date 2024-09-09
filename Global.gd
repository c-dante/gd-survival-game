extends Node

# Group names to help with cleanup and such
const GROUP_ENEMIES = &"Enemies"
const GROUP_PICKUPS = &"Pickups"
const GROUP_WEAPONS = &"Weapons"

## Navigation collision
const LAYER_PLAYER_MOVE = 1
## Things the player can touch
const LAYER_PLAYER_INTERACT = 2
## The player's hitbox
const LAYER_PLAYER_HITBOX = 4
## Enemies listen for hits on this layer
const LAYER_ENEMY_HIT = 9
## Enemies bounce off each other -- pushes enemies away
const LAYER_ENEMY_PUSH = 13

# Noting down z-index stuff
## blaze, pickup
const Z_INDEX_FLOOR = 5
## enemy, player
const Z_INDEX_WALK = 10
## sword, explosion
const Z_INDEX_FLOAT = 20

func _ready():
	reset()

## Global game stats
var game_stats = {
	"seed": 0,
}

## Reset global game stats
func reset():
	game_stats = {
		"seed": game_stats["seed"], # oof, this hack
		"enemy_count": 0,
		"play_time": 0,
		"dmg_taken": 0,
		"dmg_delt": 0,
		"kills": 0,
		"player_level": 0,
		"killed_by": "",
		"heirloom": 0,
	}

# Utility Methods
## Wipes all the connections from a signal
func clear_connections(from: Signal):
	for dict in from.get_connections():
		from.disconnect(dict["callable"])

## Removes all nodes in a group from the scene tree and frees them
func clear_group(group: StringName):
	for node in get_tree().get_nodes_in_group(group):
		if node.get_parent():
			node.get_parent().remove_child(node)
		node.queue_free()

## Get the diff of 2 numbers as a % change
func diff_percent(new: Variant, old: Variant) -> float:
	if old == 0:
		return 0.0

	return (new - old) / float(old)

## Generate a random point in a rectangle
func pt_in_rect(rect: Rect2, margin: float = 1.0) -> Vector2:
	var normalized = Vector2(
		randf_range(margin, rect.size.x - margin),
		randf_range(margin, rect.size.y - margin)
	)
	return rect.position + normalized

const BASE62_CHARSET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

## Convert a string to a base62 intger
func base62_str_to_int(base62_str: String) -> int:
	const base = 62
	var result = 0
	var power = base62_str.length() - 1
	
	for i in range(base62_str.length()):
		var idx = BASE62_CHARSET.find(base62_str[i])
		if idx == -1:
			idx = 0
		result += idx * (base ** power)
		power -= 1
	
	return result

## Convert an integer into a base62 string
func int_to_base62_str(number: int) -> String:
	const base = 62
	var result = ""
	while number > 0:
		var remainder = number % base
		result = BASE62_CHARSET[remainder] + result
		number = floor(number / base)
	return result

## Pauses the game only if the game tree exists
func safe_pause(paused: bool):
	if get_tree():
		get_tree().paused = paused
