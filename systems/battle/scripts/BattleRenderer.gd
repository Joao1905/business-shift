class_name BattleRenderer
extends Node

@onready var factory_name : Label = %FactoryName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	factory_name.text = "Factory Name Placeholder"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
