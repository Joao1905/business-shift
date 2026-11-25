class_name BattleRenderer
extends PanelContainer

@onready var factory_name : Label = %FactoryName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	factory_name.text = "Factory Name Placeholder"
