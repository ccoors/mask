extends Node2D

func _ready():
    GLOBALS.mask_changed.connect(_on_mask_changed)
    _on_mask_changed(GLOBALS.mask_idx)

func _on_mask_changed(new_mask: int) -> void:
    var mask = GLOBALS.MASKS[new_mask]
    %UI.set_mask(mask)
    %ColorRect.material.set_shader_parameter(
        "vignette_color",
        mask["color"],
    )
