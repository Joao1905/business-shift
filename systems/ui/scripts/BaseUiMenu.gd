class_name BaseUiMenu
extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_siblings() -> void:
	for child: CanvasItem in get_parent().find_children("*", "UiMenuOption", false, false):
		child.visible = false
	self.visible = true

func show_immediate_options() -> void:
	for child: CanvasItem in find_children("*", "UiMenuOption", false, false):
		child.visible = true
