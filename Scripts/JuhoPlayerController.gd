extends KinematicBody

export var walk_speed: float = 5
export var rotation_speed: float = 0.03
export var jump_force: float = 30
export var yaw: float = 0
export var pitch: float = 0
export var m_yaw: float = 0.022
export var sensitivity: float = 1
export var gravity: float = 9.81
export var hp: int = 10
export var max_hp: int = 10

export var attack_delay = .5
export var attack_damage = 2
export var melee_distance = 2
var attack_cooldown = 0.0

var walk_cooldown = 0.0
export var walk_delay = .4

onready var attack_animation = $Hud/Center/Attack1
onready var hurt_animation = $Hud/CanvasLayer/CanvasLayer/Center/Attack1
onready var dead_display = $Hud/Center2/Youaredead

const fireball_scene: PackedScene = preload("res:///Prefabs/Fireball.tscn")

var eye_height: float
var vel = Vector3()
var dead = false

var start_position = Vector3()

signal back_to_builder

func hurt(damage: int):
	hp -= damage
	self.hurt_animation.frame = 0
	self.hurt_animation.play()
	$GetHit.play()
	self.update_hp_display()
	if hp <= 0 and !dead:
		dead = true
		self.eye_height = -0.5
		$Yaw/Pitch/Camera.transform = $Yaw/Pitch/Camera.transform.rotated(Vector3.FORWARD, PI/2)
		dead_display.visible = true
		$DeathTimer.start()

func reset_everything():
	$"../RoomsGenerator".clear_navmesh()
	get_tree().reload_current_scene()


func update_hp_display():
	var hp_ratio = float(hp) / float(max_hp) / 2 + 0.25
	$Hud/CanvasLayer/CanvasLayer/HpDisplayBase.color.a = hp_ratio
	
func set_start_position(vec):
	start_position = vec
	transform.origin = vec
	yaw = PI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	eye_height = $Yaw.transform.origin.y
	update_hp_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

func punch():
	self.attack_cooldown = self.attack_delay
	self.attack_animation.frame = 0
	self.attack_animation.play()

	var space_state = get_world().direct_space_state
	var look = Vector3.FORWARD.rotated(Vector3.LEFT, -pitch).rotated(Vector3.UP, -yaw)
	var result = space_state.intersect_ray(self.translation, self.translation + look * melee_distance)
	if result && result.collider:
		if result.collider.is_in_group("exit"):
			call_deferred("emit_signal", "back_to_builder")
		elif result.collider.has_method("hurt"):
			$FistHit.play()
			result.collider.hurt(self.attack_damage)


func fireball():
	self.attack_cooldown = self.attack_delay
	var look = Vector3.FORWARD.rotated(Vector3.LEFT, -pitch).rotated(Vector3.UP, -yaw)
	var projectile = fireball_scene.instance()
	projectile.translation = self.translation + $Yaw.translation
	projectile.direction = look
	$Fireball.play()
	self.get_parent().add_child(projectile)


func _physics_process(delta: float) -> void:
	if dead: return

	if self.attack_cooldown > 0:
		self.attack_cooldown -= delta

	var move = Vector3(
		Input.get_action_strength("strafe_right") - Input.get_action_strength("strafe_left"),
		0,
		Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	)
	if move.length_squared() > 0.1:
		self.walk_cooldown -= delta
		if self.walk_cooldown <= 0:
			$Walk.stream.loop = false
			$Walk.pitch_scale = rand_range(0.8, 1.2)
			$Walk.play()
			self.walk_cooldown += self.walk_delay
	move = move.normalized().rotated(Vector3.UP, -yaw)
	
	if Input.is_action_pressed("sprint"):
		move = move * 4
	self.vel.x = move.x * walk_speed
	self.vel.z = move.z * walk_speed
	self.vel.y -= gravity * delta

	if Input.is_action_just_pressed("jump"):
		self.vel.y = jump_force

	if Input.is_action_pressed("attack") && attack_cooldown <= 0.0:
		self.punch()

	if Input.is_action_pressed("attack2") && attack_cooldown <= 0.0:
		self.fireball()

	self.vel = self.move_and_slide(self.vel, Vector3.UP, true)

	if Input.is_action_pressed("crouch"):
		$Yaw.transform.origin.y = 0
	else:
		$Yaw.transform.origin.y = eye_height
