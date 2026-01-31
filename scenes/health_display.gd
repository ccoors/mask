extends TextureRect

var health: int = 0
var tween: Tween = null

func set_health(new_health: int):
    if health == new_health:
        return
    health = max(0, new_health)
    if tween and tween.is_running():
        tween.kill()
    tween = get_tree().create_tween()
    tween.tween_property(
        self,
        "custom_minimum_size",
        Vector2(32 * health, 32),
        .5
    )
