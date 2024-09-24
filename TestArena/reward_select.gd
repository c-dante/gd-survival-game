extends StateNode

@export var reward_select_ui: LevelUp
@export var test_arena: TestArena

signal no_rewards()

func _enter():
	var choices = _get_choices()
	if choices.is_empty():
		no_rewards.emit()
		return
	
	test_arena._disable_joystick()
	Global.safe_pause(true)
	if get_root().get_previous_active_state() is NewGameState:
		reward_select_ui.heading = "Starting Weapon"
	else:
		reward_select_ui.heading = "Level Up"
	
	reward_select_ui.show()
	reward_select_ui.set_choices(choices)

func _exit():
	Global.safe_pause(false)
	reward_select_ui.hide()

func _get_choices() -> Array[LevelUp.Choice]:
	# TODO: configure choices, for now, it's always sword
	# But this would be picking N { weapons, artifacts }, and if you own the weapon, asking for the next level
	var choices: Array[LevelUp.Choice] = []
	var new_weapons = Weapon.WeaponType.values()
	new_weapons.erase(Weapon.WeaponType.Unknown)
	for node in get_tree().get_nodes_in_group(Global.GROUP_WEAPONS):
		if node.is_queued_for_deletion():
			continue
			
		var weapon = node as Weapon
		if weapon:
			new_weapons.erase(weapon.get_type())
			choices.append_array(weapon.get_choices())
			
	# If we have fewer than 3 choices, add new weapons
	while choices.size() < 3 && new_weapons.size() > 0:
		var weapon_type = new_weapons.pop_at(randi_range(0, new_weapons.size() - 1))
		if weapon_type == Weapon.WeaponType.Blaze:
			choices.push_back(Blaze.AcquireChoice())
		elif weapon_type == Weapon.WeaponType.Sword:
			choices.push_back(Sword.AcquireChoice())
		elif weapon_type == Weapon.WeaponType.Hammer:
			choices.push_back(Hammer.AcquireChoice())
	
	return choices
