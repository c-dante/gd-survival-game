class_name LevelUpChoice
extends Button

var choice: LevelUp.Choice

@onready var _title: Label = $VBoxContainer/Upgrade
@onready var _choice_texture: TextureRect = $VBoxContainer/AspectRatioContainer/ChoiceTexture
@onready var _levels_container: Container = $VBoxContainer/Levels
@onready var _levelup_icon_tpl: TextureRect = $VBoxContainer/Levels/Icon
@onready var _description: Label = $VBoxContainer/Description

func set_choice(_choice: LevelUp.Choice):
	_clean()
	choice = _choice
	_title.text = choice.choice
	_choice_texture.texture = choice.sprite
	_description.text = choice.description
	
	if _choice.current_level < 0:
		push_error("Negative level passed. Coercing to level 0 ", str(_choice))
		_choice.current_level = 0
	
	var choice_medals: Array[TextureRect] = [_levelup_icon_tpl]
	for i in _choice.current_level + 1:
		if choice_medals.size() <= i:
			var new_medal = _levelup_icon_tpl.duplicate(0)
			choice_medals.push_back(new_medal)
			_levels_container.add_child(new_medal)
		
		if i == _choice.current_level:
			choice_medals[i].modulate = Color.LIME
		else:
			choice_medals[i].modulate = Color.WHITE

func _clean():
	for child in _levels_container.get_children():
		if child != _levelup_icon_tpl:
			_levels_container.remove_child(child)
			child.queue_free()
