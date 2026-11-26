class_name JustAnIncidentStatus
extends Status

func _init() -> void:
	display_name = "Just an Incident"
	stack_policy = StackPolicy.STACK
	duration = Duration.UNTIL_STAGE_END

func get_player_modifiers() -> Array[StatModifier]:
	return [
		_mod(StatModifier.Attribute.LABOR,      -0.05),
		_mod(StatModifier.Attribute.PRODUCTION, -0.05),
	]

func _mod(attr: int, value: float) -> StatModifier:
	var m: StatModifier = StatModifier.new()
	m.display_name = self.display_name
	m.attribute = attr
	m.mode = StatModifier.Mode.PERCENT
	m.value = value
	return m
