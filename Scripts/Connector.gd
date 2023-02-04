extends Spatial

const monster_wall_prefab: PackedScene = preload("res:///Prefabs/dungeons/MonsterWall.tscn")
const exit_door_prefab: PackedScene = preload("res:///Prefabs/dungeons/ExitWall.tscn")

var has_monsters = false
var has_exit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func has_monster_wall():
	return has_monsters

func add_monster_wall():
	var monster_wall = monster_wall_prefab.instance()
	self.add_child(monster_wall)
	has_monsters = true

func has_exit_door():
	return has_exit

func add_exit_door():
	var exit_door = exit_door_prefab.instance()
	self.add_child(exit_door)
	has_exit = true

func get_global_position():
	print(get_parent().to_global(self.translation), self.translation)
	return get_parent().to_global(self.translation)
