class_name HeavyThunderStatus
extends Status

func _init() -> void:
	display_name = "Heavy Thunder"
	stack_policy = StackPolicy.STACK
	duration = Duration.UNTIL_STAGE_END

func get_opponent_modifiers() -> Array[StatModifier]:
	var m: StatModifier = StatModifier.new()
	m.display_name = self.display_name
	m.attribute = StatModifier.Attribute.PRODUCTION
	m.mode = StatModifier.Mode.PERCENT
	m.value = -0.05
	return [m]
