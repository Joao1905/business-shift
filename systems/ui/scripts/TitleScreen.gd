class_name TitleScreen
extends Control

@onready var main: Node2D = $".."

@onready var new_game_button: Button = %NewGameButton
@onready var factory_dialog: FactoryDialog = %FactoryDialog

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
	main.load_screen(main.SCREENS.MAP)
	
func _on_dismissed() -> void:
	factory_dialog.visible = false;
