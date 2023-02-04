extends Spatial

const enemy_prefab: PackedScene = preload("res://Prefabs/FollowerMonster.tscn")
onready var rooms_generator = $"../RoomsGenerator"
onready var parent = $".."

export var monsters_per_spawner = 5;

var monsters_spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.spawn_enemies()
	
func spawn_enemies():
	monsters_spawned += 1
	for pos in rooms_generator.get_monster_spawns():
		var enemy = enemy_prefab.instance()
		enemy.transform.origin = pos
		enemy.transform.origin.y += 0.5
		parent.call_deferred("add_child", enemy)

func _on_Timer_timeout():
	if monsters_spawned < monsters_per_spawner:
		self.spawn_enemies()
