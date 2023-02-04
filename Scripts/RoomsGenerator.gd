extends Spatial

const room_prefab: PackedScene = preload("res:///Prefabs/dungeons/dungeon.tscn")

onready var nav_mesh = $NavMesh

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

const SIZE_X = 24
const SIZE_Z = 24

# 1+2+4+8
# N E S W

var tiles = [
	[[1, 2], [1, 12], [1, 4]],
	[[1, 6], [1, 15], [1, 9]],
	[[1, 1], [1, 3], [1, 8]],
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize(tiles)

func initialize(grid):
	print("Initializing with grid: ", grid)
	var H = grid.size();
	for z in range(H):
		var row = grid[z]
		var W = row.size()
		for x in range(W):
			var tile = row[x]
			var type = tile[0]
			var mask = tile[1]
			if type == 0:
				continue

			var room = room_prefab.instance()
			room.transform.origin.x = x * SIZE_X
			room.transform.origin.z = z * SIZE_Z
			var room_navmesh = room.get_node("NavMesh")

			self.add_child(room)

			var has_north = mask & 1 > 0
			var has_east = mask & 2 > 0
			var has_south = mask & 4 > 0
			var has_west = mask & 8 > 0
			if has_west:
				room.open_exit(room.Direction.WEST)
			else:
				room.close_exit(room.Direction.WEST)
			if has_east:
				room.open_exit(room.Direction.EAST)
			else:
				room.close_exit(room.Direction.EAST)
			if has_north:
				room.open_exit(room.Direction.NORTH)
			else:
				room.close_exit(room.Direction.NORTH)
			if has_south:
				room.open_exit(room.Direction.SOUTH)
			else:
				room.close_exit(room.Direction.SOUTH)
			
		
			room_navmesh.transform.origin.x = x * SIZE_X
			room_navmesh.transform.origin.z = z * SIZE_Z
			room.remove_child(room_navmesh)
			self.nav_mesh.add_child(room_navmesh)
				
	NavigationMeshGenerator.bake(nav_mesh.navmesh, self.nav_mesh)
