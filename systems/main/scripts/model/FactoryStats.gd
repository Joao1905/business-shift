class_name FactoryStats
extends RefCounted

var initialized: bool = false
var stats : Dictionary[FactoryStatsData.Type, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func initialize_stats(labor: int, technology: int, production: int) -> FactoryStats:
	var statsObj = new()
	statsObj.initialized = true
	statsObj.stats[FactoryStatsData.Type.LABOR] = labor
	statsObj.stats[FactoryStatsData.Type.TECHNOLOGY] = technology
	statsObj.stats[FactoryStatsData.Type.PRODUCTION] = production
	return statsObj
