extends ColorRect

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		_on_start_button_button_down()

func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")
