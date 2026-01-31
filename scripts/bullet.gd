class_name Bullet

var speed: float
var damping: float
var noise_strength: float
var lifetime: float
var texture: Texture2D
var drift: Vector2

func _init(_speed, _damping, _noise_strength, _lifetime, _texture, _drift):
	speed = _speed
	damping = _damping
	noise_strength = _noise_strength
	lifetime = _lifetime
	texture = _texture
	drift = _drift
