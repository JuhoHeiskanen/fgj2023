extends Spatial

const normal_enemy_prefab: PackedScene = preload("res://Prefabs/FollowerMonster.tscn")
const flying_enemy_prefab: PackedScene = preload("res://Prefabs/FlyingMonster.tscn")
const boss_enemy_prefab: PackedScene = preload("res://Prefabs/BossOfThisGym.tscn")
onready var rooms_generator = $"../RoomsGenerator"
onready var parent = $".."

export var monsters_per_spawner = 1;

var monsters_spawned = 0
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	self.spawn_enemies()
	
func spawn_enemies():
	monsters_spawned += 1
	for pos in rooms_generator.get_monster_spawns():
		rng.randomize()
		var roll = rng.randf_range(0.0, 100.0)
		var enemy = null
		if roll <= 60.0:
			enemy = normal_enemy_prefab.instance()
		elif roll > 60.0 and roll <= 97.0:
			enemy = flying_enemy_prefab.instance()
		else:
			enemy = boss_enemy_prefab.instance()
		enemy.transform.origin = pos
		enemy.transform.origin.y += 0.5
		parent.call_deferred("add_child", enemy)

func _on_Timer_timeout():
	if monsters_spawned < monsters_per_spawner:
		self.spawn_enemies()
