extends Spatial

const monster_wall_prefab: PackedScene = preload("res:///Prefabs/dungeons/MonsterWall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_monster_wall():
	var monster_wall = monster_wall_prefab.instance()
	self.add_child(monster_wall)
	pass
