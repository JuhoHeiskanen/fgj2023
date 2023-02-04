extends KinematicBody

export var speed: float = 3

onready var room_generator = $"../RoomsGenerator"
onready var player = $"../Player"
onready var navigation: NavigationAgent = $"NavigationAgent"
onready var sprite = $"MonsterSprite"

var path = []

# Called when the node enters the scene tree for the first time.
func _ready():
	NavigationServer.set_active(true)

func _physics_process(delta):
	navigation.set_target_location(player.translation)
	var next_location = navigation.get_next_location()
	var diff = next_location - self.translation
	diff = diff.normalized() * speed
	
	self.sprite.angle = -atan2(diff.z, diff.x) + PI
	self.move_and_slide(diff, Vector3.UP)

func _on_Timer_timeout():
	#navigation.set_target_location(player.translation)
	pass
