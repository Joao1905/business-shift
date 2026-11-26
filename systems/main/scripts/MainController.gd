class_name MainController
extends Node

var player: Player
enum SCREENS {MAP, TITLE, HIRE, EVENT}
@onready var screen_to_node: Dictionary[SCREENS, Node] = {
	SCREENS.MAP: $Map,
	SCREENS.TITLE: $TitleScreen,
	SCREENS.HIRE: $HireScreen,
	SCREENS.EVENT: $EventScreen,
}

var visible_screen: Node = null

func _ready() -> void:
	screen_to_node[SCREENS.MAP].map_node_clicked.connect(_on_map_node_clicked)
	_initialize_game()
	load_screen(SCREENS.TITLE)

func load_screen(screen: SCREENS) -> void:
	if visible_screen:
		visible_screen.visible = false
	
	visible_screen = screen_to_node[screen]
	visible_screen.visible = true

func _initialize_game() -> void:
	self.player = Player.new()

func _hide_all_screens() -> void:
	for screen in screen_to_node.values():
		screen.visible = false

func _on_map_node_clicked(node: MapNode) -> void:
	match node.type:
		MapNode.MapNodeType.HIRE:
			screen_to_node[SCREENS.HIRE].initialize()
			load_screen(SCREENS.HIRE)
		MapNode.MapNodeType.EVENT:
			screen_to_node[SCREENS.EVENT].initialize()
			load_screen(SCREENS.EVENT)
		_: return
