extends CharacterBody2D

signal health_changed(new_health: int)
signal position_changed(new_position: Vector2)

var speed = 500.0
const ROTATION_SPEED = 5;

@export var health: int = 10

@onready var speed_timer: Timer = $SpeedTimer
@onready var shrink_timer: Timer = $ShrinkTimer
@onready var background_music_player: AudioStreamPlayer = get_node("/root/Main/ElektrischeHintergrundmusik")

func _ready() -> void:
	set_mask(0)
	health_changed.emit(health)
	speed_timer.timeout.connect(speed_down)
	shrink_timer.timeout.connect(grow)

func hit():
	quack()
	health -= 1
	health = max(0, health)
	if health == 0:
		call_deferred("exit_loose")
		return
	health_changed.emit(health)
	
func quack():
	var audio_stream_player := $AudioStreamPlayer2D
	audio_stream_player.max_polyphony = health
	audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player.play()

func heal():
	health += 1
	health_changed.emit(health)
	
func speed_up():
	speed = 750
	background_music_player.pitch_scale = 1.5
	%AnimatedSprite2D.speed_scale = 2.0
	speed_timer.start()
	
func speed_down():
	speed = 500
	background_music_player.pitch_scale = 1.0
	%AnimatedSprite2D.speed_scale = 1.0
	
func shrink():
	scale = Vector2(0.5, 0.5)
	shrink_timer.start()
	
func grow():
	scale = Vector2(1.0, 1.0)

func exit_win():
	if not is_inside_tree():
		return
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://scenes/intermediate/win_screen.tscn")

func exit_loose():
	if not is_inside_tree():
		return
	var tree = get_tree()
	if tree:
		tree.change_scene_to_file("res://scenes/intermediate/loose_screen.tscn")

func win():
	call_deferred("exit_win")

func set_mask(idx: int) -> void:
	var mask = GLOBALS.MASKS[idx]
	GLOBALS.change_mask(idx)
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
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	)
	if direction.y:
		velocity = Vector2(
			-direction.y * speed * sin(rotation),
			direction.y * speed * cos(rotation),
		)
		%AnimatedSprite2D.play("run")
	else:
		velocity = Vector2.ZERO
		%AnimatedSprite2D.play("idle")
	if direction.x:
		rotation += ROTATION_SPEED * delta * direction.x

	move_and_slide()
	position_changed.emit(global_position)
