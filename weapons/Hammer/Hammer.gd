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
	var hammer_spawn_secs: float = 5.0
	var knockback: float = 10.0
	
	func _init(_hammer_spawn_secs, _knockback: float):
		hammer_spawn_secs = _hammer_spawn_secs
		knockback = _knockback
		
	func level_up_description(current_props: HammerProps) -> String:
		var out = []

		var hammer_spawn_buff = hammer_spawn_secs - current_props.hammer_spawn_secs
		if hammer_spawn_buff < 0:
			out.push_back("+%d throw rate" % hammer_spawn_buff)

		var knockback_buff = Global.diff_percent(knockback, current_props.knockback)
		if !is_zero_approx(knockback_buff):
			out.push_back("%s kockback" % Format.format_percent(knockback_buff))
		
		return "\n".join(out)

var LevelProps: Array[HammerProps] = [
	HammerProps.new(4.0, 10.0),
	HammerProps.new(3.0, 20.0),
	HammerProps.new(2.5, 30.0),
	HammerProps.new(2.0, 40.0),
	HammerProps.new(1.5, 40.0),
	HammerProps.new(1.0, 40.0),
]
func get_level_props():
	return LevelProps

@onready var spawn_timer: Timer = $Timer
@onready var projectiles = $Projectiles

var _target: Node2D
@export var target: Node2D:
	get:
		return _target
	set(value):
		_target = value
		if projectiles:
			for hammer: HammerProjectile in projectiles.get_children():
				hammer.target = value

var _target_last_pos: Vector2
var _target_velocity: Vector2

# _level from Weapon
func set_level(level: int):
	_level = clamp(level, 1, LevelProps.size())
	var props = LevelProps[_level - 1]
	spawn_timer.start(props.hammer_spawn_secs)
	_on_timer_timeout() # One free hammer on level up

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
	
func _physics_process(delta):
	if target:
		_target_velocity = target.global_position - _target_last_pos
		_target_last_pos = target.global_position

func _on_timer_timeout():
	if !target:
		return
		
	var props = get_props() as HammerProps
	var hammer = HammerProjectileScene.instantiate()
	hammer.target = target
	hammer.position = target.position
	hammer.knockback = props.knockback
	hammer.hammer_complete.connect(_end_hammer)
	var direction = _target_velocity.normalized()
	if direction.is_zero_approx():
		direction = Vector2.from_angle(randf_range(-TAU, TAU))
	hammer.velocity = HammerProjectile.MAX_VELOCITY * direction
	projectiles.add_child(hammer)

func _end_hammer(hammer: HammerProjectile):
	hammer.get_parent().remove_child(hammer)
	hammer.queue_free()
