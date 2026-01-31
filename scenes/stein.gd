extends Sprite2D

@export_range(0, 2, 1.0) var mask_id: int = 1

func _ready():
    update_mask_id()
    GLOBALS.mask_changed.connect(mask_changed)

func mask_changed(idx: int):
    if idx == mask_id:
        modulate.a = 0.3
    else:
        modulate.a = 1.0

func update_mask_id():
    var mask = GLOBALS.MASKS[mask_id]
    %StaticBody2D.collision_layer = (1 << mask["collision_mask"])
    modulate = mask["color"].lightened(0.3)
