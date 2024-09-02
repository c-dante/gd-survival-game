class_name Sword
extends Node2D

const SwordProjectile: PackedScene = preload("res://weapons/Sword/SwordProjectile.tscn")
const SwordTx: Texture2D = preload("res://ui/LevelUp/SwordSprite.tres")

@export var target: Node2D


var _level = 1
var _rotation_speed = PI
var _orbit_distance = 64
var _orbit_speed = PI / 4

func _ready():
	set_level(1)

func set_level(level: int):
	_level = level
	const swords = get_children()
	for sword in swords:
		

func get_choices() -> Array[LevelUp.Choice]:
	print("TODO: Sword choices for level: ", _level)
	return []


#var swords: Array[Sword] = []
#func _on_level_up_on_select(choice: LevelUp.Choice):
	#print("LEVEL UP! ", choice)
	#var new_sword: Sword = sword.duplicate()
	#game.add_child(new_sword)
	#swords.push_back(new_sword)
	#for sword_idx in swords.size():
		#var i = sword_idx + 1
		#swords[sword_idx].angle = i * (TAU / swords.size())
	#level_up_ui.hide()
	#get_tree().paused = false


	#level_up.set_choices([
		#LevelUp.Choice.new(
			#"More Swords",
			#SwordTx,
			#"Adds another sword to swing",
			#1
		#),
		#LevelUp.Choice.new(
			#"Faster Swords",
			#SwordTx,
			#"Slash swords even faster",
			#1
		#)
	#]);
