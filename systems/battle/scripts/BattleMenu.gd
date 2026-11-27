extends Control

@onready var player_battle_menu: UiMenu = %PlayerBattleMenu
@onready var shift_option: UiMenuOption = %ShiftOption

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for data in FactoryStatsRegistry.entries:
		var opt := UiMenuOption.create(data.label, data.color)
		shift_option.add_child(opt)
		opt.menu_option_selected.connect(_on_shift_option_selected.bind(data))
		
func _on_shift_option_selected(data: FactoryStatsData) -> void:
	GameData.factory.factory_model = data.type
	shift_option.set_disabled(true)
	player_battle_menu.reset()
