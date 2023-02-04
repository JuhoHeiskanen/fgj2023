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
		var data = serialize_tilemap()


		var root = get_tree().get_root()
		var current_scene = root.get_child(root.get_child_count() - 1)
		current_scene.queue_free()

		var scene = load("res://MainScene3D.tscn")
		var instance = scene.instance();
		print("Loaded scene: ", instance)

		instance.get_node("RoomsGenerator").tiles = data
		
		root.add_child(instance)
		get_tree().set_current_scene(instance)

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
			var data = [1 , bitmask]
			row.append(data)
		output.append(row)

	print(output)
	return output
