@tool
class_name UiMenuOption
extends BaseUiMenu

# Scene Factory
const SCENE_PATH := "res://systems/ui/scenes/ui_menu_option.tscn"
static func create(text: String, color: Color) -> UiMenuOption:
	var menu_option := (load(SCENE_PATH) as PackedScene).instantiate() as UiMenuOption
	menu_option.text = text
	menu_option.color = color
	return menu_option

# Input text
@export var text: String = "":
	set(value):
		text = value
		if is_node_ready():
			button.text = text

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		if is_node_ready():
			_apply_color()

# Retrieve element refs
@onready var arrow : Label = %Arrow;
@onready var button : Button = %Button;

# Output signal/event
signal menu_option_selected()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Button config
	button.text = text
	button.pressed.connect(_select_button_option)
	
	# Arrow handling
	_apply_color()
	arrow.modulate.a = 0.0
	button.focus_entered.connect(func(): arrow.modulate.a = 1.0)
	button.focus_exited.connect(func(): arrow.modulate.a = 0.0)

func _apply_color() -> void:
	arrow.add_theme_color_override("font_color", color)

func set_focused() -> void:
	button.grab_focus()
	print(button.has_focus(), " / ", get_viewport().gui_get_focus_owner())

func _select_button_option() -> void:
	# In case it has no sub options
	if (not _has_submenu()):
		menu_option_selected.emit()
		return
	
	# Notify of selection, refresh display options
	var menu = _find_parent_menu();
	menu.submenu_selected(self);

func _has_submenu() -> bool:
	for child in get_children():
		if child is UiMenuOption:
			return true
	return false

func _find_parent_menu() -> UiMenu:
	var current = get_parent()
	while (current != null):
		if current is UiMenu:
			return current
		current = current.get_parent()
	return null
	
func hide_components() -> void:
	%Components.visible = false
	
func set_disabled(value: bool) -> void:
	button.disabled = value  # greyed out via the theme, can't be pressed	
