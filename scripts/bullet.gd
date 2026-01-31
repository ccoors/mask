extends Area2D

enum BulletType { POLLEN, BUBBLE, SPARK}

@export var pollen_texture: Texture2D
@export var bubble_texture: Texture2D
@export var spark_texture: Texture2D

var particle_type: BulletType
var direction : Vector2
var damage := 1

# type specific
var damping : float
var drift : Vector2
var noise_strength : float
var lifetime : float
var speed : float


func setup(
	pos: Vector2,
	dir: Vector2,
	type: BulletType
):
	global_position = pos
	direction = dir
	particle_type = type
	_setup_type_specifics()
	
func _setup_type_specifics():
	var sprite := $Sprite2D
	
	match particle_type:
		BulletType.POLLEN:
			damping = 0.98
			noise_strength = 12.0
			drift = Vector2.ZERO
			lifetime = 10.0
			speed = 50.0
			sprite.texture = pollen_texture
		BulletType.BUBBLE:
			damping = 0.92
			noise_strength = 12.0
			drift = Vector2.ZERO
			lifetime = 10.0
			speed = 120.0
			sprite.texture = bubble_texture
		BulletType.SPARK:
			damping = 0.85
			noise_strength = 0.0
			drift = Vector2.ZERO
			lifetime = 10.0
			speed = 350.0
			sprite.texture = spark_texture

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	var velocity := direction * speed
	# ambient drift
	velocity += drift * delta
	
	# air noise
	if noise_strength > 0.0:
		var angle = randf() * TAU
		velocity += Vector2.from_angle(angle) * noise_strength * delta
		
	# friction
	velocity *= damping
	
	position += velocity * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
