class_name Blaze
extends Weapon

const BlazeTx = preload("res://weapons/Blaze/BlazeSprite.tres")

@export var target: Node2D

class BlazeProps:
	var damage: int
	var damage_rate_ms: int
	var duration_ms: int
	var drop_rate_ms: int

	func _init(_damage, _damage_rate_ms, _duration_ms, _drop_rate_ms):
		damage = _damage
		damage_rate_ms = _damage_rate_ms
		duration_ms = _duration_ms
		drop_rate_ms = _drop_rate_ms

	func level_up_description(current: BlazeProps) -> String:
		return "TODO"

var BlazeLevels = [
	BlazeProps.new(1, 200, 300, 150),
	BlazeProps.new(1, 200, 600, 150),
	BlazeProps.new(1, 200, 1000, 150),
	BlazeProps.new(1, 200, 2500, 150),
	BlazeProps.new(1, 200, 2500, 150),
	BlazeProps.new(1, 200, 3000, 100),
]
func get_level_props():
	return BlazeLevels

func make_choices(now_props: Variant, next_props: Variant) -> Array[LevelUp.Choice]:
	var desc = next_props.level_up_description(now_props)
	return [
		LevelUp.Choice.new("Upgrade Blaze", BlazeTx, desc, _level + 1, self)
	]

func set_level(level: int):
	_level = clamp(level, 1, BlazeLevels.size())
	var props = BlazeLevels[_level - 1]

func _ready():
	set_level(1)

var _spawn_timeout = 0
func _process(delta):
	var props = BlazeLevels[_level - 1]
