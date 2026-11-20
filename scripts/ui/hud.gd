class_name Hud
extends CanvasLayer
## On-screen info: day/time, tool hotbar, short messages, and the inventory window.

@onready var info: Label = $Info
@onready var message: Label = $Message
@onready var message_timer: Timer = $MessageTimer

var hotbar := Hotbar.new()
var inventory := InventoryUI.new()


func _ready() -> void:
	add_child(hotbar)
	add_child(inventory)
	GameState.time_changed.connect(func(_m): _refresh())
	GameState.day_changed.connect(func(_d): _refresh())
	message_timer.timeout.connect(func(): message.text = "")
	_refresh()


func set_tool(tool: int) -> void:
	hotbar.set_selected(tool)


func show_message(text: String) -> void:
	message.text = text
	message_timer.start()


func _refresh() -> void:
	info.text = "Day %d   %s\n[I] Inventori" % [GameState.day, GameState.time_text()]
