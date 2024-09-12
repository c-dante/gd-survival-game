class_name TestArena
extends Node2D

const EnemyScene: PackedScene = preload("res://Enemy/Enemy.tscn")
const PickupScene: PackedScene = preload("res://Pickup/Pickup.tscn")
const SwordScene: PackedScene = preload("res://weapons/Sword/Sword.tscn")
const BlazeScene: PackedScene = preload("res://weapons/Blaze/Blaze.tscn")

@onready var ui: GameUi = $UI/GameUi
@onready var game_over: GameOver = $UI/GameOver


## TODO (code-game): The game layer
@onready var game: CanvasLayer = $Game
## TODO (code-game): The enemies
@onready var enemies = $Game/Enemies
## TODO (code-game): Pickup items layer
@onready var pickups = $Game/Pickups
## TODO (code-game): Effects layer
@onready var effects: Effects = $Game/Effects
## TODO (code-game): Weapons layer
@onready var weapons = $Game/Weapons
## TODO (code-game): Player character
@onready var player: Player = $Game/Player
## TODO (code-game): Controls spawnable arena space, assumed a rect
@onready var arena_area: CollisionShape2D = $Game/TileMapLayer/AreanaArea/CollisionShape2D
## TODO (code-game): The enemy spawner
@onready var spawn_timer: Timer = $Game/Spawner/SpawnTimer

## TODO (code-game): Capture the player's starting position for consitent runs
var player_start;

func _ready():
	player_start = player.position
	_init_hsm()

## TODO (code-game)
func clear_arena():
	Global.clear_group(Global.GROUP_ENEMIES)
	Global.clear_group(Global.GROUP_PICKUPS)
	Global.clear_group(Global.GROUP_WEAPONS)

## Spawn an exp blob at a position
## TODO (code-game)
func _drop_reward(pos: Vector2):
	var drop = randi_range(0, 1000)
	var kind: Pickup.PickupKind
	if drop > 990:
		kind = Pickup.PickupKind.HEIRLOOM
	elif drop > 900:
		kind = Pickup.PickupKind.HEALTH
	elif drop > 500:
		kind = Pickup.PickupKind.EXP
	else:
		return
	
	var pick: Pickup = PickupScene.instantiate()
	pick.position = pos
	pick.kind = kind
	pickups.add_child(pick)
	pick.add_to_group(Global.GROUP_PICKUPS)

## Adds a sword weapon, call only once per game or else you get weird things
## TODO (code-level-up), (code-game)
func _add_weapon_sword():
	var sword = SwordScene.instantiate()
	sword.add_to_group(Global.GROUP_WEAPONS)
	sword.target = player
	weapons.add_child(sword)

## Adds a blaze weapon, call only once per game or else you get weird things
## TODO (code-level-up), (code-game)
func _add_weapon_blaze():
	var blaze = BlazeScene.instantiate()
	blaze.add_to_group(Global.GROUP_WEAPONS)
	blaze.target = player
	weapons.add_child(blaze)

func _on_game_ui_damage_toggle(toggled_on):
	player.damage_enabled = toggled_on

# ##################
# BEGIN STATE BLOCK
# ##################
@onready var _hsm = $StateMachine
@onready var _state_main_menu = $StateMachine/MainMenu
@onready var _state_new_game = $StateMachine/NewGame
@onready var _state_playing = $StateMachine/Playing
@onready var _state_reward_select = $StateMachine/RewardSelect
@onready var _state_paused = $StateMachine/Paused
@onready var _state_game_over = $StateMachine/GameOver

# Actions
const CONTINUE = &"CONTINUE"
const NEW_GAME = &"NEW_GAME"
const INITIAL_WEAPON = &"INITIAL_WEAPON"
const LEVEL_UP = &"LEVEL_UP"
const UPGRADE_CHOICE = &"UPGRADE_CHOICE"
const PAUSE = &"PAUSE"
const RESUME = &"RESUME"
const GAME_OVER = &"GAME_OVER"

func _init_hsm():
	_hsm.add_transition(_hsm.ANYSTATE, _state_new_game, NEW_GAME)
	
	_hsm.add_transition(_state_new_game, _state_reward_select, INITIAL_WEAPON)
	
	_hsm.add_transition(_state_playing, _state_reward_select, LEVEL_UP)
	_hsm.add_transition(_state_playing, _state_paused, PAUSE)
	_hsm.add_transition(_state_playing, _state_game_over, GAME_OVER)
	
	_hsm.add_transition(_state_paused, _state_playing, RESUME)
	_hsm.add_transition(_state_paused, _state_game_over, GAME_OVER)
	
	_hsm.add_transition(_state_reward_select, _state_playing, UPGRADE_CHOICE)
	_hsm.add_transition(_state_reward_select, _state_game_over, GAME_OVER)
	
	_hsm.add_transition(_state_game_over, _state_main_menu, CONTINUE)

	_hsm.set_active(_state_main_menu)

func _on_game_ui_level_up():
	_hsm.dispatch(LEVEL_UP)

## Respond to the result of a level up choice
func _on_level_up_on_select(choice: LevelUp.Choice):
	_hsm.call_deferred("dispatch", UPGRADE_CHOICE)

	if choice == null:
		return
	
	# Upgrade an existing weapon
	if choice.metadata["type"] == LevelUp.ChoiceType.WeaponUpgrade:
		var weapon = choice.metadata["weapon"] as Weapon
		if !weapon:
			push_error("Error, got weapon upgrade but no weapon passed? ", choice)
			return
		weapon.set_level(choice.level)
		return
	
	# Acquire a new weapon
	if choice.metadata["type"] == LevelUp.ChoiceType.WeaponAcquire:
		if choice.metadata["weapon_type"] == Weapon.WeaponType.Sword:
			_add_weapon_sword()
			return
		
		if choice.metadata["weapon_type"] == Weapon.WeaponType.Blaze:
			_add_weapon_blaze()
			return
	
	push_error("Uhandled choice", choice)

## Cached only for the "quick new game" button to work
func _on_quick_new_game():
	seed(Global.game_stats.seed)
	_hsm.dispatch(NEW_GAME)

func _on_seeded_new_game(game_seed: int):
	Global.game_stats.seed = game_seed
	seed(game_seed)
	_hsm.dispatch(NEW_GAME)

func _on_game_ui_toggle_pause():
	if _hsm.get_active_state() is PausedState:
		_hsm.dispatch(RESUME)
	else:
		_hsm.dispatch(PAUSE)

## Respond to the player getting killed
func _on_health_on_death(_target: Node2D, killer: Node2D):
	Global.game_stats.killed_by = killer.name
	_hsm.dispatch(GAME_OVER)

func _on_player_on_level_up(_level, _player):
	_hsm.dispatch(LEVEL_UP)

func _on_game_ui_end_run():
	Global.game_stats.killed_by = "Your own hand"
	_hsm.dispatch(GAME_OVER)

func _on_game_over_continue_game():
	_hsm.dispatch(CONTINUE)

func _on_spawner_spawn_wave(to_spawn):
	for enemy in to_spawn:
		enemy.target = player
		enemy.position = _get_spawn_point(player.global_position)
		var health: Health = enemy.get_node("Health")
		health.on_death.connect(
			func (target: Node2D, _killer: Node2D):
				Global.game_stats.kills += 1
				effects.explode(target.global_position)
				call_deferred("_drop_reward", target.global_position)
		)
		enemies.add_child(enemy)
		enemy.add_to_group(Global.GROUP_ENEMIES)

func _get_spawn_point(target: Vector2) -> Vector2:
	var rect = arena_area.shape.get_rect()
	var pos = arena_area.to_global(Global.pt_in_rect(rect, 0))
	while target.distance_to(pos) < 200:
		pos = arena_area.to_global(Global.pt_in_rect(rect, 0))
	return pos
