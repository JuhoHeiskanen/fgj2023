extends KinematicBody

export var speed: float = 3
export var hp: int = 2

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
	navigation.set_max_speed(speed)
	navigation.set_target_location(player.translation)
	var next_location = navigation.get_next_location()
	var diff = next_location - self.translation
	diff = diff.normalized() * speed
	
	self.sprite.angle = -atan2(diff.z, diff.x) + PI
	self.move_and_slide(diff, Vector3.UP)
