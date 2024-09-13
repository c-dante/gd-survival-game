class_name NewGameState
extends StateNode

@export var test_arena: TestArena
@export var spawner: Spawner
@export var level_up_ui: LevelUp

func _enter():
	# Reset the arena and player
	test_arena.clear_arena()
	test_arena.player.reset()
	test_arena.player.position = test_arena.player_start
	Global.reset()
	
	# Spawn the initial wave + start the game timer
	spawner.spawn_initial_wave(25)
	spawner.start_spawn_timer()
	dispatch(TestArena.INITIAL_WEAPON)
