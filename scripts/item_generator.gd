@tool
extends Node2D
class_name ItemGenerator

const PollenEmitter = preload("res://scenes/items/baum.tscn")
const BubbleEmitter = preload("res://scenes/items/dolphin.tscn")
const SparkEmitter = preload("res://scenes/items/dragon.tscn")

const SteinResource = preload("res://scenes/stein.tscn")

const Emitter = [PollenEmitter, SparkEmitter, BubbleEmitter]

@export var size: int = 128

@export var emitter_spawn: int = 20

@export_tool_button("Recreate Map") var execute_action = gen_map

@export var _seed: int = 0

@export var perlin_threshold: float = 0.75

@export_tool_button("Randomize seed", "RandomNumberGenerator") var randomize_seed_action = randomize_seed

func _ready():
	randomize_seed()
	gen_map()

func randomize_seed():
	_seed = randi()

func gen_map():
	for node in get_children():
		node.free()
	print("Recreate items...")
	var noise = FastNoiseLite.new()
	noise.seed = _seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.5
	noise.fractal_lacunarity = 2
	noise.fractal_octaves = 3
	var halfsize = ceil(float(size)/2)
	var num = 0
	var num_obst = 0
	var num_emitter = 0
	for y in range(-halfsize, halfsize):
		for x in range(-halfsize, halfsize):
			num += 1
			if (noise.get_noise_2d(x, y) + 0.5) < perlin_threshold:
				continue
			var item: Node2D
			if num % emitter_spawn == 0:
				item = Emitter[randi() % Emitter.size()].instantiate()
				num_emitter += 1
			else:
				var obst = SteinResource.instantiate()
				obst.mask_id = randi() % 3
				item = obst
				num_obst += 1
			item.position = Vector2(
				x * floor(GLOBALS.TILE_WIDTH * 2),
				y * floor(GLOBALS.TILE_WIDTH * 2))
			add_child(item)
	print("Item generation done - obstacles: ", num_obst, " emitter: ", num_emitter)
