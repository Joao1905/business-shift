class_name BricklayerStatus
extends Status
# bônus condicional: só "aparece" depois de ganhar batalha com LABOR

var _earned_bonus := false

func _init() -> void:
	display_name  = "bricklayer"
	stack_policy  = StackPolicy.REJECT
	duration      = Duration.PERMANENT

func _on_activate() -> void:
	EventBus.battle_won.connect(_on_battle_won)

func _on_battle_won(_opp, attr) -> void:
	if attr == Player.LABOR:
		_earned_bonus = true

func get_modifiers() -> Array[StatModifier]:
	if not _earned_bonus: return []
	var m := StatModifier.new()
	m.attribute = StatModifier.Attribute.LABOR
	m.mode = StatModifier.Mode.PERCENT
	m.value = 0.03
	return [m]
