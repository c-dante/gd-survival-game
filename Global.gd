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
const STAT_SEED = "game_seed"
const STAT_ENEMY_COUNT = "enemy_count"
const STAT_PLAY_TIME = "play_time"

class Stats:
	var game_seed: int = 0
	var enemy_count: int = 0
	var play_time_seconds: float = 0.0
	var max_game_time_seconds: float = 60.0 * 10.0
	var dmg_taken: int = 0
	var dmg_delt: int = 0
	var kills: int = 0
	var player_level: int = 0
	var killed_by: String = ""
	var heirloom: int = 0
	
	func play_time_percent() -> float:
		return play_time_seconds / max_game_time_seconds

var game_stats = Stats.new()

## Reset global game stats
func reset():
	var last_seed = game_stats.game_seed
	game_stats = Stats.new()
	game_stats.game_seed = last_seed

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

## Helper to randomize with success percent
## probability: 0 to 1, inclusive, of success probability
## success: return value if randf() <= probability
## fail: otherwise value
func rand_success(probability: float, success: Variant = true, fail: Variant = false) -> Variant:
	if randf() <= probability:
		return success
	return fail

## Returns a float rounded up or down based on the 
## fractional part, so, 1.23 is 1 or 23% change of 2
## Similarly, -42.69 is -43 69% of the time and -42 the rest
func rand_bump(partial: float):
	var aligned = snappedi(partial, 1)
	var remain = partial - aligned
	if aligned == partial:
		return partial
	return aligned + rand_success(abs(remain), sign(aligned), 0)

## Pauses the game only if the game tree exists
func safe_pause(paused: bool):
	if get_tree():
		get_tree().paused = paused
