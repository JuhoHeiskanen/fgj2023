extends Node2D

enum TILE {I, L, T, X}
const TILE_INDEX_OFFSET = 4 
enum ROTATION {ROT_0, ROT_90, ROT_180, ROT_270}

var active_tile = TILE.I
var tile_rotation = ROTATION.ROT_0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:	
		handle_button_press(event)

	if event is InputEventMouseButton:
		handle_left_click(event)
		handle_mouse_scroll(event)

func handle_button_press(event: InputEventKey):
	# handle key presses
	match event.scancode:
		KEY_R:
			rotate_tile()
			
func handle_mouse_scroll(event: InputEventMouseButton):
	var tilemap = $TileMap
	if event.pressed && event.button_index == BUTTON_WHEEL_DOWN:
		tilemap.position.y -= 16;
	if event.pressed && event.button_index == BUTTON_WHEEL_UP:
		tilemap.position.y = min(tilemap.position.y + 16, 0);

func handle_left_click(event: InputEventMouseButton):
	if event.pressed && event.button_index == BUTTON_LEFT:
		var pos = event.position
		#print("Mouse Click at: ", pos)
		var tilemap = $TileMap
		var local_pos = tilemap.to_local(pos)
		#print("Local pos: ", local_pos)
		var tile_pos = tilemap.world_to_map(local_pos)
		#print("Tile pos: ", tile_pos)
		#print("Setting tile to: ", active_tile)
		tilemap.set_cellv(tile_pos, active_tile + tile_rotation)

func rotate_tile():
	tile_rotation = (tile_rotation + 1)  % (ROTATION.ROT_270 + 1)

func _on_ButtonI_pressed():
	print("Pressed I tile button")
	active_tile = TILE.I * TILE_INDEX_OFFSET

func _on_ButtonT_pressed():
	print("Pressed T tile button")
	active_tile = TILE.T * TILE_INDEX_OFFSET

func _on_ButtonL_pressed():
	print("Pressed L tile button")
	active_tile = TILE.L * TILE_INDEX_OFFSET

func _on_ButtonX_pressed():
	print("Pressed X tile button")
	active_tile = TILE.X * TILE_INDEX_OFFSET
