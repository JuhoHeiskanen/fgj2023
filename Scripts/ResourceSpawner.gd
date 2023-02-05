extends StaticBody

var erected = false
var resource_kind: int
var hp: int = 0
export var max_hp: int = 5

func hurt(damage: int):
	if erected:
		hp -= damage
		if hp <= 0:
			erected = false
			$Shroom.visible = false
			self.remove_from_group("monster-target")
			self.add_to_group("resource-spawner")
		return

	$Shroom.visible = true
	erected = true
	hp = max_hp
	self.add_to_group("monster-target")
	self.add_to_group("resource-spawner")
	var generator = $"/root/Node/Root2/EnemyGenerator"
	if generator:
		generator.spawn_enemies()
	
func apply_resources():
	match resource_kind:
		Globals.RESOURCE_CALCIUM:
			Resources.add_calcium(hp)
		Globals.RESOURCE_WATER:
			Resources.add_water(hp)
		Globals.RESOURCE_IRON:
			Resources.add_iron(hp)


func _physics_process(delta: float) -> void:
	match resource_kind:
		Globals.RESOURCE_CALCIUM:
			$Calcium.visible = true
		Globals.RESOURCE_WATER:
			$Water.visible = true
		Globals.RESOURCE_IRON:
			$Iron.visible = true

	if !erected:
		return

	#match resource_kind:
	#	Globals.RESOURCE_CALCIUM:
	#		Resources.add_calcium(delta)
	#	Globals.RESOURCE_WATER:
	#		Resources.add_water(delta)
	#	Globals.RESOURCE_IRON:
	#		Resources.add_iron(delta)
