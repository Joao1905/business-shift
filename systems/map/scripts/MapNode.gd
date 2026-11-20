class_name MapNode
extends Panel

@export var map_controller: MapController
@onready var label: Label = $Label

var _tween: Tween

enum MapNodeType {START, BATTLE, BATTLE_PLUS, SHOP, EVENT, BOSS, FINAL_BOSS}
enum MapNodeState {ACTIVE, SELECTABLE, ENABLED, DISABLED, COMPLETED}
var STATE_STYLES: Dictionary[MapNodeState, Resource] = {}

@export var children: Array[MapNode]
var coordinates: Vector2i
var type: MapNodeType
var state: MapNodeState:
	set(value):
		state = value
		_set_state(value)


func _ready() -> void:
	assert(map_controller != null, MapErrors.UNASSIGNED_CONTROLLER_ERROR)
	
	_handle_subscriptions()
	_general_setup()
	initialize()
	
	if (self.coordinates != MapConfigs.LAST_NODE_COORD):
		assert(children.size() != 0, MapErrors.UNASSIGNED_CHILDREN_ERROR)


func initialize() -> void:
	self.coordinates = _get_stage_and_option()
	self.type = _generate_random_type(self.coordinates)
	label.text = _type_to_acronym(self.type)
	self.state = _get_initial_state(self.coordinates)


func _handle_subscriptions() -> void:
	mouse_entered.connect(_animate_on_hover.bind(true))
	mouse_exited.connect(_animate_on_hover.bind(false))
	gui_input.connect(_on_click)


func _general_setup() -> void:
	pivot_offset = size / 2.0
	STATE_STYLES[MapNodeState.ACTIVE] = preload("res://systems/map/assets/themes/map_node_active.tres")
	STATE_STYLES[MapNodeState.SELECTABLE] = preload("res://systems/map/assets/themes/map_node_enabled_selectable.tres")
	STATE_STYLES[MapNodeState.ENABLED] = preload("res://systems/map/assets/themes/map_node_enabled_selectable.tres")
	STATE_STYLES[MapNodeState.DISABLED] = preload("res://systems/map/assets/themes/map_node_disabled.tres")
	STATE_STYLES[MapNodeState.COMPLETED] = preload("res://systems/map/assets/themes/map_node_completed.tres")


func _set_state(new_state: MapNodeState) -> void:
	self.add_theme_stylebox_override("panel", STATE_STYLES[new_state])


func _get_stage_and_option() -> Vector2i:
	var parsed_node_name: PackedStringArray = self.name.split(",")
	assert(parsed_node_name.size() == 2, MapErrors.MAP_NODE_NAME_ERROR)
	assert(int(parsed_node_name[0]) != 0, MapErrors.MAP_NODE_NAME_ERROR)
	return Vector2i(int(parsed_node_name[0]),int(parsed_node_name[1]))


func _generate_random_type(coords: Vector2i) -> MapNodeType:
	if (coords == MapConfigs.FIRST_NODE_COORD):
		return MapNodeType.START
		
	if (coords == MapConfigs.LAST_NODE_COORD):
		return MapNodeType.BOSS
		
	var excluded = 	[MapNodeType.START, MapNodeType.BOSS, MapNodeType.FINAL_BOSS]
	var valid_node_types = MapNodeType.values().filter(func(type): return type not in excluded)
	return valid_node_types.pick_random()


func _type_to_acronym(type: MapNodeType) -> String:
	match type:
		MapNodeType.START: return "St"
		MapNodeType.BATTLE: return "Ba"
		MapNodeType.BATTLE_PLUS: return "B+"
		MapNodeType.SHOP: return "Sh"
		MapNodeType.EVENT: return "Ev"
		MapNodeType.BOSS: return "Bo"
		MapNodeType.FINAL_BOSS: return "MVP"
		_: return ""


func _get_initial_state(coords: Vector2i) -> MapNodeState:
	if (coords == MapConfigs.FIRST_NODE_COORD):
		return MapNodeState.SELECTABLE
		
	return MapNodeState.DISABLED


func _on_click(event: InputEvent) -> void:
	var is_left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if  is_left_click:
		map_controller.notify_node_click(self)
		accept_event()


func _animate_on_hover(hovered: bool) -> void:
	if self.state != MapNodeState.SELECTABLE:
		return
	
	if _tween:
		_tween.kill()
		
	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector2.ONE * (1.2 if hovered else 1.0), 0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)
	
