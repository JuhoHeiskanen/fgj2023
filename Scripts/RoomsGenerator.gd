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
	[[1, 2], [1, 15]],
]

var monster_spawns = []

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
			
			if z == 0 and x == 0:
				room.add_exit_door()

			var north_open = mask & 1 > 0
			var east_open = mask & 2 > 0
			var south_open = mask & 4 > 0
			var west_open = mask & 8 > 0

			var has_north = z > 0 && grid[z - 1][x][0]
			var has_east = x + 1 < W && grid[z][x + 1][0]
			var has_south = z + 1 < H && grid[z + 1][x][0]
			var has_west = x > 0 && grid[z][x - 1][0]

			if north_open:
				room.open_exit(room.Direction.NORTH, has_north)
			else:
				room.close_exit(room.Direction.NORTH)
			if east_open:
				room.open_exit(room.Direction.EAST, has_east)
			else:
				room.close_exit(room.Direction.EAST)
			if south_open:
				room.open_exit(room.Direction.SOUTH, has_south)
			else:
				room.close_exit(room.Direction.SOUTH)
			if west_open:
				room.open_exit(room.Direction.WEST, has_west)
			else:
				room.close_exit(room.Direction.WEST)
			
			monster_spawns.append_array(room.get_monster_spawns())
		
			room_navmesh.transform.origin.x = x * SIZE_X
			room_navmesh.transform.origin.z = z * SIZE_Z
			room.remove_child(room_navmesh)
			self.nav_mesh.add_child(room_navmesh)
				
	NavigationMeshGenerator.bake(nav_mesh.navmesh, self.nav_mesh)

func get_monster_spawns():
	return monster_spawns
