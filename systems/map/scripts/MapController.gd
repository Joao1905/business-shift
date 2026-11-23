class_name MapController
extends Node

@export var root: MapNode
signal map_node_clicked(node: MapNode)
var current_node: MapNode = null:
	set(value):
		current_node = value
		GameData.current_node = value

func _ready() -> void:
	assert(root != null, MapErrors.UNASSIGNED_ROOT_ERROR)
	_initialize()


func reset() -> void:
	if (current_node):
		_reset_nodes(root)
	_initialize()


func notify_node_click(node: MapNode) -> void:
	if node.state != MapNode.MapNodeState.SELECTABLE:
		return
		
	if node.coordinates == MapConfigs.LAST_NODE_COORD:
		return reset()
	
	_disable_not_chosen_nodes()
	
	current_node = node
	current_node.state = MapNode.MapNodeState.COMPLETED
	for child in node.children:
		child.state = MapNode.MapNodeState.SELECTABLE
	
	map_node_clicked.emit(node)


func _initialize() -> void:
	current_node = null


func _disable_not_chosen_nodes() -> void:
	if not current_node:
		return
		
	for child in current_node.children:
		child.state = MapNode.MapNodeState.DISABLED


func _reset_nodes(node: MapNode) -> void:
	# Since a node can have multiple parents, it might be reset multiple times, but that is fine
	node.initialize()
	for child in node.children:
		_reset_nodes(child)
