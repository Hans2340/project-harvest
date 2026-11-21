class_name DevToolsUI
extends Control
## Developer tools window for testing, toggled with F1: pick the player character, toggle rain,
## switch fullscreen and the clock style. Only in debug builds (the editor and debug exports).

const KEY := KEY_F1

var _panel := VBoxContainer.new()
var _char_buttons := {}
var _clock_button: Button


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

	# Pinned under the clock at the top-right corner, whatever the screen width.
	var box := Control.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	box.offset_left = -170
	box.offset_right = -6
	box.offset_top = 90
	box.offset_bottom = 256
	add_child(box)
	var frame := UiSkin.nine(UiSkin.PANEL_DARK, 12)
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	box.add_child(frame)
	_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_panel.offset_left = 10
	_panel.offset_top = 8
	_panel.offset_right = -10
	_panel.offset_bottom = -8
	_panel.add_theme_constant_override("separation", 3)
	box.add_child(_panel)

	_panel.add_child(UiSkin.label("Dev Tools  [F1]", 10, UiSkin.TEXT_GOLD))
	_panel.add_child(UiSkin.label("Watak", 8))
	for id in GameState.CHARACTERS:
		var b := _button(GameState.CHARACTERS[id], func(): GameState.set_character(id))
		_char_buttons[id] = b
	_panel.add_child(UiSkin.label("Lain-lain", 8))
	_button("Hujan / cerah  [F7]", func(): GameState.set_weather("cerah" if GameState.is_raining() else "hujan"))
	_button("Fullscreen  [F11]", GameState.toggle_fullscreen)
	_clock_button = _button("", func():
		var styles := GameState.CLOCK_STYLES.keys()
		GameState.set_clock_style(styles[(styles.find(GameState.clock_style) + 1) % styles.size()]))

	GameState.character_changed.connect(func(_id): _refresh())
	GameState.clock_style_changed.connect(func(_s): _refresh())
	_refresh()


func _button(text: String, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE   # keep WASD/E for the game
	b.add_theme_font_size_override("font_size", UiSkin.FONT_SIZE)
	b.custom_minimum_size = Vector2(0, 13)
	b.pressed.connect(action)
	_panel.add_child(b)
	return b


func _refresh() -> void:
	_clock_button.text = GameState.CLOCK_STYLES[GameState.clock_style] + "  (tukar)"
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
