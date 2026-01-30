extends Node2D

func _on_player_mask_changed(new_mask: int) -> void:
    var mask = GLOBALS.MASKS[new_mask]
    %UI.set_mask(mask)
    %ColorRect.material.set_shader_parameter("vignette_color", mask["tint_color"])
