class_name InventoryUI
extends Control
## Inventory window (I / Tab). Pauses the game while open (single player).
## Built from the Dark Ages UI pack: ornate frame, gold banner, item slots.

const COLUMNS := 6
const ROWS := 3
const WINDOW_SIZE := Vector2(256, 216)

var _slots: Array[ItemSlot] = []
var _name: Label
var _desc: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = false

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.45)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(dim)

	var win := UiSkin.nine(UiSkin.FRAME_ORNATE, 32)
	win.size = WINDOW_SIZE
	win.set_anchors_preset(Control.PRESET_CENTER)
	win.position = -WINDOW_SIZE / 2.0
	win.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(win)

	var banner := UiSkin.nine(UiSkin.BANNER_GOLD, 20, 0)
	banner.size = Vector2(112, 28)
	banner.position = Vector2((WINDOW_SIZE.x - 112) / 2.0, -12)
	win.add_child(banner)
	var title := UiSkin.label("INVENTORI", 10, UiSkin.TEXT_GOLD)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(0, 10)
	title.size = Vector2(112, 16)
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	banner.add_child(title)

	var close := TextureButton.new()
	close.texture_normal = UiSkin.tex(UiSkin.CLOSE)
	close.position = Vector2(WINDOW_SIZE.x - 30, 14)
	close.pressed.connect(close_inventory)
	win.add_child(close)

	var grid := GridContainer.new()
	grid.columns = COLUMNS
	grid.add_theme_constant_override("h_separation", 2)
	grid.add_theme_constant_override("v_separation", 2)
	grid.position = Vector2((WINDOW_SIZE.x - (COLUMNS * 34 - 2)) / 2.0, 30)
	win.add_child(grid)
	for i in COLUMNS * ROWS:
		var s := ItemSlot.new()
		s.hovered.connect(_show_details)
		grid.add_child(s)
		_slots.append(s)

	var info := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	info.position = Vector2(26, 138)
	info.size = Vector2(WINDOW_SIZE.x - 52, 52)
	win.add_child(info)
	_name = UiSkin.label("", 10, UiSkin.TEXT_GOLD)
	_name.position = Vector2(8, 5)
	info.add_child(_name)
	_desc = UiSkin.label("", 8)
	_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_desc.position = Vector2(8, 19)
	_desc.size = Vector2(info.size.x - 16, 30)
	info.add_child(_desc)

	GameState.items_changed.connect(refresh)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if visible:
			close_inventory()
		else:
			open_inventory()
		get_viewport().set_input_as_handled()
	elif visible and event.is_action_pressed("ui_cancel"):
		close_inventory()
		get_viewport().set_input_as_handled()


func open_inventory() -> void:
	refresh()
	visible = true
	get_tree().paused = true


func close_inventory() -> void:
	visible = false
	get_tree().paused = false


## Fill slots from GameState.items, in ItemDB order. Empty stacks are skipped.
func refresh() -> void:
	var i := 0
	for id in ItemDB.ITEMS:
		var count: int = GameState.items.get(id, 0)
		if count <= 0 or i >= _slots.size():
			continue
		_slots[i].set_item(id, ItemDB.get_item(id).icon, count)
		i += 1
	for j in range(i, _slots.size()):
		_slots[j].clear()
	_show_details(_slots[0])


func _show_details(slot: ItemSlot) -> void:
	var item := ItemDB.get_item(slot.item_id)
	if item == null:
		_name.text = ""
		_desc.text = "Empty slot." if slot.item_id == "" else ""
		return
	_name.text = "%s  x%d" % [item.display_name, GameState.items.get(item.id, 0)]
	_desc.text = item.description
