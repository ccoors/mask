extends Node

var move_vector: Vector2 = Vector2.ZERO

var dolphin = preload("res://scenes/items/dolphin_animation.tscn")

var last_duplication = 0.0
var accumulator = 0.0

func maybe_duplicate(delta: float) -> void:
	accumulator += delta
	if accumulator >= 0.04:
		var dupl = %Label.duplicate()
		dupl.z_index = 2
		dupl.begin_bulk_theme_override()
		dupl.add_theme_constant_override("outline_size", 15)
		dupl.add_theme_color_override("font_color", Color.TRANSPARENT)
		dupl.add_theme_color_override("font_outline_color", Color.DEEP_PINK)
		dupl.end_bulk_theme_override()
		add_child(dupl)
		var t = get_tree().create_tween()
		t.tween_property(dupl, "modulate", Color.TRANSPARENT, 1.0)
		t.tween_callback(dupl.queue_free)
		accumulator = 0

func _ready():
	move_vector = Vector2(randf_range(1.5, 3.5), randf_range(1.5, 3.5))
	for x in range(5):
		add_dolphin()

func add_dolphin() -> void:
	var d = dolphin.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	d.position = Vector2(randf_range(256, screen_size.x-256), randf_range(256, screen_size.y-256))
	add_child(d)

func _on_restart_pressed() -> void:
	GLOBALS.reset()
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()

func _process(delta: float) -> void:
	maybe_duplicate(delta)
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
