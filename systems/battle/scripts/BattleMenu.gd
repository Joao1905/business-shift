extends Control

@onready var main_controller: MainController = $"/root/Main" as MainController
@onready var player_battle_menu: UiMenu = %PlayerBattleMenu

@onready var takeover_option: UiMenuOption = %TakeoverOption
@onready var shift_option: UiMenuOption = %ShiftOption
@onready var reevaluate_option: UiMenuOption = %ReevaluateOption

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reevaluate Handling
	takeover_option.menu_option_selected.connect(_on_takeover_option)
	reevaluate_option.menu_option_selected.connect(_on_reevaluate_option)
	
	# Shift Handling
	for data in FactoryStatsRegistry.entries:
		var opt := UiMenuOption.create(data.label, data.color)
		shift_option.add_child(opt)
		opt.menu_option_selected.connect(_on_shift_option_selected.bind(data))
		
func _on_shift_option_selected(data: FactoryStatsData) -> void:
	GameData.factory.factory_model = data.type
	shift_option.set_disabled(true)
	player_battle_menu.reset()

func _on_takeover_option() -> void:
	pass
	
func _on_reevaluate_option() -> void:
	# Get highest stat, and multiply that in the original reference by 0.8
	var stats: Dictionary = GameData.factory.factory_stats.stats
	var max_value: int = stats.values().max()
	var highest_key = stats.find_key(max_value)
	stats[highest_key] = roundi(max_value * 0.8)
	
	# Return to map
	main_controller.load_screen(main_controller.SCREENS.MAP)
