class_name TestArena
extends Node2D

const EnemyScene: PackedScene = preload("res://Enemy/Enemy.tscn")
const ExplosionScene: PackedScene = preload("res://Explosion/Explosion.tscn")
const PickupScene: PackedScene = preload("res://Pickup/Pickup.tscn")

@onready var game: CanvasLayer = $Game
@onready var ui: GameUi = $UI/GameUi
@onready var player: Player = $Game/Player
@onready var arena_area: CollisionShape2D = $Game/AreanaArea/CollisionShape2D
@onready var sword = $Game/Sword

# Called when the node enters the scene tree for the first time.
var player_start;
func _ready():
	seed(123456789)
	player_start = player.position
	start_game()

func clear_arena():
	game.remove_child(player)
	game.remove_child(sword)
	get_tree().call_group(Global.GROUP_ENEMIES, "queue_free")
	get_tree().call_group(Global.GROUP_PICKUPS, "queue_free")

func start_game():
	player.reset()
	
	if player.get_parent() == null:
		game.add_child(player)
		game.add_child(sword)
	
	player.position = player_start
	Global.reset()
	
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
		func (target: Node2D, killer: Node2D):
			Global.game_stats["kills"] += 1
			explode(target.global_position)
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

# Object pool for particle effects, maintaining a max size in the pool but always bursting as high as it needs
const MAX_PARTICLE_POOL = 50
var particle_pool = []
func explode(pos: Vector2):
	var explosion: Explosion = particle_pool.pop_front()
	if explosion == null:
		explosion = ExplosionScene.instantiate()
		explosion.finished.connect(
			func ():
				if particle_pool.size() > MAX_PARTICLE_POOL:
					explosion.queue_free()
				else:
					particle_pool.push_back(explosion)
		)
		game.add_child(explosion)
	
	explosion.fire_at(pos)


func _on_health_on_death(target: Node2D, killer: Node2D):
	Global.game_stats["killed_by"] = killer.name
	clear_arena()
	ui.show_game_over()

func _on_game_ui_new_game():
	ui.hide_game_over()
	start_game()
