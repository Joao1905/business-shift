extends Label

func _ready() -> void:
	self.text = "$"

func update_balance_text(new_balance: int) -> void:
	self.text = "$ "+str(new_balance)
