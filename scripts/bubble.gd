extends GPUParticles2D


@export var enabled := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emitting = enabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_enabled(isEnabled: bool):
	enabled = isEnabled
	emitting = isEnabled
