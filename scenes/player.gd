extends CharacterBody2D

signal health_changed(new_health: int)

const SPEED = 500.0
const ROTATION_SPEED = 5;

@export var health: int = 10

func _ready() -> void:
	set_mask(0)
	health_changed.emit(health)

func hit():
	health -= 1
	health = max(0, health)
	if health == 0:
		# TODO: Die
		pass
	health_changed.emit(health)

func heal():
	health += 1
	health_changed.emit(health)

func win():
    # TODO: Win
    pass

func set_mask(idx: int) -> void:
	var mask = GLOBALS.MASKS[idx]
	GLOBALS.change_mask(idx)
	var set_cmask = 0
	for i in range(5):
		if mask["collision_mask"] != i:
			set_cmask |= (1 << i)
	collision_mask = set_cmask
	hit()

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
		%AnimatedSprite2D.play("run")
	else:
		velocity = Vector2.ZERO
		%AnimatedSprite2D.play("idle")
	if direction.x:
		rotation += ROTATION_SPEED * delta * direction.x

	move_and_slide()
