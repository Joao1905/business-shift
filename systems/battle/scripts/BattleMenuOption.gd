@tool
class_name BattleMenuOption
extends HBoxContainer

# Input text
@export var text: String = "":
	set(value):
		text = value
		if is_node_ready():
			button.text = text

# Retrieve element refs
@onready var arrow : Label = %Arrow;
@onready var button : Button = %Button;

# Output signal/event
signal menu_option_selected()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Button config
	button.text = text
	button.pressed.connect(func(): menu_option_selected.emit())
	
	# Arrow handling
	arrow.modulate.a = 0.0
	button.focus_entered.connect(func(): arrow.modulate.a = 1.0)
	button.focus_exited.connect(func(): arrow.modulate.a = 0.0)

func set_focused() -> void:
	button.grab_focus()
	print(button.has_focus(), " / ", get_viewport().gui_get_focus_owner())
