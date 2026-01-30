extends CharacterBody2D


const SPEED = 30000.0


func _physics_process(delta: float) -> void:
    var direction := Input.get_vector("left", "right", "up", "down")
    if direction:
        direction = direction.limit_length(1.0)
        velocity = direction * delta * SPEED
    else:
        velocity = Vector2.ZERO

    move_and_slide()
