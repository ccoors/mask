extends Sprite2D

func _ready():
    %katzenfutter/AnimationPlayer.play("futterAction")

func _process(_delta: float) -> void:
    texture = %SubViewport.get_texture()

func _on_detection_body_entered(body: Node2D) -> void:
    if body is CharacterBody2D and body.name == "player":
        body.win()
