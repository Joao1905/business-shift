# EventDefinition.gd
class_name EventDefinition
extends Resource

@export var id: String
@export var display_name: String
@export_multiline var description: String

func build() -> Array[Status]:
	match id:
		"heavy_thunder":
			return []
		# ...
	push_error("Unknown event id: %s" % id)
	return []
