extends Sprite2D

@export_range(0, 2, 1.0) var mask_id: int = 1

func _ready():
    update_mask_id()

func update_mask_id():
    var mask = GLOBALS.MASKS[mask_id]
    %StaticBody2D.collision_layer = (1 << mask["collision_mask"])
    modulate = mask["color"]
