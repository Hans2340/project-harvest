class_name ItemSlot
extends TextureRect
## One 32x32 inventory/hotbar slot: background, icon, stack count, optional key hint.

signal hovered(slot: ItemSlot)

var item_id: String = ""

var _icon := TextureRect.new()
var _count: Label
var _key: Label


func _init() -> void:
	custom_minimum_size = Vector2(32, 32)
	texture = UiSkin.tex(UiSkin.SLOT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_icon.position = Vector2(6, 9)
	_icon.size = Vector2(20, 20)
	_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_icon)
	_count = UiSkin.label("", 8)
	_count.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_count.position = Vector2(0, 18)
	_count.size = Vector2(27, 12)
	add_child(_count)
	_key = UiSkin.label("", 8, UiSkin.TEXT_GOLD)
	_key.position = Vector2(4, 3)
	add_child(_key)
	mouse_entered.connect(func(): hovered.emit(self))


func set_item(id: String, icon: Texture2D, count: int = 0) -> void:
	item_id = id
	_icon.texture = icon
	_count.text = str(count) if count > 1 else ""


func clear() -> void:
	set_item("", null, 0)


func set_key_hint(text: String) -> void:
	_key.text = text


func set_selected(on: bool) -> void:
	texture = UiSkin.tex(UiSkin.SLOT_SELECTED if on else UiSkin.SLOT)
