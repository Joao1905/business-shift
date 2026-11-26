extends Control

@onready var main: Node2D = $".."
@onready var balance: Label = $MarginContainer/Balance

var cards: Array[Panel] = []
var employee_definitions: Array[EmployeeDefinition] = []

func _ready() -> void:
	cards = [
		$MarginContainer/VBoxContainer/ScreenContent/CardMargin/Card,
		$MarginContainer/VBoxContainer/ScreenContent/CardMargin2/Card,
		$MarginContainer/VBoxContainer/ScreenContent/CardMargin3/Card,
	]
	employee_definitions = [
		preload("res://systems/status/employee/bricklayer.tres"),
		preload("res://systems/status/employee/engineer.tres"),
		preload("res://systems/status/employee/steam_whisperer.tres"),
		preload("res://systems/status/employee/three_equal_men.tres"),
	]
	assert(employee_definitions.size() >= cards.size())
	for card in cards:
		card.card_chosen.connect(on_card_click)

func initialize() -> void:
	_generate_random_cards()
	balance.update_balance_text(main.player.get_balance())
	
func _generate_random_cards() -> void:
	var chosen_employees: Array[EmployeeDefinition] = _pick_random(cards.size())
	for i in cards.size():
		cards[i].update_data(chosen_employees[i])

func exit() -> void:
	main.load_screen(MainController.SCREENS.MAP)

func on_card_click(employee_def: EmployeeDefinition):
	if not main.player.try_spend_money(employee_def.price):
		return
		
	var employee: Status = employee_def.build()
	main.player.apply_status(employee)
	exit()

func _pick_random(n: int = 3) -> Array[EmployeeDefinition]:
	var pool: Array[EmployeeDefinition] = employee_definitions.duplicate()
	pool.shuffle()
	return pool.slice(0, n)
