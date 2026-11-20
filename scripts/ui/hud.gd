class_name Hud
extends CanvasLayer
## On-screen info: day, time, current tool, items, and short messages.

@onready var info: Label = $Info
@onready var message: Label = $Message
@onready var message_timer: Timer = $MessageTimer

var _tool_name := ""


func _ready() -> void:
	GameState.time_changed.connect(func(_m): _refresh())
	GameState.day_changed.connect(func(_d): _refresh())
	GameState.items_changed.connect(_refresh)
	message_timer.timeout.connect(func(): message.text = "")
	_refresh()


func set_tool(tool: int) -> void:
	_tool_name = Player.TOOL_NAMES[tool]
	_refresh()


func show_message(text: String) -> void:
	message.text = text
	message_timer.start()


func _refresh() -> void:
	info.text = "Day %d   %s\nTool: %s\nBenih: %d   Padi: %d" % [
		GameState.day, GameState.time_text(), _tool_name,
		GameState.items.get("padi_seed", 0), GameState.items.get("padi", 0),
	]
