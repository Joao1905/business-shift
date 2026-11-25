extends Button

@onready var hire_screen: Control = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(hire_screen.exit)
