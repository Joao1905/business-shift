extends Node

enum SCREENS {MAP, TITLE}
@onready var _screen_to_node: Dictionary[SCREENS, Node] = {
	SCREENS.MAP: $Map,
	SCREENS.TITLE: $TitleScreen
}

var visible_screen: Node = null

func _ready() -> void:
	load_screen(SCREENS.TITLE)

func load_screen(screen: SCREENS) -> void:
	if visible_screen:
		visible_screen.visible = false
	
	visible_screen = _screen_to_node[screen]
	visible_screen.visible = true

func _hide_all_screens() -> void:
	for screen in SCREENS.values():
		screen.visible = false
