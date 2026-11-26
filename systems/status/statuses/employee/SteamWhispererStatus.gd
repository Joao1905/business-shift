class_name SteamWhispererStatus
extends Status

const STREAK_REQUIRED: int = 5
const PRODUCTION_BONUS: float = 0.10
const OFF_MODEL_PENALTY: float = 0.05

var _streak: int = 0
var _earned_bonus: bool = false

func _init() -> void:
	definition_id = "steam_whisperer"
	display_name = "Steam Whisperer"
	stack_policy = StackPolicy.STACK
	duration     = Duration.PERMANENT

# lifecycle

func _on_activate() -> void:
	EventBus.battle_resolved.connect(_on_battle_resolved)
	EventBus.business_model_changed.connect(_on_model_changed)

func _disconnect_other_signals() -> void:
	if EventBus.battle_resolved.is_connected(_on_battle_resolved):
		EventBus.battle_resolved.disconnect(_on_battle_resolved)
	if EventBus.business_model_changed.is_connected(_on_model_changed):
		EventBus.business_model_changed.disconnect(_on_model_changed)

# streak logic

func _on_battle_resolved(_result) -> void:
	if player.current_business_model == Player.BUSINESS_MODELS.PRODUCTION:
		_streak += 1
		if _streak >= STREAK_REQUIRED:
			_earned_bonus = true
	else:
		_streak = 0

func _on_model_changed(_new_model: int, _old_model: int) -> void:
	_streak = 0

# modifiers

func get_player_modifiers() -> Array[StatModifier]:
	var out: Array[StatModifier] = []

	if _earned_bonus:
		out.append(_make_mod(StatModifier.Attribute.PRODUCTION, PRODUCTION_BONUS))

	if player.current_business_model != Player.BUSINESS_MODELS.PRODUCTION:
		out.append(_make_mod(StatModifier.Attribute.LABOR, -OFF_MODEL_PENALTY))
		out.append(_make_mod(StatModifier.Attribute.TECH,  -OFF_MODEL_PENALTY))

	return out

func _make_mod(attr: int, value: float) -> StatModifier:
	var m: StatModifier = StatModifier.new()
	m.display_name = self.display_name
	m.attribute = attr
	m.mode = StatModifier.Mode.PERCENT
	m.value = value
	return m
