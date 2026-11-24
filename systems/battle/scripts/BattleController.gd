class_name BattleController
extends Node

@onready var main_controller: MainController = $".." as MainController
@onready var map_controller : MapController = $"../Map" as MapController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map_controller.map_node_clicked.connect(_on_node_clicked)
	
func _on_node_clicked(node: MapNode) -> void:
	if (not _is_battle(node)):
		return;
		
	# Load Battle Screen
	main_controller.load_screen(MainController.SCREENS.BATTLE);

func _is_battle(node: MapNode) -> bool:
	return node.MapNodeType in [
		MapNode.MapNodeType.BATTLE,
		 MapNode.MapNodeType.BATTLE_PLUS,
		 MapNode.MapNodeType.BOSS,
		 MapNode.MapNodeType.FINAL_BOSS]
