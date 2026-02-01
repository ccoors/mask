@tool
extends TileMapLayer

class_name TileGenerator

@export_tool_button("Recreate Map") var execute_action = gen_map

var _last_pos: Vector2i = Vector2i(-1, -1)

func _on_player_change(pos: Vector2):
	var tile_pos: Vector2i = local_to_map(pos)
	if _last_pos != tile_pos:
		draw_map(tile_pos)
		_last_pos = tile_pos

func _ready():
	get_node("/root/Main/player").position_changed.connect(_on_player_change)
	setup_noise()
	gen_map()

func setup_noise():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.02
	noise.fractal_lacunarity = 2
	noise.fractal_octaves = 2

@export var size: Vector2i = Vector2i(20, 20)

var noise = FastNoiseLite.new()

const TILE_TYPE_GRASS: String = "grass"
const TILE_TYPE_LAVA: String = "lava"
const TILE_TYPE_WATER: String = "water"
const TILE_VARIATION_DIST: Array[float] = [0.6, 0.25, 0.15]

const GRASS0_ID: int = 0
const GRASS1_ID: int = 1
const GRASS2_ID: int = 2

const LAVA0_ID: int = 3
const LAVA1_ID: int = 4
const LAVA2_ID: int = 5

const WATER0_ID: int = 6
const WATER1_ID: int = 7
const WATER2_ID: int = 8


func _get_tile_variation(tile_type: String) -> int:
	var variation_dist = randf()
	var variation_index: int
	if variation_dist < TILE_VARIATION_DIST[2]:
		variation_index = 2
	elif variation_dist < TILE_VARIATION_DIST[1]:
		variation_index = 1
	else:
		variation_index = 0
	
	if tile_type == TILE_TYPE_GRASS:
		return [GRASS0_ID, GRASS1_ID, GRASS2_ID][variation_index]
	elif tile_type == TILE_TYPE_LAVA:
		return [LAVA0_ID, LAVA1_ID, LAVA2_ID][variation_index]
	else:
		return [WATER0_ID, WATER1_ID, WATER2_ID][variation_index]

func _tile_type_to_string(type_id: int) -> String:
	if type_id == 0:
		return TILE_TYPE_GRASS
	elif type_id == 1:
		return TILE_TYPE_WATER
	else:
		return TILE_TYPE_LAVA

func draw_map(pos: Vector2i) -> void:
	# create area around position
	var halfsizex = ceil(float(size.x)/2)
	var halfsizey = ceil(float(size.y)/2)
	#  TODO: cleanup tiles that are out-of-size
	for y in range(-halfsizey, halfsizey):
		for x in range(-halfsizex, halfsizex):
			if get_cell_tile_data(Vector2i(x + pos.x, y + pos.y)) != null:
				continue
			var val = noise.get_noise_2d(x + pos.x, y + pos.y)
			var tile_type = round(abs(val) * 5);
			if tile_type > 2:
				tile_type = 2
			set_cell(
				Vector2i(x + pos.x, y + pos.y),
				_get_tile_variation(_tile_type_to_string(tile_type)),
				Vector2i.ZERO)

func gen_map() -> void:
	clear()
	draw_map(Vector2(0, 0))

#	var halfsize = ceil(float(size)/2)
#	print("Generate Tiles")
#	for y in range(-halfsize, halfsize):
#		for x in range(-halfsize, halfsize):
#			var val = noise.get_noise_2d(x, y)
#			var tile_type = round(abs(val) * 5);
#			if tile_type > 2:
#				tile_type = 2
#			set_cell(Vector2i(x, y), _get_tile_variation(_tile_type_to_string(tile_type)), Vector2i.ZERO)
#	print(size*size, " tiles generated")
