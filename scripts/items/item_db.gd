class_name ItemDB
extends RefCounted
## Registry of all item definitions. Add new items here (and in resources/items/).
## The order here is the order items appear in the inventory.

const ITEMS := {
	"padi_seed": preload("res://resources/items/padi_seed.tres"),
	"padi": preload("res://resources/items/padi.tres"),
}


static func get_item(id: String) -> ItemData:
	return ITEMS.get(id)
