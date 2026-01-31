extends Node2D

@export var bullet_scene: PackedScene

@export var sparks_per_second := 30.0
@export var spark_speed := 350.0
@export var spark_lifetime := 0.4

@export var spread_angle_deg := 60.0
@export var max_sparks := 200

var _accumulator := 0.0

const BulletScript = preload("res://scripts/bullet.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_accumulator += delta
	var interval := 1.0 / sparks_per_second
	while _accumulator >= interval:
		_accumulator -= interval
		_spawn_spark()
	
func _spawn_spark():
	if get_tree().get_node_count() > max_sparks:
		return
		
	var bullet = bullet_scene.instantiate()
	
	var base_direction := Vector2.RIGHT.rotated(global_rotation)
	var spread := deg_to_rad(spread_angle_deg)
	var direction := base_direction.rotated(randf_range(-spread * 0.5, spread * 0.5))
	
	bullet.setup(
		global_position,
		direction * spark_speed,
		bullet.BulletType.SPARK,
	)
	
