class_name Hammer
extends Weapon

const HammerProjectileScene: PackedScene = preload("res://weapons/Hammer/HammerProjectile.tscn")
const HammerTx: Texture2D = preload("res://weapons/Hammer/Hammer.png")

static func AcquireChoice() -> LevelUp.Choice:
	return LevelUp.Choice.new("Hammer", HammerTx, "Hammers are heavy and so are you", 1, {
		"type": LevelUp.ChoiceType.WeaponAcquire,
		"weapon_type": WeaponType.Hammer
	})
	
func get_type():
	return WeaponType.Hammer

class HammerProps:
	var num_hammers: int = 1
	var rotation_speed: float = PI
	var knockback: float = 10.0
	
	func _init(_num_hammers, _rotation_speed: float, _knockback: float):
		num_hammers = _num_hammers
		rotation_speed = _rotation_speed
		knockback = _knockback
		
	func level_up_description(current_props: HammerProps) -> String:
		var out = []

		var num_hammers_buff = num_hammers - current_props.num_hammers
		if num_hammers_buff > 0:
			out.push_back("+%d swords" % num_hammers_buff)

		var knockback_buff = Global.diff_percent(knockback, current_props.knockback)
		if !is_zero_approx(knockback_buff):
			out.push_back("%s kockback" % Format.format_percent(knockback_buff))
		
		return "\n".join(out)

var LevelProps: Array[HammerProps] = [
	HammerProps.new(1, PI, 10.0),
	HammerProps.new(1, PI, 20.0),
]
func get_level_props():
	return LevelProps

var _target: Node2D
@export var target: Node2D:
	get:
		return _target
	set(value):
		_target = value
		for hammer: SwordProjectile in get_children():
			hammer.target = value

# _level from Weapon
func set_level(level: int):
	_level = clamp(level, 1, LevelProps.size())
	var props = LevelProps[_level - 1]

	var children = get_children()	
	for child_idx in props.num_hammers:
		# Make and add a sword
		if child_idx >= children.size():
			var new_hammer = HammerProjectileScene.instantiate()
			children.push_back(new_hammer)
			add_child(new_hammer)
		
		# Set the props -- upgrade all hammers
		var hammer: HammerProjectile = children[child_idx]
		hammer.rotation_speed = props.rotation_speed
		hammer.knockback = props.knockback
		hammer.target = target
	
	# Clean up extra children in case of level down
	while children.size() > props.num_hammers:
		children.pop_back().queue_free()

func make_choices(now_props: Variant, next_props: Variant) -> Array[LevelUp.Choice]:
	var desc = next_props.level_up_description(now_props)
	return [
		LevelUp.Choice.new("Upgrade Hammer", HammerTx, desc, _level + 1, {
			"type": LevelUp.ChoiceType.WeaponUpgrade,
			"weapon": self
		})
	]

func _ready():
	set_level(1)
