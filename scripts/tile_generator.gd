@tool
extends TileMapLayer

class_name TileGenerator

@export_tool_button("Recreate Map") var execute_action = gen_map

@export var _seed: int = 0:
    set(value):
        _seed = value
        gen_map()

@export_tool_button("Randomize seed", "RandomNumberGenerator") var randomize_seed_action = randomize_seed

func randomize_seed():
    _seed = randi()

@export var size: int = 128:
    set(value):
        if value > 0:
            gen_map()
            size = value

const TILE_TYPE_GRASS: String = "grass"
const TILE_TYPE_LAVA: String = "lava"
const TILE_TYPE_WATER: String = "water"
const TILE_VARIATION_DIST: Array[float] = [0.6, 0.3, 0.1]

const GRASS0_ID: int = 0
const GRASS1_ID: int = 1
const GRASS2_ID: int = 2


func _get_tile_variation(tile_type: String) -> int:
    var variation_dist = randf()
    var variation_index: int
    if variation_dist < TILE_VARIATION_DIST[2]:
        variation_index = 2
    elif variation_dist < TILE_VARIATION_DIST[1]:
        variation_index = 1
    else:
        variation_index = 0
    return [GRASS0_ID, GRASS1_ID, GRASS2_ID][variation_index]


func gen_map() -> void:
    clear()
    var noise = FastNoiseLite.new()
    noise.seed = _seed
    noise.noise_type = FastNoiseLite.TYPE_PERLIN
    noise.frequency = 0.02
    noise.fractal_lacunarity = 2
    noise.fractal_octaves = 2
    var halfsize = ceil(float(size)/2)
    for y in range(-halfsize, halfsize):
        for x in range(-halfsize, halfsize):
            var val = noise.get_noise_2d(x, y)
            var tile_id = round(abs(val) * 5);
            if tile_id > 2:
                tile_id = 2
            set_cell(Vector2i(x, y), _get_tile_variation(TILE_TYPE_GRASS), Vector2i.ZERO)
