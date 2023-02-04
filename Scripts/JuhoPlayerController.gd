extends KinematicBody

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var walk_speed: float = 5
export var rotation_speed: float = 0.03
export var jump_force: float = 30
export var yaw: float = 0
export var pitch: float = 0
export var m_yaw: float = 0.022
export var sensitivity: float = 1
export var gravity: float = 9.81


var eye_height: float
var vel = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	eye_height = $Yaw.transform.origin.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	var rotation = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")
	var vert_rotation = Input.get_action_strength("turn_up") - Input.get_action_strength("turn_down")
	yaw += rotation * rotation_speed
	pitch += vert_rotation * rotation_speed
	if pitch > PI / 2:
		pitch = PI / 2
	if pitch < -PI / 2:
		pitch = -PI / 2
	$Yaw.rotation.y = -yaw
	$Yaw/Pitch.rotation.x = pitch


func _input(event):
	if event is InputEventMouseMotion:
		yaw += event.relative.x * m_yaw * sensitivity * .1
		pitch += -event.relative.y * m_yaw * sensitivity * .1

func _physics_process(delta: float) -> void:
	var move = Vector3(
		Input.get_action_strength("strafe_right") - Input.get_action_strength("strafe_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	move = move.normalized().rotated(Vector3.UP, -yaw)
	if Input.is_action_pressed("sprint"):
		move = move * 4
	self.vel.x = move.x * walk_speed
	self.vel.z = move.z * walk_speed
	self.vel.y -= gravity * delta

	if Input.is_action_just_pressed("jump"):
		self.vel.y = jump_force

	self.vel = self.move_and_slide(self.vel, Vector3.UP, true)

	if Input.is_action_pressed("crouch"):
		$Yaw.transform.origin.y = 0
	else:
		$Yaw.transform.origin.y = eye_height
