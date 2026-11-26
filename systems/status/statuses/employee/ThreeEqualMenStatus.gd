class_name ThreeEqualMenStatus
extends Status

const ALL_BONUS: float = 0.05

var _n_earned_bonuses: int = 0
var _already_earned_this_stage: bool = false
var _used_business_models: Dictionary[Player.BUSINESS_MODELS, bool] = {
	Player.BUSINESS_MODELS.LABOR: false,
	Player.BUSINESS_MODELS.TECH: false,
	Player.BUSINESS_MODELS.PRODUCTION: false,
}

func _init() -> void:
	definition_id = "three_equal_men"
	display_name  = "Three Equal Men"
	stack_policy  = StackPolicy.STACK
	duration      = Duration.PERMANENT

func _on_activate() -> void:
	EventBus.stage_started.connect(_on_stage_started)
	EventBus.business_model_changed.connect(_on_business_model_changed)

func _disconnect_other_signals() -> void:
	if EventBus.stage_started.is_connected(_on_stage_started):
		EventBus.stage_started.disconnect(_on_stage_started)
	if EventBus.business_model_changed.is_connected(_on_business_model_changed):
		EventBus.business_model_changed.disconnect(_on_business_model_changed)

func _on_stage_started() -> void:
	_already_earned_this_stage = false
	for key in _used_business_models.keys():
		_used_business_models[key] = false
	
func _on_business_model_changed(new_model: Player.BUSINESS_MODELS, old_model: Player.BUSINESS_MODELS) -> void:
	_used_business_models[new_model] = true
	if 	not _already_earned_this_stage \
		and _used_business_models[Player.BUSINESS_MODELS.LABOR] \
		and _used_business_models[Player.BUSINESS_MODELS.TECH] \
		and _used_business_models[Player.BUSINESS_MODELS.PRODUCTION]:
		_n_earned_bonuses += 1
		_already_earned_this_stage = true

func get_player_modifiers() -> Array[StatModifier]:
	if not _n_earned_bonuses: return []
	var m: StatModifier = StatModifier.new()
	m.display_name = self.display_name
	m.attribute = StatModifier.Attribute.ALL
	m.mode = StatModifier.Mode.PERCENT
	m.value = ALL_BONUS * _n_earned_bonuses
	return [m]
