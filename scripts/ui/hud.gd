class_name Hud
extends CanvasLayer
## On-screen info: clock (top-right), tool hotbar, short messages, and the inventory window.

@onready var info: Label = $Info
@onready var message: Label = $Message
@onready var message_timer: Timer = $MessageTimer

var hotbar := Hotbar.new()
var inventory := InventoryUI.new()
var clock := ClockUI.new()


func _ready() -> void:
	add_child(hotbar)
	add_child(clock)
	add_child(inventory)
	message_timer.timeout.connect(func(): message.text = "")
	_refresh()


func set_tool(tool: int) -> void:
	hotbar.set_selected(tool)


func show_message(text: String) -> void:
	message.text = text
	message_timer.start()


func _refresh() -> void:
	info.text = "[I] Inventori"
