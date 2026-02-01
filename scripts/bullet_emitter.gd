extends Node2D

const Bullet = preload("res://scripts/bullet.gd")
const BulletType = preload("res://scripts/bullet_type.gd").BulletType

@export var bullet_scene: PackedScene

@export var bullets_per_second := 30
@export var spread_angle_deg := 360.0
@export var max_bullets := 200
@export var bullet_type: BulletType

var BulletData = {
	BulletType.POLLEN: Bullet.new(
		40.0, 50.0, 90.0,
		preload("res://assets/sprites/pollen.png"),
		Vector2.ZERO,
		3,
		BulletType.POLLEN
	),
	BulletType.BUBBLE: Bullet.new(
		160.0, 12.0, 6.0,
		preload("res://assets/sprites/bubble.png"),
		Vector2.ZERO,
		4,
		BulletType.BUBBLE
	),
	BulletType.SPARK: Bullet.new(
		300.0, 0.0, 10.0,
		preload("res://assets/sprites/spark.png"),
		Vector2.ZERO,
		2,
		BulletType.SPARK
	),
}


var _accumulator := 0.0
var base_rotation := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_accumulator += delta
	var interval := 1.0 / bullets_per_second
	while _accumulator >= interval:
		_accumulator -= interval
		_spawn_bullet()
	
func _spawn_bullet():
	base_rotation += 5.0
	if base_rotation >= 360:
		base_rotation -= 360
	var group_name := "bullet_" + str(bullet_type)
	
#	if bullet_type == BulletType.BUBBLE:
#		print('spawn_bubble')
	
	if get_tree().get_nodes_in_group(group_name).size() >= max_bullets:
		return

	var bullet = bullet_scene.instantiate()
	
	var base_direction := Vector2.RIGHT.rotated(deg_to_rad(base_rotation))
	var spread := deg_to_rad(spread_angle_deg)
	var direction := base_direction.rotated(randf_range(-spread * 0.5, spread * 0.5))
	
	bullet.setup(
		global_position,
		direction,
		BulletData[bullet_type],
	)
	
	get_tree().current_scene.add_child(bullet)
	
