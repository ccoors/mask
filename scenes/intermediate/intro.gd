extends ColorRect

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		_on_start_button_button_down()

func _on_start_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
