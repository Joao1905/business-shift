class_name PlayerBattleMenu
extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		(get_child(0) as BattleMenuOption).set_focused()
