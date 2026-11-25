extends Node
# Sem class_name — autoload já fornece o nome global.

# Emited by Map
signal map_turn_ended(new_turn_number: int)
signal stage_started(stage: int)

# Emited by Battle
signal battle_started(opponent)
signal battle_won(opponent, attribute_used: int)
signal battle_lost(opponent, attribute_used: int)
signal battle_resolved(result)
signal business_model_changed(new_model: int, old_model: int)

# Emited by Hires
signal employee_hired(employee_id: String)
