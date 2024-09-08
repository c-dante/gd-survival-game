class_name Player
extends CharacterBody2D

@onready var _sprite_move: SpriteMove = $SpriteMove
@onready var _health: Health = $Health

@export var damage_enabled: bool = true:
	set(value):
		if _health:
			if value:
				_health.process_mode = Node.PROCESS_MODE_INHERIT
			else:
				_health.process_mode = Node.PROCESS_MODE_DISABLED
		damage_enabled = value

signal on_level_up(level: int, player: Player)

## A map of "source" -> int for movement speed buffs
var _speed_buffs = {}
var experience: int = 0
var level = 0

## TODO (code-game): Move this outta' the player?
func _process(delta):
	Global.game_stats["play_time"] += delta

func _physics_process(delta):
	_sprite_move.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_sprite_move.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = _sprite_move.tick(delta)
	
	# TODO: Move into a plugin for damage taking?
	modulate = lerp(modulate, Color.WHITE, 0.8 * delta)
	
	move_and_slide()

func reset():
	modulate = Color.WHITE
	experience = 0
	level = 0
	_speed_buffs = {}
	_health.health = 100
	_health._alive = true

func add_speed_buff(name: String, value: float):
	_speed_buffs[name] = value
	var total_buffs = _speed_buffs.values().reduce(func (a, b): return a + b, 0)
	_sprite_move.speed_adjustment = total_buffs

func _on_pickup_area_area_entered(area):
	var pickup: Pickup = area.owner
	if pickup.kind == Pickup.PickupKind.EXP:
		experience += 10
		if experience >= 100:
			experience = 0
			level += 1
			Global.game_stats["player_level"] = level
			on_level_up.emit(level, self)
		# TODO: Fun pickup animation, fly to the bar or to the player or something
		pickup.queue_free()
	else:
		print("Unhandled pickup: ", pickup)


func _on_health_on_change(change, _value):
	if change < 0:
		Global.game_stats["dmg_taken"] += abs(change)
		modulate = Color.CRIMSON
