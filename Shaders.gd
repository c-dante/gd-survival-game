extends Node

var outline: ShaderMaterial = preload("res://shared/shader/outline_shader.tres")
var outline_cache = {}

func get_outline(color: Color):
	if !outline_cache.has(color):
		var new_outline = outline.duplicate()
		new_outline.set_shader_parameter("outline_color", color)
		outline_cache[color] = new_outline
	
	return outline_cache.get(color)
