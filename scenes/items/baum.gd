extends Sprite2D


func _process(_delta: float) -> void:
    texture = %SubViewport.get_texture()
