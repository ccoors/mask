@tool
extends Node2D
class_name Obstacles

const SteinResource = preload("res://scenes/stein.tscn")

@export var size: int = 128:
    set(value):
        if value > 0:
            size = value
            gen_map()

@export_tool_button("Recreate Map") var execute_action = gen_map

@export var _seed: int = 0:
    set(value):
        _seed = value
        gen_map()

@export var obstacles: Array[Node3D] = []

@export_tool_button("Randomize seed", "RandomNumberGenerator") var randomize_seed_action = randomize_seed

func randomize_seed():
    _seed = randi()

func gen_map():
    for node in get_children():
        node.free()
    # var noise = FastNoiseLite.new()
    # noise.seed = _seed
    # noise.noise_type = FastNoiseLite.TYPE_PERLIN
    # noise.frequency = 0.5
    # noise.fractal_lacunarity = 2
    # noise.fractal_octaves = 3
    var last_x = 0
    var last_y = 0
    var halfsize = ceil(float(size)/2)
    for y in range(-halfsize, halfsize):
        last_y += 1
        if last_y < randi() % 20:
            continue
        last_x = 0
        for x in range(-halfsize, halfsize):
            last_x += 1
            if last_x < randi() % 20:
                last_x = 0
                continue
            var obst = SteinResource.instantiate()
            obst.mask_id = randi() % 3
            obst.position = Vector2(x*200, y*200)
            
            add_child(obst)
    print("done")
