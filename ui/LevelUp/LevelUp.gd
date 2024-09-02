class_name LevelUp
extends MarginContainer

class Choice:
## A data class to represent level up choices
	var choice: String
	var sprite: Texture2D
	var description: String
	var level: int
	var metadata: Variant
	
	func _init(_choice: String, _sprite: Texture2D, _description: String, _level: int, _metadata: Variant = null):
		choice = _choice
		sprite = _sprite
		description = _description
		level = _level
		metadata = _metadata

	func _to_string():
		return "Choice(choice=%s, sprite=%s, description=%s, level=%s, metadata=%s)"% [
			choice, sprite, description, level, metadata
		]

signal on_select(choice: Choice)

@onready var _choices_container: Container = $VBoxContainer/Choices
@onready var _choice_tpl: LevelUpChoice = $VBoxContainer/Choices/BaseChoice

# Called when the node enters the scene tree for the first time.
func set_choices(choices: Array[Choice]):
	if choices.size() == 0:
		push_error("Empty level up screen! Null choice!")
		on_select.emit(null)
	else:
		_clean()
		var choice_arr: Array[LevelUpChoice] = [_choice_tpl]
		for choice_idx in choices.size():
			# Duplicate if we hit a new choice
			if choice_arr.size() <= choice_idx:
				var new_choice = _choice_tpl.duplicate(DuplicateFlags.DUPLICATE_SCRIPTS)
				choice_arr.push_back(new_choice)
				_choices_container.add_child(new_choice)
			
			# Configure this choice
			var choice_btn = choice_arr[choice_idx]
			choice_btn.set_choice(choices[choice_idx])
			choice_btn.pressed.connect(
				func ():
					on_select.emit(choices[choice_idx])
			)

func _clean():
	for child in _choices_container.get_children():
		if child != _choice_tpl:
			_choices_container.remove_child(child)
			child.queue_free()
		else:
			Global.clear_connections(_choice_tpl.pressed)
