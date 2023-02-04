extends Spatial

onready var door_north = $Door_up
onready var door_south = $Door_down
onready var door_east = $Door_right
onready var door_west = $Door_left

onready var navmesh = $NavMesh

onready var connector_north = $NavMesh/Connector_up
onready var connector_south = $NavMesh/Connector_down
onready var connector_east = $NavMesh/Connector_right
onready var connector_west = $NavMesh/Connector_left

onready var door_colshape_north = $Door_up/StaticBody/CollisionShape
onready var door_colshape_south = $Door_down/StaticBody/CollisionShape
onready var door_colshape_east = $Door_right/StaticBody/CollisionShape
onready var door_colshape_west = $Door_left/StaticBody/CollisionShape

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

func get_monster_spawns():
	var spawns = []
	if (connector_north.has_monster_wall()):
		spawns.append(connector_north.get_global_position())
	if (connector_east.has_monster_wall()):
		spawns.append(connector_east.get_global_position())
	if (connector_south.has_monster_wall()):
		spawns.append(connector_south.get_global_position())
	if (connector_west.has_monster_wall()):
		spawns.append(connector_west.get_global_position())
		
	return spawns

func add_exit_door():
	connector_north.add_exit_door()

func open_exit(dir, connection):
	match dir:
		Direction.NORTH:
			self.remove_child(door_north)
			if (!connection and !connector_north.has_exit_door()):
				connector_north.add_monster_wall()
		Direction.SOUTH:
			self.remove_child(door_south)
			if (!connection):
				connector_south.add_monster_wall()
		Direction.EAST:
			self.remove_child(door_east)
			if (!connection):
				connector_east.add_monster_wall()
		Direction.WEST:
			self.remove_child(door_west)
			if (!connection):
				connector_west.add_monster_wall()


func close_exit(dir):
	match dir:
		Direction.NORTH:
			navmesh.remove_child(connector_north)
		Direction.SOUTH:
			navmesh.remove_child(connector_south)
		Direction.EAST:
			navmesh.remove_child(connector_east)
		Direction.WEST:
			navmesh.remove_child(connector_west)
