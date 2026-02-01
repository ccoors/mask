extends Sprite2D

var used: bool = false

const RANDOM_COLORS = [
	Color.AQUA,
	Color.AQUAMARINE,
	Color.BLUE,
	Color.CHARTREUSE,
	Color.CYAN,
	Color.DARK_CYAN,
	Color.GOLD,
	Color.GREEN_YELLOW,
	Color.MEDIUM_VIOLET_RED
]

var tween: Tween = null

func _ready() -> void:
	set_random_color()

func _on_body_entered(body: Node2D) -> void:
	if used:
		return
	if body is CharacterBody2D and body.name == "player":
		body.speed_up()
		used = true
		if tween and tween.is_running():
			tween.kill()
		var destroy_tween = get_tree().create_tween()
		destroy_tween.tween_property(self, "modulate", Color.TRANSPARENT, .4)
		destroy_tween.tween_callback(queue_free)

func set_random_color():
	if used:
		return
	if tween and tween.is_running():
		tween.kill()
	tween = get_tree().create_tween()
	var col = RANDOM_COLORS[randi_range(0, RANDOM_COLORS.size()-1)]
	tween.tween_property(self, "modulate", col, 0.15)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	set_random_color()
	match randi_range(0, 15):
		1:
			%AnimationPlayer.play("idle_rotate")
		2:
			%AnimationPlayer.play("idle_scale")
		_:
			%AnimationPlayer.play("idle")
