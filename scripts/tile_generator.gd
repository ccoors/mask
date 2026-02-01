@tool
extends TileMapLayer

class_name TileGenerator

const Energy = preload("res://scenes/items/energy_drink.tscn")
const Health = preload("res://scenes/items/health_item.tscn")
const ObstacleKraken = preload("res://scenes/obstacles/kraken.tscn")
const ObstacleBigfoot = preload("res://scenes/obstacles/bigfoot.tscn")
const ObstacleSalamander = preload("res://scenes/obstacles/bigfoot.tscn")
const Shrink = preload("res://scenes/items/skrinkiedinks.tscn")


@export_tool_button("Recreate Map") var execute_action = gen_map

var _last_pos: Vector2i = Vector2i(-1, -1)

@export var size: Vector2i = Vector2i(20, 20)

var noise = FastNoiseLite.new()

const ITEM_PROBABILITY: Dictionary[String, float] = {
	"energy": .02,
	"health": .01,
	"obstacle": .01,
	"shrink": 0.01
}

const ITEMS: Dictionary[String, Array]  = {
	"energy": [Energy],
	"health":  [Health],
	"obstacle": [ObstacleKraken, ObstacleBigfoot, ObstacleSalamander],
	"shrink": [Shrink]
}

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

func _setup_noise():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.02
	noise.fractal_lacunarity = 2
	noise.fractal_octaves = 2

func _on_player_change(pos: Vector2):
	var tile_pos: Vector2i = local_to_map(pos)
	if _last_pos != tile_pos:
		draw_map(tile_pos)
		_last_pos = tile_pos

func _ready():
	get_node("/root/Main/player").position_changed.connect(_on_player_change)
	_setup_noise()
	gen_map()

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

func _spawn_obstacle(spawn_position: Vector2, tile_type: String):
	var obstacle_res: Resource
	if tile_type == TILE_TYPE_GRASS:
		obstacle_res = ObstacleBigfoot
	elif tile_type == TILE_TYPE_WATER:
		obstacle_res = ObstacleKraken
	else:
		obstacle_res = ObstacleSalamander
	var inst: Node2D = obstacle_res.instantiate()
	inst.position = spawn_position
	add_child(inst)
	return

func _create_items(pos: Vector2i, tile_type: int):
	for item_name in ITEM_PROBABILITY.keys():
		var prob = ITEM_PROBABILITY[item_name]
		if prob > randf():
			var spawn_pos = map_to_local(pos)

			if item_name == "obstacle":
				_spawn_obstacle(spawn_pos, _tile_type_to_string(tile_type))
				return

			var items = ITEMS[item_name]
			var item_idx = min(tile_type, items.size() - 1)
			var item: Resource = items[item_idx]
			var inst: Node2D = item.instantiate()
			inst.position = spawn_pos
			add_child(inst)
			return
	

func draw_map(pos: Vector2i) -> void:
	# create area around position
	var halfsizex = ceil(float(size.x)/2)
	var halfsizey = ceil(float(size.y)/2)
	#  TODO: cleanup tiles that are out-of-size
	for y in range(-halfsizey, halfsizey):
		for x in range(-halfsizex, halfsizex):
			var grid_pos = Vector2i(x + pos.x, y + pos.y)
			if get_cell_tile_data(grid_pos) != null:
				continue
			var val = noise.get_noise_2d(x + pos.x, y + pos.y)
			var tile_type = round(abs(val) * 5);
			if tile_type > 2:
				tile_type = 2
			
			# put items on grid
			_create_items(grid_pos, tile_type)
			
			set_cell(
				grid_pos,
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
