extends KinematicBody

export var speed: float = 3
export var hp: int = 2
export var melee_range: float = 1.5
export var melee_damage: int = 1
export var melee_cooldown: float = 0.0
export var melee_delay: float = 2.5
export var attack_windup: float = 1.0
var attack_timer: float = 0.0
export var goes_after_resource_spawners: bool = true

onready var player = $"../Player"
onready var navigation: NavigationAgent = $"NavigationAgent"
onready var sprite = $"MonsterSprite"

var path = []

func hurt(damage: int):
	self.hp -= damage
	if hp <= 0:
		self.get_parent().remove_child(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	NavigationServer.set_active(true)

func _physics_process(delta):
	var targets = get_tree().get_nodes_in_group("monster-target" if goes_after_resource_spawners else "player")
	if targets.size() <= 0:
		return
	var smallest_distance = (targets[0].get_global_transform().origin - self.translation).length_squared()
	var target_entity = targets[0]
	for t in targets:
		var dist = (t.get_global_transform().origin - self.translation).length_squared()
		if dist < smallest_distance:
			smallest_distance = dist
			target_entity = t
	
	var attacking = false
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			var diff_to_target: Vector3 = target_entity.get_global_transform().origin - self.translation
			if diff_to_target.length_squared() <= melee_range * melee_range:
				melee_cooldown = melee_delay
				if target_entity.has_method("hurt"):
					target_entity.hurt(self.melee_damage)
		attacking = true
	elif melee_cooldown <= 0:
		var diff_to_target: Vector3 = target_entity.get_global_transform().origin - self.translation
		if diff_to_target.length_squared() <= melee_range * melee_range:
			attack_timer = attack_windup
	else:
		melee_cooldown -= delta

	if !attacking:
		navigation.set_max_speed(speed)
		navigation.set_target_location(target_entity.get_global_transform().origin)
		var next_location = navigation.get_next_location()
		var diff = next_location - self.translation
		diff = diff.normalized() * speed
	
		self.sprite.angle = -atan2(diff.z, diff.x) + PI
		self.move_and_slide(diff, Vector3.UP)
