extends KinematicBody

export var speed: float = 3
export var hp: int = 2
export var melee_range: float = 1.5
export var melee_damage: int = 1
export var melee_cooldown: float = 0.0
export var melee_delay: float = 2.5
var attack_timer: float = 0.0

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
	var attacking = false
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			var diff_to_player: Vector3 = player.translation - self.translation
			if diff_to_player.length_squared() <= melee_range * melee_range:
				melee_cooldown = melee_delay
				player.hurt(self.melee_damage)
		attacking = true
	elif melee_cooldown <= 0:
		var diff_to_player: Vector3 = player.translation - self.translation
		if diff_to_player.length_squared() <= melee_range * melee_range:
			attack_timer = 1
	else:
		melee_cooldown -= delta

	if !attacking:
		navigation.set_max_speed(speed)
		navigation.set_target_location(player.translation)
		var next_location = navigation.get_next_location()
		var diff = next_location - self.translation
		diff = diff.normalized() * speed
	
		self.sprite.angle = -atan2(diff.z, diff.x) + PI
		self.move_and_slide(diff, Vector3.UP)
