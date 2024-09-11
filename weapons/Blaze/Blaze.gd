class_name Blaze
extends Weapon

const BlazePatchScene = preload("res://weapons/Blaze/BlazePatch.tscn")
const BlazeTx = preload("res://weapons/Blaze/BlazeSprite.tres")

static func AcquireChoice() -> LevelUp.Choice:
	return LevelUp.Choice.new("Blaze", BlazeTx, "Put on some hot kicks\nAdd move speed and leave a fire trail", 1, {
		"type": LevelUp.ChoiceType.WeaponAcquire,
		"weapon_type": WeaponType.Blaze
	})

func get_type():
	return WeaponType.Blaze

@onready var _spawn_timer: Timer = $Timer

@export var target: Node2D

class BlazeProps:
	var damage: int
	var damage_rate_ms: int
	var duration_ms: int
	var drop_rate_ms: int
	var target_move_buff: int

	func _init(_damage, _damage_rate_ms, _duration_ms, _drop_rate_ms, _target_move_buff):
		damage = _damage
		damage_rate_ms = _damage_rate_ms
		duration_ms = _duration_ms
		drop_rate_ms = _drop_rate_ms
		target_move_buff = _target_move_buff

	func level_up_description(_current: BlazeProps) -> String:
		var out = []
		var dmg_diff = Global.diff_percent(damage, _current.damage)
		if !is_zero_approx(dmg_diff):
			out.push_back("+%s damage/tick" % Format.format_percent(dmg_diff))
			
		var duration_diff = Global.diff_percent(duration_ms, _current.duration_ms)
		if !is_zero_approx(duration_diff):
			out.push_back("last +%s longer" % Format.format_percent(duration_diff))
			
		var move_diff = Global.diff_percent(target_move_buff, _current.target_move_buff)
		if !is_zero_approx(move_diff):
			out.push_back("move faster")
		
		return "\n".join(out)

var BlazeLevels: Array[BlazeProps] = [
	BlazeProps.new(1, 500, 3000, 100, 10),
	BlazeProps.new(2, 500, 3000, 100, 10),
	BlazeProps.new(3, 500, 4000, 100, 10),
	BlazeProps.new(5, 500, 4000, 100, 20),
	BlazeProps.new(10, 500, 5000, 100, 20),
	BlazeProps.new(10, 500, 6000, 100, 30),
]
func get_level_props():
	return BlazeLevels

func make_choices(now_props: Variant, next_props: Variant) -> Array[LevelUp.Choice]:
	var desc = next_props.level_up_description(now_props)
	return [
		LevelUp.Choice.new("Upgrade Blaze", BlazeTx, desc, _level + 1, {
			"type": LevelUp.ChoiceType.WeaponUpgrade,
			"weapon": self
		})
	]

func set_level(level: int):
	_level = clamp(level, 1, BlazeLevels.size())
	var props = get_props() as BlazeProps
	_spawn_timer.wait_time = props.drop_rate_ms / 1000.0
	
	# TODO (code-speed): Spooky action at a distance
	if target.has_method("add_speed_buff"):
		target.add_speed_buff("blaze", props.target_move_buff)

func _ready():
	set_level(1)
	_spawn_timer.start()

func _exit_tree():
	if target && target.has_method("remove_speed_buff"):
		# TODO (code-speed): Spooky action at a distance
		target.remove_speed_buff("blaze")

func _on_drop_blaze():
	var props = get_props() as BlazeProps
	var new_blaze: BlazePatch = BlazePatchScene.instantiate()
	add_child(new_blaze)
	new_blaze.position = target.position
	# Setting deferred because these need ready to happe
	new_blaze.set_deferred("damage", props.damage)
	new_blaze.set_deferred("damage_rate_ms", props.damage_rate_ms)
	new_blaze.set_deferred("duration_ms", props.duration_ms)
