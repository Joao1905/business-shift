class_name FireFireFireStatus
extends Status

const PLAYER_PENALTY: float = -0.10
const OPPONENT_PENALTY: float = -0.15

func _init() -> void:
	display_name = "Fire! Fire! Fire!"
	stack_policy = StackPolicy.STACK
	duration = Duration.UNTIL_STAGE_END

func get_player_modifiers() -> Array[StatModifier]:
	return [_mod(PLAYER_PENALTY)]

func get_opponent_modifiers() -> Array[StatModifier]:
	return [_mod(OPPONENT_PENALTY)]

func _mod(value: float) -> StatModifier:
	var m: StatModifier = StatModifier.new()
	m.display_name = self.display_name
	m.attribute = StatModifier.Attribute.LABOR
	m.mode = StatModifier.Mode.PERCENT
	m.value = value
	return m
