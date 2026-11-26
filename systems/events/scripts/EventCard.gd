extends Panel

var event_def: EventDefinition

@onready var event_title: Label = $VBoxContainer/EventTitleMargin/EventTitle
@onready var event_desc: Label = $VBoxContainer/EventDescMargin/EventDesc

func update_data(event_def: EventDefinition) -> void:
	self.event_def = event_def
	event_title.text = event_def.display_name
	event_desc.text = event_def.description
