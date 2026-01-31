@tool
extends TileMapLayer

@export var size: int = 128:
    set(value):
        if value > 0:
            gen_map()
            size = value

@export var recreate_map: bool = false:
    set(value):
        if value:
            gen_map()
            recreate_map = false

var centerSquareSideLength: int = 10 # in tiles
var wallThickness: int = 100 # in tiles


func gen_map() -> void:
    clear()
    var noise = FastNoiseLite.new()
    noise.seed = randi() % 10000 + 1
    noise.noise_type = FastNoiseLite.TYPE_VALUE
    for y in range(0, size):
        for x in range(0, size):
            var val = noise.get_noise_2d(x, y)
            var tileId = round(abs(val) * 3);
            set_cell(Vector2i(x, y), tileId, Vector2i.ZERO)

func fillCenterSquare(sideLength: int, tileId: int) -> void:
    var halfSideLength: float = 0.5 * sideLength
    for y in range(ceil(-halfSideLength), ceil(halfSideLength)):
        for x in range(ceil(-halfSideLength), ceil(halfSideLength)):
            set_cell(Vector2i(x, y), tileId, Vector2i.ZERO)
