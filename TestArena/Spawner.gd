class_name Spawner
extends Node

const EnemyScene: PackedScene = preload("res://Enemy/Enemy.tscn")

const GAME_LENGTH = 5.0

signal spawn_wave(enemies: Array[Enemy])

@onready var timer: Timer = $SpawnTimer

@export var effects: Effects

@export var spawn_rate: Curve
@export var spawn_size: Curve
@export var level_probability: Curve

#func _ready():
	#for i in range(0, 100):
		#var pct = float(i) / 100.0
		#var level_prop = level_probability.sample(pct)
		#var rate = spawn_rate.sample(pct)
		#var size = spawn_size.sample(pct)
		#print(", ".join([rate, level_prop, size]))

## Reset the game timer and begin!
func start_spawn_timer():
	if !timer || !spawn_rate:
		return
	var pct = Global.game_stats.play_time_percent()
	timer.start(spawn_rate.sample(pct))

## TODO (code-game)
## Spawn a wave of enemies
## player = player char to prevent spawning too close
## arena = bounds to spawn in, a rect in the scene tree
## num_to_spawn = how many baddies
func spawn_initial_wave(num_to_spawn: int = 1):
	var spawned = []
	for i in num_to_spawn:
		spawned.push_front(make_enemy(1))
	spawn_wave.emit(spawned)

## Create and spawn a new wave of enemies based on the gametime
## and configured spawn curves
func _on_spawn_timer_timeout():
	var pct = Global.game_stats.play_time_percent()
	timer.wait_time = spawn_rate.sample(pct)
	var to_spawn = Global.rand_bump(spawn_size.sample(pct))
	var enemies = []
	for i in to_spawn:
		var level = Global.rand_bump(level_probability.sample(pct))
		enemies.push_front(make_enemy(level))
	spawn_wave.emit(enemies)
	

## Create and return a new enemy
func make_enemy(level: int) -> Enemy:
	var enemy: Enemy = EnemyScene.instantiate()
	enemy.level = level
	enemy.name = "Skelly %d" % Global.game_stats.enemy_count
	Global.game_stats.enemy_count += 1
	return enemy
