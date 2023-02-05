extends Node

const builder_prefab: PackedScene = preload("res://RootBuilderScene.tscn")
const scene3d_prefab: PackedScene = preload("res://MainScene3D.tscn")

var builder_scene = null
var scene3d = null

# Called when the node enters the scene tree for the first time.
func _ready():
	show_builder_scene()
	builder_scene.connect("start_3d_scene", self, "show_3d_scene")

func show_builder_scene():
	if scene3d:
		var generator = scene3d.get_node("RoomsGenerator")
		generator.clear_navmesh()
		self.remove_child(scene3d)
		scene3d.queue_free()
		scene3d = null
		
	if builder_scene == null:
		builder_scene = builder_prefab.instance()

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.add_child(builder_scene)

func show_3d_scene(data):
	self.remove_child(builder_scene)
	
	var offset_x = data[1]
	var offset_z = data[2]
	data = data[0]
	
	scene3d = scene3d_prefab.instance()
	var generator = scene3d.get_node("RoomsGenerator")
	generator.tiles = data
	generator.offset_x = offset_x
	generator.offset_z = offset_z
	
	var player = scene3d.get_node("Player")
	player.connect("back_to_builder", self, "show_builder_scene")
	self.add_child(scene3d)
