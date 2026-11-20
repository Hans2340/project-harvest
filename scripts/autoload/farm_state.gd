extends Node
## Persistent farm plot data (autoloaded as `FarmState`).
## Lives outside the farm scene so plots survive zone changes, and crops grow
## overnight even when the player is elsewhere.

signal plots_changed

const CROPS := {
	"padi": preload("res://resources/crops/padi.tres"),
}

## Vector2i -> { "crop": String ("" = empty), "stage": int, "growth": int, "watered": bool, "irrigated": bool }
## Plot cells are kampung tile cells (48 px). Irrigated plots (sawah) grow every night without watering.
var plots := {}


func _ready() -> void:
	GameState.day_changed.connect(_on_day_changed)


func crop_data(id: String) -> CropData:
	return CROPS.get(id)


func till(cell: Vector2i, irrigated := false) -> void:
	plots[cell] = {"crop": "", "stage": 0, "growth": 0, "watered": false, "irrigated": irrigated}
	plots_changed.emit()


func plant(cell: Vector2i, crop_id: String) -> void:
	plots[cell].crop = crop_id
	plots[cell].stage = 0
	plots[cell].growth = 0
	plots_changed.emit()


func water(cell: Vector2i) -> void:
	plots[cell].watered = true
	plots_changed.emit()


## Returns true if the plot is ripe; clears it.
func harvest(cell: Vector2i) -> bool:
	var plot: Dictionary = plots.get(cell, {})
	var crop := crop_data(plot.get("crop", ""))
	if crop == null or plot.stage < crop.stage_count - 1:
		return false
	plot.crop = ""
	plot.stage = 0
	plot.growth = 0
	plots_changed.emit()
	return true


func is_ripe(cell: Vector2i) -> bool:
	var plot: Dictionary = plots.get(cell, {})
	var crop := crop_data(plot.get("crop", ""))
	return crop != null and plot.stage >= crop.stage_count - 1


func _on_day_changed(_day: int) -> void:
	for cell in plots:
		var plot: Dictionary = plots[cell]
		var crop := crop_data(plot.crop)
		if crop != null and (plot.watered or plot.get("irrigated", false)) and plot.stage < crop.stage_count - 1:
			plot.growth += 1
			if plot.growth >= crop.days_per_stage:
				plot.growth = 0
				plot.stage += 1
		plot.watered = false
	plots_changed.emit()
