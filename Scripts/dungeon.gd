extends Spatial

onready var door_north = $Door_up
onready var door_south = $Door_down
onready var door_east = $Door_right
onready var door_west = $Door_left

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

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_K:
			toggle_exit(Direction.NORTH)
		elif event.pressed and event.scancode == KEY_J:
			toggle_exit(Direction.SOUTH)
		elif event.pressed and event.scancode == KEY_H:
			toggle_exit(Direction.WEST)
		elif event.pressed and event.scancode == KEY_L:
			toggle_exit(Direction.EAST)


func toggle_exit(dir):
	match dir:
		Direction.NORTH:
			self.remove_child(door_north)
		Direction.SOUTH:
			self.remove_child(door_south)
		Direction.EAST:
			self.remove_child(door_east)
		Direction.WEST:
			self.remove_child(door_west)
