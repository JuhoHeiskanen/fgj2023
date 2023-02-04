extends Sprite3D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var front: Texture
export var back: Texture
export var right: Texture
export var left: Texture

onready var player: Node = $"../Player"
onready var yaw: Node = $"../Player/Yaw"

export var angle: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rot = angle - PI / 4
	if yaw:
		rot += yaw.rotation.y
	rot = fmod(rot, 2 * PI)
	if rot < 0:
		rot += 2 * PI

	if rot < PI/2:
		self.texture = front
	elif rot < PI:
		self.texture = right
	elif rot < 3*PI/2:
		self.texture = back
	else:
		self.texture = left

func _physics_process(delta: float):
	self.angle += PI * delta
	pass
