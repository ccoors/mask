extends Control

func set_mask(mask: Dictionary):
	%mask_label.text = mask["name"]

func update_health(new_health: int):
	%health_display.set_health(new_health)
