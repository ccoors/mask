extends Node

var move_vector: Vector2 = Vector2.ZERO

var dolphin = preload("res://scenes/items/dolphin_animation.tscn")

func _ready():
	move_vector = Vector2(randf_range(1.0, 2.5), randf_range(1.5, 2.5))
	for x in range(5):
		add_dolphin()

func add_dolphin():
	var d = dolphin.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	d.position = Vector2(randf_range(256, screen_size.x-256), randf_range(256, screen_size.y-256))
#    d.z_index = -10
	add_child(d)

func _on_restart_pressed() -> void:
	GLOBALS.reset()
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _process(_delta: float) -> void:
	%Label.position += move_vector
	var screen_size = get_viewport().get_visible_rect().size
	var rect = %Label.get_global_rect()
	if rect.position.x <= 0:
		move_vector.x = abs(move_vector.x)
	if rect.position.y <= 0:
		move_vector.y = abs(move_vector.y)
	if rect.end.x >= screen_size.x:
		move_vector.x = -abs(move_vector.x)
	if rect.end.y >= screen_size.y:
		move_vector.y = -abs(move_vector.y)
	
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
		_on_restart_pressed()
