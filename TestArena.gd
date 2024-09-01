extends Node2D

const EnemyScene: PackedScene = preload("res://Enemy/Enemy.tscn")

@onready var game: CanvasLayer = $Game
@onready var player: Player = $Game/Player
@onready var arena_area: CollisionShape2D = $Game/AreanaArea/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	seed(123456789)
	var rect = arena_area.shape.get_rect()
	for i in range(10):
		var pos = arena_area.to_global(_pt_in_rect(rect, 0))
		_add_enemey(pos)

func _add_enemey(point: Vector2):
	var enemy: Enemy = EnemyScene.instantiate()
	enemy.target = player
	enemy.position = point
	game.add_child(enemy)

func _pt_in_rect(rect: Rect2, margin: float = 1.0) -> Vector2:
	var normalized = Vector2(
		randf_range(margin, rect.size.x - margin),
		randf_range(margin, rect.size.y - margin)
	)
	return rect.position + normalized

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
