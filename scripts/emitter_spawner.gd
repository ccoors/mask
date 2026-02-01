extends Node


const PollenEmitter = preload("res://scenes/items/baum.tscn")
const BubbleEmitter = preload("res://scenes/items/dolphin.tscn")
const SparkEmitter = preload("res://scenes/items/dragon.tscn")

var emitter: Array[Node2D]
var spawn_angle: int = 0 

@export var min_radius: int = 1500
@export var max_radius: int = 2000

func _on_player_change(pos: Vector2):
	for node in emitter:
		if pos.distance_to(node.position) > max_radius:
			reposition_spawner(node, pos)

func _ready():
	get_node("/root/Main/player").position_changed.connect(_on_player_change)
	emitter = [
		PollenEmitter.instantiate(),
		BubbleEmitter.instantiate(),
		SparkEmitter.instantiate()
	]
	for node in emitter:
		reposition_spawner(node, Vector2.ZERO)
		add_child(node)

func reposition_spawner(node: Node2D, pos: Vector2):
	var rand_angle = randi() % 6 - 3
	spawn_angle = (spawn_angle + 90 + rand_angle) % 360
	node.position.x = pos.x + cos(deg_to_rad(spawn_angle)) * min_radius
	node.position.y = pos.y + sin(deg_to_rad(spawn_angle)) * min_radius
