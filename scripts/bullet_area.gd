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
	print('collision with', body)
	print(collision_mask , body.collision_layer)
	if body.has_method("hit"):
		body.hit()
	queue_free()
