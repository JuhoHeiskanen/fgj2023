extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		var pos = event.position
		if event.pressed && event.button_index == BUTTON_LEFT:
			#print("Mouse Click at: ", pos)
			var tilemap = $TileMap
			var local_pos = tilemap.to_local(pos)
			#print("Local pos: ", local_pos)
			var tile_pos = tilemap.world_to_map(local_pos)
			#print("Tile pos: ", tile_pos)
			var cell = tilemap.get_cellv(tile_pos)

			if cell == 0:
				tilemap.set_cellv(tile_pos, 1)
			elif cell == 1 || cell == -1:
				tilemap.set_cellv(tile_pos, 0)
			#print("cell: ", cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
