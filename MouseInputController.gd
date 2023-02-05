extends Node2D

enum TILE {I, L, T, X}
enum ROTATION {ROT_0, ROT_90, ROT_180, ROT_270}

var active_tile = TILE.I
var tile_rotation = ROTATION.ROT_0;

var TILE_TEXTURE_I = load("res://Resources/hetero_tile.png")
var TILE_TEXTURE_L = load("res://Resources/l_tile.png")
var TILE_TEXTURE_T = load("res://Resources/3way_tile.png")
var TILE_TEXTURE_X = load("res://Resources/4way_tile.png")

onready var level_container = $LevelContainer
onready var tilemap = $LevelContainer/TileMap
onready var preview = $LevelContainer/TilePreview

onready var buttonI: TextureButton = $Hud/Hudfiller/HBoxContainer/ButtonI
onready var buttonL: TextureButton = $Hud/Hudfiller/HBoxContainer/ButtonL
onready var buttonT: TextureButton = $Hud/Hudfiller/HBoxContainer/ButtonT
onready var buttonX: TextureButton = $Hud/Hudfiller/HBoxContainer/ButtonX

onready var referenceWidth = get_viewport_rect().size[0]
onready var referenceHeight = get_viewport_rect().size[1]

signal start_3d_scene

func on_resize():
	var viewport_size = get_viewport_rect().size
	var scaleX = viewport_size[0] / referenceWidth
	var scaleY = viewport_size[1] / referenceHeight
	level_container.scale.x = scaleX
	level_container.scale.y = scaleY
	level_container.position.y = min(level_container.position.y, get_viewport_rect().size[1] / 2);

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_ButtonI_pressed() # This resets the preview/tile type to the default I-tile
	get_tree().get_root().connect("size_changed", self, "on_resize")

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
		var data = tilemap.serialize_tilemap()
		emit_signal("start_3d_scene", data)
		return

	if event is InputEventKey and event.pressed:
		handle_button_press(event)

	if event is InputEventMouseButton:
		handle_left_click(event)
		handle_mouse_scroll(event)

	if event is InputEventMouseMotion:
		handle_mouse_move(event)

func handle_mouse_move(event: InputEventMouseMotion):
	var pos = event.position

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
		KEY_1:
			_on_ButtonI_pressed()
		KEY_2:
			_on_ButtonL_pressed()
		KEY_3:
			_on_ButtonT_pressed()
		KEY_4:
			_on_ButtonX_pressed()
		KEY_R:
			rotate_tile()

func handle_mouse_scroll(event: InputEventMouseButton):
	var container = $LevelContainer
	if event.pressed && event.button_index == BUTTON_WHEEL_DOWN:
		container.position.y -= 16;
	if event.pressed && event.button_index == BUTTON_WHEEL_UP:
		container.position.y = min(container.position.y + 16, get_viewport_rect().size[1] / 2);

func handle_left_click(event: InputEventMouseButton):
	if event.pressed && event.button_index == BUTTON_LEFT:
		var pos = event.position
		#print("Mouse Click at: ", pos)
		var local_pos = tilemap.to_local(pos)
		#print("Local pos: ", local_pos)

		# If clicked above the "ground line", can't place tiles
		if local_pos.y <= 0:
			return

		var tile_pos = tilemap.world_to_map(local_pos)
		#print("Tile pos: ", tile_pos)
		#print("Setting tile to: ", active_tile)
		place_cell(tile_pos)


func place_cell(tile_pos: Vector2):
	# don't allow overriding non-empty cells
	var cell = tilemap.get_cellv(tile_pos)
	if cell != -1:
		return

	# This should go through the 4 surrounding cells: above, right, under, left
	var valid = false
	var newtile_bitmask = get_rotated_tile_bitmap(int(active_tile / Globals.TILE_INDEX_OFFSET), tile_rotation)

	print("New tile bitmask: ", newtile_bitmask)

	# Check cells to right and left
	for x in [-1, 1]:
		var c = tilemap.get_cell(tile_pos.x + x, tile_pos.y)
		if c == -1:
			continue

		var r = c % 4

		var target_bitmask = get_rotated_tile_bitmap(int(c / Globals.TILE_INDEX_OFFSET), r)
		print("X offset: ", x, ", Target bitmask: ", target_bitmask)

		# Check connection to the RIGHT
		if x > 0 && (newtile_bitmask & Globals.FLAG_EAST) != 0 && (target_bitmask & Globals.FLAG_WEST) != 0:
			print("Valid connection to the RIGHT")
			valid = true
			break
		# Check connection to the left
		elif x < 0 && (newtile_bitmask & Globals.FLAG_WEST) != 0 && (target_bitmask & Globals.FLAG_EAST) != 0:
			valid = true
			print("Valid connection to the LEFT")
			break

	# Check cells above and below
	for y in [-1, 1]:
		var c = tilemap.get_cell(tile_pos.x, tile_pos.y + y)
		if c == -1:
			continue

		var r = c % 4

		var target_bitmask = get_rotated_tile_bitmap(int(c / Globals.TILE_INDEX_OFFSET), r)
		print("Y offset: ", y, ", Target bitmask: ", target_bitmask)

		# Check connection above
		if y < 0 && (newtile_bitmask & Globals.FLAG_NORTH) != 0 && (target_bitmask & Globals.FLAG_SOUTH) != 0:
			print("Valid connection to the UP")
			valid = true
			break
		# Check connection below
		elif y > 0 && (newtile_bitmask & Globals.FLAG_SOUTH) != 0 && (target_bitmask & Globals.FLAG_NORTH) != 0:
			print("Valid connection to the DOWN")
			valid = true
			break

	# Check cell price
	match int(active_tile / Globals.TILE_INDEX_OFFSET):
		TILE.I:
			# No price
			valid = valid &&  true
		TILE.L:
			valid = Resources.calcium >= 1 && valid
			if valid:
				Resources.sub_calcium(1)
		TILE.T:
			valid = Resources.water >= 1 && valid
			if valid:
				Resources.sub_water(1)
		TILE.L:
			valid = Resources.iron >= 1 && valid
			if valid:
				Resources.sub_iron(1)

	if valid:
		tilemap.set_cellv(tile_pos, active_tile + tile_rotation)


func get_rotated_tile_bitmap(tile: int, rot: int):
	var base_bitmask = [Globals.BITMASK_I, Globals.BITMASK_L, Globals.BITMASK_T, Globals.BITMASK_X][tile]
	var rotated_bitmask = ((base_bitmask << rot) | (base_bitmask >> (4 - rot))) & 0b1111
	return rotated_bitmask

func rotate_tile():
	tile_rotation = (tile_rotation + 1)  % (ROTATION.ROT_270 + 1)
	update_preview_rotation()

func update_preview_rotation():
	preview.rotation = (tile_rotation * 90) / (180/PI)

func _on_ButtonI_pressed():
	print("Pressed I tile button")
	active_tile = TILE.I * Globals.TILE_INDEX_OFFSET
	preview.texture = TILE_TEXTURE_I
	reset_all_button_opacity()
	highlight_button(buttonI)
	update_preview_rotation()

func _on_ButtonT_pressed():
	print("Pressed T tile button")
	active_tile = TILE.T * Globals.TILE_INDEX_OFFSET
	preview.texture = TILE_TEXTURE_T
	reset_all_button_opacity()
	highlight_button(buttonT)
	update_preview_rotation()

func _on_ButtonL_pressed():
	print("Pressed L tile button")
	active_tile = TILE.L * Globals.TILE_INDEX_OFFSET
	preview.texture = TILE_TEXTURE_L
	reset_all_button_opacity()
	highlight_button(buttonL)
	update_preview_rotation()

func _on_ButtonX_pressed():
	print("Pressed X tile button")
	active_tile = TILE.X * Globals.TILE_INDEX_OFFSET
	preview.texture = TILE_TEXTURE_X
	reset_all_button_opacity()
	highlight_button(buttonX)
	update_preview_rotation()

func highlight_button(button: TextureButton):
	var color = button.self_modulate
	var newColor = Color(color.r, color.g, color.b, 1)
	button.self_modulate = newColor

func reset_all_button_opacity():
	for button in [buttonI, buttonT, buttonL, buttonX]:
		var color = button.self_modulate
		var newColor = Color(color.r, color.g, color.b, 0.8)
		button.self_modulate = newColor
