@tool
extends Node2D
class_name ItemGenerator

const SteinResource = preload("res://scenes/stein.tscn")

@export var size: int = 128:
    set(value):
        if value > 0:
            size = value
            gen_map()
            
@export var min_dist: int = 10:
    set(value):
        if value > 0:
            min_dist = value
            gen_map()

@export_tool_button("Recreate Map") var execute_action = gen_map

@export var _seed: int = 0:
    set(value):
        _seed = value
        gen_map()

@export var perlin_threshold: float = 0.75:
    set(value):
        perlin_threshold = value
        gen_map()

@export var obstacles: Array[Node3D] = []

@export_tool_button("Randomize seed", "RandomNumberGenerator") var randomize_seed_action = randomize_seed

func randomize_seed():
    _seed = randi()

func is_close(lst: Array[Vector2i], pos: Vector2i) -> bool:
    for itm in lst:
        if itm.distance_to(pos) < min_dist:
            return true
    return false

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
    var last: Array[Vector2i] = []
    var halfsize = ceil(float(size)/2)
    for y in range(-halfsize, halfsize):
        for x in range(-halfsize, halfsize):
            if (noise.get_noise_2d(x, y) + 0.5) < perlin_threshold:
                continue
            if is_close(last, Vector2i(x, y)):
                continue
            last.append(Vector2i(x, y))
            var obst = SteinResource.instantiate()
            obst.mask_id = randi() % 3
            obst.position = Vector2(x*50, y*50)
            
            add_child(obst)
    print("Item generation done")
