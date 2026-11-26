extends Panel

var _tween: Tween
var employee_def: EmployeeDefinition
signal card_chosen(employee_def: EmployeeDefinition)

@onready var card_title: Label = $VBoxContainer/CardTitleMargin/CardTitle
@onready var card_description: Label = $VBoxContainer/CardDescriptionMargin/CardDescription
@onready var card_cost: Label = $VBoxContainer/CardCostMargin/CardCost

func _ready() -> void:
	_handle_subscriptions()

func update_data(employee_def: EmployeeDefinition) -> void:
	self.employee_def = employee_def
	card_title.text = employee_def.display_name
	card_description.text = employee_def.description
	card_cost.text = "$ " + str(employee_def.price)

func _handle_subscriptions() -> void:
	mouse_entered.connect(_animate_on_hover.bind(true))
	mouse_exited.connect(_animate_on_hover.bind(false))
	gui_input.connect(_on_gui_input)

func _animate_on_hover(hovered: bool) -> void:
	if _tween:
		_tween.kill()
		
	self.pivot_offset = self.size / 2.0
	_tween = create_tween()
	_tween.tween_property(self, "scale", Vector2.ONE * (1.05 if hovered else 1.0), 0.1) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			card_chosen.emit(self.employee_def)
