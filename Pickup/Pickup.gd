class_name Pickup
extends Sprite2D

const HeirloomTex: Texture2D = preload("res://shared/Heirloom.tres")
const HealthTex: Texture2D = preload("res://shared/Health.tres")
const ExpTex: Texture2D = preload("res://shared/Exp.tres")

enum PickupKind { HEALTH, EXP, HEIRLOOM }

@export var kind: PickupKind:
	set(value):
		kind = value
		_set_sprite()

func _ready():
	_set_sprite()

func _set_sprite():
	match kind:
		PickupKind.HEIRLOOM:
			self.texture = HeirloomTex
		PickupKind.EXP:
			self.texture = ExpTex
		PickupKind.HEALTH:
			self.texture = HealthTex
