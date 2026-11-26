class_name StatModifier
extends Resource

enum Attribute { LABOR, TECH, PRODUCTION, ALL }
enum Mode      { FLAT, PERCENT }

@export var display_name: String
@export var attribute: Attribute = Attribute.ALL
@export var mode: Mode = Mode.PERCENT
@export var value: float = 0.0
