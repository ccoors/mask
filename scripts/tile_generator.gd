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
            var tileId = round(abs(val) * 5);
            if tileId > 2:
                tileId = 2
            set_cell(Vector2i(x, y), tileId, Vector2i.ZERO)
