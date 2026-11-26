class_name EngineerStatus
extends Status

var _earned_bonus: bool = false

func _init() -> void:
	definition_id = "engineer"
	display_name  = "Engineer"
	stack_policy  = StackPolicy.STACK
	duration      = Duration.PERMANENT

func _on_activate() -> void:
	EventBus.battle_won.connect(_on_battle_won)

func _disconnect_other_signals() -> void:
	if EventBus.battle_won.is_connected(_on_battle_won):
		EventBus.battle_won.disconnect(_on_battle_won)

func _on_battle_won(_opp, attr) -> void:
	if attr == Player.BUSINESS_MODELS.TECH:
		_earned_bonus = true

func get_player_modifiers() -> Array[StatModifier]:
	if not _earned_bonus: return []
	var m: StatModifier = StatModifier.new()
	m.display_name = self.display_name
	m.attribute = StatModifier.Attribute.TECH
	m.mode = StatModifier.Mode.PERCENT
	m.value = 0.05
	return [m]
