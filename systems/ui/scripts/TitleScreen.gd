class_name TitleScreen
extends Control

signal game_started(factory_name: String)

@onready var new_game_button: Button = %NewGameButton
@onready var factory_dialog: FactoryDialog = %FactoryDialog

const GAME_SCENE := preload("res://systems/map/scenes/map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game_pressed);
	factory_dialog.confirmed.connect(_on_confirmed);
	factory_dialog.dismissed.connect(_on_dismissed);
	

# New Game Pressed
func _on_new_game_pressed() -> void:
	factory_dialog.visible = true

func _on_confirmed(factory_name: String) -> void:
	GameData.factory_name = factory_name
	factory_dialog.visible = false
	get_tree().change_scene_to_packed(GAME_SCENE)
	
func _on_dismissed() -> void:
	factory_dialog.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
