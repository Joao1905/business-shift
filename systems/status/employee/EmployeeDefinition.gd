# EmployeeDefinition.gd
class_name EmployeeDefinition
extends Resource

@export var id: String
@export var display_name: String
@export var description: String
@export var requires: Array[String] = []
@export var price: int

func build() -> Status:
	match id:
		"bricklayer":  return BricklayerStatus.new()
		# ...
	push_error("Unknown employee id: %s" % id)
	return null
