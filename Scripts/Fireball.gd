extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var direction: Vector3
export var speed: float = 10.0
export var attack_damage: float = 1
export var bounces_left: int = 3
# export var owner: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var result = self.move_and_collide(direction * speed * delta)
	if result && result.collider:
		if result.collider.has_method("fireball"):
			return
		if result.collider.has_method("hurt"):
			result.collider.hurt(self.attack_damage)
			self.get_parent().remove_child(self)
		else:
			bounces_left -= 1
			if bounces_left <= 0:
				self.get_parent().remove_child(self)
			direction = direction.bounce(result.normal)
