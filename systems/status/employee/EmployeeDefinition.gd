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
		"engineer":  return EngineerStatus.new()
		"steam_whisperer":  return SteamWhispererStatus.new()
		"three_equal_men":  return ThreeEqualMenStatus.new()
	push_error("Unknown employee id: %s" % id)
	return null
