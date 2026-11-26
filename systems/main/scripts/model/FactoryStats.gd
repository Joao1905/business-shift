class_name FactoryStats
extends RefCounted

enum EStats {
	Labor = 1,
	Technology = 2,
	Production = 3
}

var initialized: bool = false
var stats : Dictionary[EStats, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func initialize_stats(labor: int, technology: int, production: int) -> FactoryStats:
	var statsObj = new()
	statsObj.initialized = true
	statsObj.stats[EStats.Labor] = labor
	statsObj.stats[EStats.Technology] = technology
	statsObj.stats[EStats.Production] = production
	return statsObj
