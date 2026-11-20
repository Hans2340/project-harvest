class_name Hud
extends CanvasLayer
## On-screen info: minimap (top-left), clock (top-right), tool hotbar, short messages, inventory window.

@onready var info: Label = $Info
@onready var message: Label = $Message
@onready var message_timer: Timer = $MessageTimer

var hotbar := Hotbar.new()
var inventory := InventoryUI.new()
var clock := ClockUI.new()
var minimap := MinimapUI.new()


func _ready() -> void:
	layer = 2   # above the world-space effects layer (rain, fireflies)
	add_child(hotbar)
	add_child(clock)
	add_child(minimap)
	add_child(inventory)
	message_timer.timeout.connect(func(): message.text = "")
	_refresh()


func set_tool(tool: int) -> void:
	hotbar.set_selected(tool)


func show_message(text: String) -> void:
	message.text = text
	message_timer.start()


func _refresh() -> void:
	info.text = "[I] Inventori   [M] Peta"
