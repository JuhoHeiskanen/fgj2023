extends Spatial

onready var conn_north = $Connector_up;
onready var conn_south = $Connector_down;
onready var conn_east = $Connector_right;
onready var conn_west = $Connector_left;

onready var door_north = $Door_up;
onready var door_south = $Door_down;
onready var door_east = $Door_right;
onready var door_west = $Door_left;

onready var door_colshape_north = $Door_up/StaticBody/CollisionShape;
onready var door_colshape_south = $Door_down/StaticBody/CollisionShape;
onready var door_colshape_east = $Door_right/StaticBody/CollisionShape;
onready var door_colshape_west = $Door_left/StaticBody/CollisionShape;

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
			conn_north.visible = !conn_north.visible
			door_north.visible = !door_north.visible
			door_colshape_north.disabled = !door_north.visible
		Direction.SOUTH:
			conn_south.visible = !conn_south.visible
			door_south.visible = !door_south.visible
			door_colshape_south.disabled = !door_south.visible
		Direction.EAST:
			conn_east.visible = !conn_east.visible
			door_east.visible = !door_east.visible
			door_colshape_east.disabled = !door_east.visible
		Direction.WEST:
			conn_west.visible = !conn_west.visible
			door_west.visible = !door_west.visible
			door_colshape_west.disabled = !door_west.visible
