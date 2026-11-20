class_name CropData
extends Resource
## Definition of a crop type. Create one .tres per crop in resources/crops/.

@export var id: String = ""
@export var display_name: String = ""
@export var seed_item: String = ""
@export var harvest_item: String = ""
@export var harvest_amount: int = 1
## Sprite sheet with one frame per growth stage (left to right).
@export var texture: Texture2D
@export var stage_count: int = 4
## Watered days needed to move from one stage to the next.
@export var days_per_stage: int = 1
