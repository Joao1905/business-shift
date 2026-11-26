extends Button

@onready var event_screen: Control = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(event_screen.exit)
