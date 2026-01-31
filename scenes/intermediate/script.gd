extends Node


func _on_restart_pressed() -> void:
    GLOBALS.reset()
    get_tree().change_scene_to_file("res://scenes/main_scene.tscn")


func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
        _on_restart_pressed()
