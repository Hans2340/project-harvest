class_name ItemData
extends Resource
## Definition of an inventory item. One .tres per item in resources/items/.

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D
@export var max_stack: int = 99
