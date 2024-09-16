class_name GameCamera
extends Camera2D

@export var target_path: NodePath

var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target_path)
	
	if not target:
		push_warning("Smooth follow camera: Target node not found!")
	else:
		global_position = target.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Calculate the desired position (target's position)
	global_position = target.global_position
	
