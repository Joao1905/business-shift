class_name FactoryStats
extends RefCounted

var initialized: bool = false
var labor: int
var technology: int
var production: int

func _init(l: int, t: int, p: int) -> void:
	labor = l
	technology = t
	production = p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func initialize_stats(labor: int, technology: int, production: int) -> FactoryStats:
	var stats = new(labor, technology, production)
	stats.initialized = true
	return stats
