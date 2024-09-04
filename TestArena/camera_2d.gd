extends Camera2D

@export var target_path: NodePath

var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target_path)
	
	if not target:
		push_warning("Smooth follow camera: Target node not found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Calculate the desired position (target's position)
	var desired_position = target.global_position
	
	# Smoothly interpolate between the current position and the desired position
	global_position = global_position.slerp(desired_position, 0.8)
