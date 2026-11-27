class_name FactoryDialog
extends Node

# External events
signal confirmed(factory_name: String)
signal dismissed()

@onready var name_field: LineEdit = %FactoryNameField
@onready var start_button: Button = %StartButton
@onready var close_button: Button = %CloseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(_on_start_button)
	close_button.pressed.connect(_on_close_button)

func _on_start_button() -> void:
	confirmed.emit(name_field.text)

func _on_close_button() -> void:
	dismissed.emit()
