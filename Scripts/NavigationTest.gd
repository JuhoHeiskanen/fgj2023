extends KinematicBody

onready var room_generator = $"../RoomsGenerator"
onready var player = $"../Player"
onready var navigation: NavigationAgent = $"NavigationAgent"

var path = []

# Called when the node enters the scene tree for the first time.
func _ready():
	NavigationServer.set_active(true)

func _physics_process(delta):
	navigation.set_target_location(player.translation)
	var next_location = navigation.get_next_location()
	var diff = next_location - self.translation
	diff = diff.normalized() * 10
	self.move_and_slide(diff, Vector3.UP)

func _on_Timer_timeout():
	#navigation.set_target_location(player.translation)
	pass
