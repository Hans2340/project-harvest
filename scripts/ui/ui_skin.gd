class_name UiSkin
extends RefCounted
## Pieces of the Dark Ages UI pack (by Hypnobius), cut from its 32 px tilesheet.
## Use these instead of hard-coding regions in every UI script.

const SHEET := preload("res://assets/ui/dark_ages/ui_tilesheet.png")

const FRAME_ORNATE := Rect2(0, 0, 96, 96)       ## gold/blue window frame (9-slice, margin 32)
const PARCHMENT := Rect2(96, 0, 96, 96)
const PANEL_DARK := Rect2(210, 18, 60, 60)      ## dark inset panel (9-slice, margin 12)
const BANNER_GOLD := Rect2(128, 96, 64, 28)     ## title banner with crown (stretch sideways, margin 20)
const SLOT := Rect2(192, 96, 32, 32)
const SLOT_ALT := Rect2(224, 96, 32, 32)
const SLOT_SELECTED := Rect2(256, 96, 32, 32)
const CLOSE := Rect2(72, 232, 16, 16)
const BAR_FRAME := Rect2(192, 128, 96, 32)
const BAR_RED := Rect2(192, 160, 96, 32)
const BAR_BLUE := Rect2(288, 128, 96, 32)
const BAR_GREEN := Rect2(288, 160, 96, 32)

const TEXT := Color(0.95, 0.9, 0.78)
const TEXT_GOLD := Color(0.86, 0.77, 0.49)   ## pack palette "Honey Gold" #dcc47c
const OUTLINE := Color(0.08, 0.07, 0.06)


static func tex(region: Rect2) -> AtlasTexture:
	var t := AtlasTexture.new()
	t.atlas = SHEET
	t.region = region
	return t


## 9-slice from the sheet. `margin_v` < 0 means same as `margin` (use 0 to stretch only sideways).
static func nine(region: Rect2, margin: int, margin_v: int = -1) -> NinePatchRect:
	var mv := margin if margin_v < 0 else margin_v
	var n := NinePatchRect.new()
	n.texture = SHEET
	n.region_rect = region
	n.patch_margin_left = margin
	n.patch_margin_top = mv
	n.patch_margin_right = margin
	n.patch_margin_bottom = mv
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return n


static func label(text: String, size: int = 10, color := TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", OUTLINE)
	l.add_theme_constant_override("outline_size", 3)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l
