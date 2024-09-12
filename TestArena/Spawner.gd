class_name Spawner
extends Node

const EnemyScene: PackedScene = preload("res://Enemy/Enemy.tscn")

const GAME_LENGTH = 5.0

signal spawn_wave(enemies: Array[Enemy])

@onready var timer: Timer = $SpawnTimer

@export var effects: Effects

@export var spawn_rate: Curve:
	set(new_value):
		spawn_rate = new_value
		update_timer()
		
@export var level_probability: Curve:
	set(new_value):
		level_probability = new_value

func _ready():
	update_timer()
	
func update_timer():
	if !timer:
		return
	timer.start(10.0)

func _on_debug_timer_timeout():
	pass

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


## Configures a wave of enemies based on the current elapsed game time
func _on_spawn_timer_timeout():
	spawn_initial_wave(5)

func make_enemy(level: int) -> Enemy:
	var enemy: Enemy = EnemyScene.instantiate()
	enemy.level = level
	enemy.name = "Skelly %d" % Global.game_stats.enemy_count
	Global.game_stats.enemy_count += 1
	return enemy
