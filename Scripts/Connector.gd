extends Spatial

const monster_wall_prefab: PackedScene = preload("res:///Prefabs/dungeons/MonsterWall.tscn")

var has_monsters = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func has_monster_wall():
	return has_monsters

func add_monster_wall():
	var monster_wall = monster_wall_prefab.instance()
	self.add_child(monster_wall)
	has_monsters = true

func get_global_position():
	print(get_parent().to_global(self.translation), self.translation)
	return get_parent().to_global(self.translation)
