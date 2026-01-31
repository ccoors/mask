class_name Bullet

const BulletType = preload("res://scripts/bullet_type.gd").BulletType

var speed: float
var noise_strength: float
var lifetime: float
var texture: Texture2D
var drift: Vector2
var collision_mask: int
var type: BulletType

func _init(_speed, _noise_strength, _lifetime, _texture, _drift , _collision_mask, _type):
	speed = _speed
	noise_strength = _noise_strength
	lifetime = _lifetime
	texture = _texture
	drift = _drift
	collision_mask = _collision_mask
	type = _type
