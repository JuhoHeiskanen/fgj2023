extends TileMap

const RESOURCE_NONE = 1
const RESOURCE_CALC = 2
const RESOURCE_IRON = 3
const RESOURCE_WATER = 4

const GENERATION_RANGE_X = 10
const GENERATION_RANGE_Y = 15

var RES_TEXTURE_WATER = preload("res://Resources/3d_sprites/water.png")
var RES_TEXTURE_IRON = preload("res://Resources/3d_sprites/iron.png")
var RES_TEXTURE_CALC = preload("res://Resources/3d_sprites/calcium.png")

var resource_map = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Initializing Tilemap")
	randomize()

	# Randomly generate resources
	for _y in range(0, GENERATION_RANGE_Y):
		var row = []
		for _x in range(0, GENERATION_RANGE_X):
			var res = roll_resource()
			row.append(res if _y > 1 else RESOURCE_NONE)
		resource_map.append(row)

	spawn_resource_sprites()

func spawn_resource_sprites():
	for y in resource_map.size():
		var row = resource_map[y]
		for x in row.size():
			var res = row[x]
			if res == RESOURCE_NONE:
				continue

			var sprite = Sprite.new()
			sprite.scale = Vector2(0.7, 0.7)
			match res:
				RESOURCE_WATER:
					sprite.texture = RES_TEXTURE_WATER
				RESOURCE_CALC:
					sprite.texture = RES_TEXTURE_CALC
				RESOURCE_IRON:
					sprite.texture = RES_TEXTURE_IRON

			var cell_pos = map_to_world(Vector2(x, y))
			sprite.position = cell_pos
			sprite.centered = false
			add_child(sprite)


func roll_resource():
	var val = randf()

	if val < 0.1:
		return RESOURCE_CALC
	elif val < 0.2:
		return RESOURCE_IRON
	elif val < 0.3:
		return RESOURCE_WATER
	else:
		return RESOURCE_NONE

func serialize_tilemap():
	var cellRect = get_used_rect()
	var start: Vector2 = cellRect.position
	var end: Vector2 = cellRect.end

	var output = []

	for y in range(start.y, end.y):
		var row = []
		for x in range(start.x, end.x):
			var cell = get_cell(x, y)
			var cell_type = int(cell / 4) if cell != -1 else 0
			var rotation = cell % 4 if cell != -1 else 0
			var initial_bitmask = [Globals.BITMASK_I, Globals.BITMASK_L, Globals.BITMASK_T, Globals.BITMASK_X][cell_type]

			var bitmask = ((initial_bitmask << rotation) | (initial_bitmask >> (4 - rotation))) & 0b1111

			var tile_resource = resource_map[y][x]
			if cell == -1:
				tile_resource = 0
			var data = [tile_resource, bitmask]
			row.append(data)
		output.append(row)


	print(output)
	return [output, start.x, start.y]
