class_name Weapon
extends Node2D

var _level = 1;
func get_level_props() -> Array[Variant]:
	return []

func get_props(level = _level) -> Variant:
	var level_props = get_level_props()
	if level > level_props.size():
		push_error("Failed to get props!")
		return null
	return level_props[level - 1]

func make_choices(_now_props: Variant, _next_props: Variant) -> Array[LevelUp.Choice]:
	return []

func get_choices() -> Array[LevelUp.Choice]:
	var next_level = _level + 1
	if next_level > get_level_props().size():
		return []

	var next_props = get_props(next_level)
	var now_props = get_props(_level)
	return make_choices(now_props, next_props)
