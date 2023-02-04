extends Node2D

enum TILE {I, L, T, X}
const TILE_INDEX_OFFSET = 4
enum ROTATION {ROT_0, ROT_90, ROT_180, ROT_270}

var active_tile = TILE.I
var tile_rotation = ROTATION.ROT_0;

var TILE_TEXTURE_I = load("res://Resources/hetero_tile.png")
var TILE_TEXTURE_L = load("res://Resources/l_tile.png")
var TILE_TEXTURE_T = load("res://Resources/3way_tile.png")
var TILE_TEXTURE_X = load("res://Resources/4way_tile.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ButtonI_pressed() # This resets the preview/tile type to the default I-tile
	pass # Replace with function body.


func _input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		handle_button_press(event)

	if event is InputEventMouseButton:
		handle_left_click(event)
		handle_mouse_scroll(event)

	if event is InputEventMouseMotion:
		handle_mouse_move(event)

func handle_mouse_move(event: InputEventMouseMotion):
	var pos = event.position
	var tilemap = $LevelContainer/TileMap

	var local_pos = tilemap.to_local(pos)
	if local_pos.y <= 0:
		return

	var sprite: Sprite = $LevelContainer/TilePreview
	var tile_pos = Vector2(
		int((local_pos.x / tilemap.cell_size.x)) * tilemap.cell_size.x * tilemap.scale.x + sprite.texture.get_width() / 2,
		int((local_pos.y / tilemap.cell_size.y)) * tilemap.cell_size.y * tilemap.scale.y + sprite.texture.get_height() / 2
		)
	sprite.position = tile_pos

func handle_button_press(event: InputEventKey):
	# handle key presses
	match event.scancode:
		KEY_R:
			rotate_tile()

func handle_mouse_scroll(event: InputEventMouseButton):
	var container = $LevelContainer
	if event.pressed && event.button_index == BUTTON_WHEEL_DOWN:
		container.position.y -= 16;
	if event.pressed && event.button_index == BUTTON_WHEEL_UP:
		container.position.y = min(container.position.y + 16, 256);

func handle_left_click(event: InputEventMouseButton):
	if event.pressed && event.button_index == BUTTON_LEFT:
		var pos = event.position
		#print("Mouse Click at: ", pos)
		var tilemap = $LevelContainer/TileMap
		var local_pos = tilemap.to_local(pos)
		#print("Local pos: ", local_pos)

		# If clicked above the "ground line", can't place tiles
		if local_pos.y <= 0:
			return

		var tile_pos = tilemap.world_to_map(local_pos)
		#print("Tile pos: ", tile_pos)
		#print("Setting tile to: ", active_tile)

		# don't allow overriding non-empty cells
		var cell = tilemap.get_cellv(tile_pos)
		if cell != -1:
			return

		tilemap.set_cellv(tile_pos, active_tile + tile_rotation)

func rotate_tile():
	tile_rotation = (tile_rotation + 1)  % (ROTATION.ROT_270 + 1)
	update_preview_rotation()

func update_preview_rotation():
	var preview = $LevelContainer/TilePreview
	preview.rotation = (tile_rotation * 90) / (180/PI)

func _on_ButtonI_pressed():
	print("Pressed I tile button")
	active_tile = TILE.I * TILE_INDEX_OFFSET
	var preview = $LevelContainer/TilePreview
	preview.texture = TILE_TEXTURE_I
	update_preview_rotation()

func _on_ButtonT_pressed():
	print("Pressed T tile button")
	active_tile = TILE.T * TILE_INDEX_OFFSET
	var preview = $LevelContainer/TilePreview
	preview.texture = TILE_TEXTURE_T
	update_preview_rotation()

func _on_ButtonL_pressed():
	print("Pressed L tile button")
	active_tile = TILE.L * TILE_INDEX_OFFSET
	var preview = $LevelContainer/TilePreview
	preview.texture = TILE_TEXTURE_L
	update_preview_rotation()

func _on_ButtonX_pressed():
	print("Pressed X tile button")
	active_tile = TILE.X * TILE_INDEX_OFFSET
	var preview = $LevelContainer/TilePreview
	preview.texture = TILE_TEXTURE_X
	update_preview_rotation()
