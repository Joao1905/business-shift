class_name EventController
extends Control

@onready var main: MainController = $".."
@onready var event_card: Panel = $MarginContainer/VBoxContainer/EventCardMargin/EventCard

var event_definitions: Array[EventDefinition] = []

func _ready() -> void:
	event_definitions = [
		preload("res://systems/status/event/fire_fire_fire.tres"),
		preload("res://systems/status/event/heavy_thunder.tres"),
		preload("res://systems/status/event/just_an_incident.tres"),
	]
	assert(event_definitions.size())

func initialize() -> void:
	var chosen_event_def: EventDefinition = event_definitions.pick_random()
	event_card.update_data(chosen_event_def)
	var statuses: Array[Status] = chosen_event_def.build()
	for status in statuses:
		main.player.apply_status(status)
	
func exit() -> void:
	main.load_screen(MainController.SCREENS.MAP)
