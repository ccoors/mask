extends CharacterBody2D


const SPEED = 300.0
const ROTATION_SPEED = 4;

signal mask_changed(new_mask: Dictionary)

const MASKS = [
    {
        "name": "Foo Mask",
        "input_action": "mask_1",
        "tint_color": Color(0.938, 0.0, 0.62, 0.5),
        "collision_mask": 2,
    },
    {
        "name": "Bar Mask",
        "input_action": "mask_2",
        "tint_color": Color(0.0, 0.65, 0.025, 0.5),
        "collision_mask": 3,
    },
]

func _ready() -> void:
    set_mask(0)
    
func set_mask(idx: int) -> void:
    var mask = MASKS[idx]
    mask_changed.emit(MASKS[idx])
    var set_mask = 0
    print("--")
    for i in range(5):
        if mask["collision_mask"] != i:
            print("Set bit ", i)
            set_mask |= (1 << i)
    collision_mask = set_mask

func _process(delta: float) -> void:
    for n in range(MASKS.size()):
        if Input.is_action_just_pressed(MASKS[n]["input_action"]):
            set_mask(n)

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
