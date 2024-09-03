class_name TestArena
extends Node2D

const EnemyScene: PackedScene = preload("res://Enemy/Enemy.tscn")
const PickupScene: PackedScene = preload("res://Pickup/Pickup.tscn")
const SwordScene: PackedScene = preload("res://weapons/Sword/Sword.tscn")
const BlazeScene: PackedScene = preload("res://weapons/Blaze/Blaze.tscn")

@onready var effects: Effects = $Effects
@onready var game: CanvasLayer = $Game
@onready var ui: GameUi = $UI/GameUi
@onready var level_up_ui: Control = $UI/LevelUpUi
@onready var level_up: LevelUp = $UI/LevelUpUi/CenterContainer/LevelUp
@onready var player: Player = $Game/Player
@onready var arena_area: CollisionShape2D = $Game/AreanaArea/CollisionShape2D

# Called when the node enters the scene tree for the first time.
var player_start;
func _ready():
	seed(123456789)
	player_start = player.position
	start_game()

func clear_arena():
	game.remove_child(player)
	# TODO bug-pause: I think queue-free is why the lazy signals happen -- might need to remove enemies + pickups tpp
	get_tree().call_group(Global.GROUP_ENEMIES, "queue_free")
	get_tree().call_group(Global.GROUP_PICKUPS, "queue_free")
	get_tree().call_group(Global.GROUP_WEAPONS, "queue_free")

func start_game():
	get_tree().paused = false
	player.reset()
	level_up_ui.hide()
	ui.hide_game_over()
	
	if player.get_parent() == null:
		game.add_child(player)
	
	player.position = player_start
	Global.reset()
	
	# TODO: Weapon select not just level ups
	#var sword = SwordScene.instantiate()
	#sword.add_to_group(Global.GROUP_WEAPONS)
	#sword.target = player
	#game.add_child(sword)
	
	var blaze = BlazeScene.instantiate()
	blaze.add_to_group(Global.GROUP_WEAPONS)
	blaze.target = player
	game.add_child(blaze)
	
	var rect = arena_area.shape.get_rect()
	for i in range(100):
		var pos = arena_area.to_global(_pt_in_rect(rect, 0))
		while player.global_position.distance_to(pos) < 100:
			pos = arena_area.to_global(_pt_in_rect(rect, 0))
		_add_enemey(pos)

# Create an enemy that explodes and drops EXP on death
func _add_enemey(point: Vector2):
	var enemy: Enemy = EnemyScene.instantiate()
	enemy.name = "Skelly %d" % get_tree().get_node_count_in_group(Global.GROUP_ENEMIES)
	enemy.target = player
	enemy.position = point
	var health: Health = enemy.get_node("Health")
	health.on_death.connect(
		func (target: Node2D, _killer: Node2D):
			Global.game_stats["kills"] += 1
			effects.explode(target.global_position)
			call_deferred("drop_exp", target.global_position)
	)
	game.add_child(enemy)
	enemy.add_to_group(Global.GROUP_ENEMIES)

# Generate a random point in a rectangle
func _pt_in_rect(rect: Rect2, margin: float = 1.0) -> Vector2:
	var normalized = Vector2(
		randf_range(margin, rect.size.x - margin),
		randf_range(margin, rect.size.y - margin)
	)
	return rect.position + normalized

func drop_exp(pos: Vector2):
	var xp: Pickup = PickupScene.instantiate()
	xp.position = pos
	xp.kind = Pickup.PickupKind.EXP
	game.add_child(xp)
	xp.add_to_group(Global.GROUP_PICKUPS)

# HERE BE SIGNAL DRAGONS
func _on_health_on_death(_target: Node2D, killer: Node2D):
	Global.game_stats["killed_by"] = killer.name
	clear_arena() # TODO: Weird bug where pausing here has a slow/late signal, and deferring doesn't work
	get_tree().set_deferred("paused", true)
	ui.show_game_over()

func _on_game_ui_new_game():
	call_deferred("start_game")

func _on_player_on_level_up(_level, _player):
	get_tree().paused = true
	level_up_ui.show()
	# TODO: configure choices, for now, it's always sword
	# But this would be picking N { weapons, artifacts }, and if you own the weapon, asking for the next level
	var choices: Array[LevelUp.Choice] = []
	for weapon in get_tree().get_nodes_in_group(Global.GROUP_WEAPONS):
		if weapon.has_method("get_choices"):
			choices.append_array(weapon.get_choices())
	level_up.set_choices(choices)

func _on_level_up_on_select(choice: LevelUp.Choice):
	get_tree().paused = false
	level_up_ui.hide()
	
	if !choice || !choice.metadata || !choice.metadata.has_method("set_level"):
		push_error("Unhandled choice ", choice)
		return
	
	choice.metadata.set_level(choice.level)

func _on_game_ui_level_up():
	_on_player_on_level_up(player.level + 1, player)
