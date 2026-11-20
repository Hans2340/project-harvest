class_name DevToolsUI
extends Control
## Developer tools window for testing, toggled with F1: pick the player character, toggle rain,
## and switch fullscreen. Only in debug builds (the editor and debug exports).

const KEY := KEY_F1

var _panel := VBoxContainer.new()
var _char_buttons := {}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

	var frame := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	frame.position = Vector2(470, 70)
	frame.size = Vector2(164, 150)
	add_child(frame)
	_panel.position = frame.position + Vector2(10, 8)
	_panel.size = frame.size - Vector2(20, 16)
	_panel.add_theme_constant_override("separation", 3)
	add_child(_panel)

	_panel.add_child(UiSkin.label("Dev Tools  [F1]", 10, UiSkin.TEXT_GOLD))
	_panel.add_child(UiSkin.label("Watak", 8))
	for id in GameState.CHARACTERS:
		var b := _button(GameState.CHARACTERS[id], func(): GameState.set_character(id))
		_char_buttons[id] = b
	_panel.add_child(UiSkin.label("Lain-lain", 8))
	_button("Hujan / cerah  [F7]", func(): GameState.set_weather("cerah" if GameState.is_raining() else "hujan"))
	_button("Fullscreen  [F11]", GameState.toggle_fullscreen)

	GameState.character_changed.connect(func(_id): _refresh())
	_refresh()


func _button(text: String, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE   # keep WASD/E for the game
	b.add_theme_font_size_override("font_size", 8)
	b.custom_minimum_size = Vector2(0, 13)
	b.pressed.connect(action)
	_panel.add_child(b)
	return b


func _refresh() -> void:
	for id in _char_buttons:
		var b: Button = _char_buttons[id]
		var on: bool = id == GameState.character
		b.text = ("> " if on else "") + GameState.CHARACTERS[id]
		b.add_theme_color_override("font_color", UiSkin.TEXT_GOLD if on else UiSkin.TEXT)


func toggle() -> void:
	visible = not visible
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY:
		toggle()
		get_viewport().set_input_as_handled()
