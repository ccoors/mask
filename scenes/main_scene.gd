extends Node2D

func _ready() -> void:
    pass


func _process(delta: float) -> void:
    pass


func _on_player_mask_changed(new_mask: Dictionary) -> void:
    %UI.set_mask(new_mask)
    %ColorRect.material.set_shader_parameter("vignette_color", new_mask["tint_color"])
    
