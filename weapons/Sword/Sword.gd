class_name Sword
extends Node2D

const SwordProjectileScene: PackedScene = preload("res://weapons/Sword/SwordProjectile.tscn")
const SwordTx: Texture2D = preload("res://weapons/Sword/SwordSprite.tres")

class SwordProps:
	var num_swords: int = 1
	var rotation_speed: float = PI
	var orbit_distance: float = 64
	var orbit_speed: float = PI / 4.0
	
	func _init(_num_swords, _rotation_speed: float, _orbit_distance: float, _orbit_speed: float):
		num_swords = _num_swords
		rotation_speed = _rotation_speed
		orbit_distance = _orbit_distance
		orbit_speed = _orbit_speed
		
	func level_up_description(current_props: SwordProps):
		var speed_buff = (orbit_speed - current_props.orbit_speed) / current_props.orbit_speed
		var num_swords_buff = num_swords - current_props.num_swords
		var out = []
		
		if num_swords_buff > 0:
			out.push_back("%d swords" % num_swords)
		
		if !is_zero_approx(speed_buff):
			out.push_back("spin %d%% faster" % snapped(speed_buff * 100, 1))
		
		return "\n".join(out)

var LevelProps: Array[SwordProps] = [
	SwordProps.new(1, PI, 50.0, PI / 4.0),
	SwordProps.new(2, PI, 50.0, PI / 4.0),
	SwordProps.new(3, PI, 50.0, PI / 4.0),
	SwordProps.new(3, TAU, 50.0, PI / 2.0),
	SwordProps.new(4, TAU, 50.0, PI / 2.0),
	SwordProps.new(5, TAU * 2, 50.0, PI),
]

var _target: Node2D
@export var target: Node2D:
	get:
		return _target
	set(value):
		_target = value
		for sword: SwordProjectile in get_children():
			sword.target = value

var _level: int = 1

func set_level(level: int):
	_level = clamp(level, 1, LevelProps.size())
	var props = LevelProps[_level - 1]
	var angle_step = TAU / props.num_swords
	
	var swords = get_children()	
	for sword_idx in props.num_swords:
		# Make and add a sword
		if sword_idx >= swords.size():
			var new_sword = SwordProjectileScene.instantiate()
			swords.push_back(new_sword)
			add_child(new_sword)
		
		# Set the props
		var sword: SwordProjectile = swords[sword_idx]
		sword.angle = sword_idx * angle_step
		sword.target = _target
		sword.orbit_distance = props.orbit_distance
		sword.orbit_speed = props.orbit_speed
		sword.rotation_speed = props.rotation_speed
	
	# Clean up extra swords in case of level down
	while swords.size() > props.num_swords:
		swords.pop_back().queue_free()

func get_choices() -> Array[LevelUp.Choice]:
	var next_level = _level + 1
	if next_level > LevelProps.size():
		return []

	var next_props = LevelProps[next_level - 1]
	var now_props = LevelProps[_level - 1]
	var desc = next_props.level_up_description(now_props)
	return [
		LevelUp.Choice.new("Upgrade Sword", SwordTx, desc, next_level, self)
	]

func _ready():
	set_level(1)
