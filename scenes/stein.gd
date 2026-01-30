extends Sprite2D

@export var color: Color = Color.WHITE:
    get:
        return modulate
    set(value):
        modulate = value

@export var layer: int = 2

func _ready():
    %StaticBody2D.collision_layer = (1 << layer)
