class_name Bullet

var speed: float
var noise_strength: float
var lifetime: float
var texture: Texture2D
var drift: Vector2
var collision_mask: int

func _init(_speed, _noise_strength, _lifetime, _texture, _drift , _collision_mask):
	speed = _speed
	noise_strength = _noise_strength
	lifetime = _lifetime
	texture = _texture
	drift = _drift
	collision_mask = _collision_mask
