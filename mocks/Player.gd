class_name Player

enum BUSINESS_MODELS {LABOR = 0, TECH = 1, PRODUCTION = 2}

var current_business_model: int = BUSINESS_MODELS.LABOR
var base_stats: Dictionary = {
	BUSINESS_MODELS.LABOR: 10,
	BUSINESS_MODELS.TECH: 10,
	BUSINESS_MODELS.PRODUCTION: 10
}
var active_status: Array[Status] = []  # can be Array, O(n) is irrelevant for ~20 statuses

# Called whenever you want to calculate attributes based on active status
func get_stat_breakdown(attr: int) -> Dictionary:
	var flat_terms: Array = []
	var pct_terms:  Array = []

	for status in active_status:
		for stat_modifier in status.get_modifiers():
			if stat_modifier.attribute != attr and stat_modifier.attribute != StatModifier.Attribute.ALL:
				continue
			var term := {"name": stat_modifier.display_name, "value": stat_modifier.value}
			match stat_modifier.mode:
				StatModifier.Mode.FLAT:    flat_terms.append(term)
				StatModifier.Mode.PERCENT: pct_terms.append(term)

	var flat: float = 0.0
	for t in flat_terms: flat += t.value
	var pct: float = 0.0
	for t in pct_terms:  pct  += t.value

	return {
		"base":       base_stats[attr],
		"flat_terms": flat_terms,
		"pct_terms":  pct_terms,
		"flat":       flat,
		"pct":        pct,
		"final":      maxf(0.0, (base_stats[attr] + flat) * (1.0 + pct)),
	}


# Called by Events and HireEmployees UIs when player chooses an option
func apply_status(e: Status) -> void:
	if e == null or e.state != Status.State.PENDING:
		return
	if e.stack_policy == Status.StackPolicy.REJECT and has_status(e.definition_id):
		return
	print("status appended")
	active_status.append(e)
	e.activate(self)


func has_status(def_id: String) -> bool:
	for e in active_status:
		if e.definition_id == def_id:
			return true
	return false


func get_status_by_definition(def_id: String) -> Array[Status]:
	return active_status.filter(func(e): return e.definition_id == def_id)
