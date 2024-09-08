class_name NewGameState
extends LimboState

@export var test_arena: TestArena
@export var level_up_ui: LevelUp

func _enter():
	test_arena.clear_arena()
	test_arena.player.reset()
	test_arena.player.position = test_arena.player_start
	Global.reset()
	test_arena._spawn_wave(test_arena.player, test_arena.arena_area, 25)
	test_arena.spawn_timer.start()
	dispatch(TestArena.INITIAL_WEAPON)
