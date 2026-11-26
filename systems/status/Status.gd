class_name Status
extends RefCounted

enum Target { PLAYER, OPPONENT, BOTH}
enum Duration { PERMANENT, UNTIL_STAGE_END, N_MAP_TURNS, UNTIL_NEXT_BATTLE }
enum State    { PENDING, ACTIVE, APPLIED, EXPIRED }
enum StackPolicy { REJECT, STACK }

var definition_id: String
var display_name: String
var stack_policy: StackPolicy = StackPolicy.REJECT
var duration: Duration = Duration.PERMANENT
var duration_value: int = 0

var player: Player
var state: State = State.PENDING

var _remaining: int = 0

func activate(p: Player) -> void:
	if state != State.PENDING: return
	player = p
	state = State.ACTIVE
	_remaining = duration_value
	_on_activate()
	_connect_duration()

func _on_activate() -> void:
	pass  # override: flags, unlocks, one-shots (set state = APPLIED)

func _on_expire() -> void:
	pass  # override: revert flags

func get_player_modifiers()   -> Array[StatModifier]: return []  # override
func get_opponent_modifiers() -> Array[StatModifier]: return []  # override

func _disconnect_other_signals() -> void:
	pass  # override: disconnect all connected signals from overridden functions

func _connect_duration() -> void:
	match duration:
		Duration.UNTIL_STAGE_END: EventBus.stage_started.connect(_on_stage_ended)
		Duration.N_MAP_TURNS:     EventBus.map_turn_started.connect(_on_turn)
		Duration.UNTIL_NEXT_BATTLE: EventBus.battle_resolved.connect(_expire_cb)

func _disconnect_duration() -> void:
	if EventBus.stage_started.is_connected(_on_stage_ended):
		EventBus.stage_started.disconnect(_on_stage_ended)
	if EventBus.map_turn_started.is_connected(_on_turn):
		EventBus.map_turn_started.disconnect(_on_turn)
	if EventBus.battle_resolved.is_connected(_expire_cb):
		EventBus.battle_resolved.disconnect(_expire_cb)

func _on_stage_ended(_s): expire()
func _on_turn(_n):
	_remaining -= 1
	if _remaining <= 0: expire()
func _expire_cb(_r): expire()

func expire() -> void:
	if state == State.EXPIRED: return
	state = State.EXPIRED
	_disconnect_duration()
	_disconnect_other_signals()
	player.active_status.erase(self)
	_on_expire()
