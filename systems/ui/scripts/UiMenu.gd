class_name UiMenu
extends BaseUiMenu

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	reset()

func reset() -> void:
	# (Initialize) Hide everything, recursively
	for node in find_children("*", "BaseUiMenu", true, false):
		node.visible = false
	
	# Trigger submenu_selected to appropriately hide/show immediate options only, and adjust focus
	submenu_selected(self)

func submenu_selected(option: BaseUiMenu) -> void:
	# Hide option's siblings, if any
	option.hide_siblings()
	
	# Hide components (if exists)
	if (option is UiMenuOption):
		(option as UiMenuOption).hide_components();
	
	# Show immediate UiMenuOption
	option.show_immediate_options()
		
	# and finally, focus on the first element
	_focus_first_element(option)

func _focus_first_element(node: Node) -> void:
	# Return if not visible
	if not node.is_visible_in_tree():
		return
		
	# Find first child UiMenuOption and set it focused
	var options := node.find_children("*", "UiMenuOption", false, false)
	if not options.is_empty():
		(options[0] as UiMenuOption).set_focused()
