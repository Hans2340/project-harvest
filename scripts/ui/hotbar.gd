class_name Hotbar
extends Control
## Bottom-centre tool bar. Shows the player's tools; the selected one gets the gold slot.

const TOOL_ICONS := [
	preload("res://assets/sprites/placeholder/icons/tool_hoe.png"),
	preload("res://assets/sprites/placeholder/icons/padi_seed.png"),
	preload("res://assets/sprites/placeholder/icons/tool_water.png"),
]

var _slots: Array[ItemSlot] = []
var _name_label: Label
var _row := HBoxContainer.new()


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_row.add_theme_constant_override("separation", 2)
	add_child(_row)
	for i in TOOL_ICONS.size():
		var s := ItemSlot.new()
		s.set_item("tool_%d" % i, TOOL_ICONS[i])
		s.set_key_hint(str(i + 1))
		_row.add_child(s)
		_slots.append(s)
	var width := TOOL_ICONS.size() * 34 - 2
	_row.position = Vector2(-width / 2.0, -38)
	_name_label = UiSkin.label("", 8, UiSkin.TEXT_GOLD)
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_label.position = Vector2(-80, -52)
	_name_label.size = Vector2(160, 12)
	add_child(_name_label)
	GameState.items_changed.connect(_refresh_counts)
	_refresh_counts()


func set_selected(tool: int) -> void:
	for i in _slots.size():
		_slots[i].set_selected(i == tool)
	_name_label.text = Player.TOOL_NAMES[tool]


## Seeds slot shows how many seeds are left.
func _refresh_counts() -> void:
	if _slots.size() > 1:
		_slots[1].set_item("tool_1", TOOL_ICONS[1], GameState.items.get("padi_seed", 0))
