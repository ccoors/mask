extends CharacterBody2D


const SPEED = 300.0
const ROTATION_SPEED = 4;

signal mask_changed(new_mask: Dictionary)

const MASKS = [
    {
        "name": "Foo Mask",
        "input_action": "mask_1",
        "tint_color": Color(0.938, 0.0, 0.62, 0.5),
    },
    {
        "name": "Bar Mask",
        "input_action": "mask_2",
        "tint_color": Color(0.0, 0.65, 0.025, 0.5),
    },
]

func _ready() -> void:
    mask_changed.emit(MASKS[0])

func _process(delta: float) -> void:
    for mask in MASKS:
        if Input.is_action_just_pressed(mask["input_action"]):
            mask_changed.emit(mask)

func _physics_process(delta: float) -> void:
    var direction := Input.get_vector("left", "right", "up", "down")
    if direction.y:
        velocity = Vector2(
            -direction.y * SPEED * sin(rotation),
            direction.y * SPEED * cos(rotation),
        )
    else:
        velocity = Vector2.ZERO
    if direction.x:
        rotation += ROTATION_SPEED * delta * direction.x

    move_and_slide()
