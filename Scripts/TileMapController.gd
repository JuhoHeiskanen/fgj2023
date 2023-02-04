extends TileMap

const initial_tiles_x = 10
const initial_tiles_y = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	# print("Initializing Tilemap")
	# for x in range(0, initial_tiles_x):
	# 	for y in range(0, initial_tiles_y):
	# 		self.set_cellv(Vector2(x,y), 0)


func _input(event: InputEvent):
	if event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
		serialize_tilemap()


const FLAG_NORTH = 1
const FLAG_EAST = 2
const FLAG_SOUTH = 4
const FLAG_WEST = 8

const BITMASK_I = FLAG_WEST | FLAG_EAST
const BITMASK_L = FLAG_WEST | FLAG_SOUTH
const BITMASK_T = FLAG_WEST | FLAG_EAST | FLAG_SOUTH
const BITMASK_X = FLAG_WEST | FLAG_EAST | FLAG_SOUTH | FLAG_NORTH

func serialize_tilemap():
	var cellRect = get_used_rect()
	var start: Vector2 = cellRect.position
	var end: Vector2 = cellRect.end

	var output = []

	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			var cell = get_cell(x, y)
			var cell_type = int(cell / 4) if cell != -1 else 0
			var rotation = cell % 4 if cell != -1 else 0
			var initial_bitmask = [BITMASK_I, BITMASK_L, BITMASK_T, BITMASK_X][cell_type]

			var bitmask = ((initial_bitmask << rotation) | (initial_bitmask >> (4 - rotation))) & 0b1111
			var data = [cell_type , bitmask]
			output.append(data)

	print(output)
