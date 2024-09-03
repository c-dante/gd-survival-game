class_name Weapon
extends Node2D

var _level = 1;
func get_level_props() -> Array[Variant]:
	return []

func make_choices(now_props: Variant, next_props: Variant) -> Array[LevelUp.Choice]:
	return []

func get_choices() -> Array[LevelUp.Choice]:
	var next_level = _level + 1
	var level_props = get_level_props()
	if next_level > level_props.size():
		return []

	var next_props = level_props[next_level - 1]
	var now_props = level_props[_level - 1]
	var desc = next_props.level_up_description(now_props)
	return make_choices(now_props, next_props)
