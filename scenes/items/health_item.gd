extends Sprite2D

var used: bool = false

func _on_body_entered(body: Node2D) -> void:
    if used:
        return
    if body is CharacterBody2D and body.name == "player":
        body.heal()
        used = true
        var tween = get_tree().create_tween()
        tween.tween_property(self, "modulate", Color.TRANSPARENT, .4)
        tween.tween_callback(queue_free)
