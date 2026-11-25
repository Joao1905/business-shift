extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _placeholder = add_part(preload("res://systems/battle/assets/images/factory_placeholder.png"), Vector2(0, 0), 1)
	
func add_part(tex: Texture2D, pos: Vector2, z := 0) -> Sprite2D:
	var s = Sprite2D.new()
	s.centered = false
	s.texture = tex
	s.position = pos
	s.z_index = z
	add_child(s)
	return s
