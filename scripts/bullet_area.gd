extends Area2D

const Bullet = preload("res://scripts/bullet.gd")



var bullet: Bullet
var direction : Vector2
var damage := 1

func setup(
	pos: Vector2,
	dir: Vector2,
	bullet_data: Bullet
):
	global_position = pos
	direction = dir
	bullet = bullet_data
	$Sprite2D.texture = bullet.texture
	collision_layer = (1 << bullet.collision_mask)
	add_to_group("bullets")
	add_to_group("bullet_"+str(bullet.type))

func _ready():
	await get_tree().create_timer(bullet.lifetime).timeout
	queue_free()

func _process(delta):
	var velocity := direction * bullet.speed
	
	# ambient drift
	velocity += bullet.drift * delta
	
	# air noise
	if bullet.noise_strength > 0.0:
		var angle = randf() * TAU
		velocity += Vector2.from_angle(angle) * bullet.noise_strength
	
	position += velocity * delta

func _on_body_entered(body):
	if body.has_method("hit") and body.collision_mask & collision_layer:
		body.hit()
		queue_free()
