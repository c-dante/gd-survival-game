class_name Player
extends CharacterBody2D

@onready var _sprite_move = $SpriteMove

var experience: int = 0
var level = 0

func _physics_process(_delta):
	_sprite_move.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_sprite_move.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = _sprite_move.tick(_delta)
	
	# TODO: Move into a plugin for damage taking?
	modulate = lerp(modulate, Color.WHITE, 0.8 * _delta * Global.game_speed)
	
	if move_and_slide():
		_handle_collision()
		
func reset():
	modulate = Color.WHITE
	experience = 0
	level = 0
	$Health.health = 100

func _handle_collision():
	print(get_slide_collision_count())

func _on_pickup_area_area_entered(area):
	var pickup: Pickup = area.owner
	if pickup.kind == Pickup.PickupKind.EXP:
		experience += 10
		if experience >= 100:
			experience = 0
			level += 1
			Global.game_stats["player_level"] = level
		# TODO: Fun pickup animation, fly to the bar or to the player or something
		pickup.queue_free()
	else:
		print("Unhandled pickup: ", pickup)


func _on_health_on_change(change, value):
	if change < 0:
		Global.game_stats["dmg_taken"] += abs(change)
		modulate = Color.CRIMSON
