extends CharacterBody2D


const SPEED = 300.0
const ROTATION_SPEED = 4;

signal mask_changed(new_mask: int)

func _ready() -> void:
	set_mask(0)
	
func set_mask(idx: int) -> void:
	var mask = GLOBALS.MASKS[idx]
	mask_changed.emit(idx)
	var set_cmask = 0
	for i in range(5):
		if mask["collision_mask"] != i:
			set_cmask |= (1 << i)
	collision_mask = set_cmask

func _process(_delta: float) -> void:
	for n in range(GLOBALS.MASKS.size()):
		if Input.is_action_just_pressed(GLOBALS.MASKS[n]["input_action"]):
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
