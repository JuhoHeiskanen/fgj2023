extends StaticBody

var erected = false

func hurt(damage: int):
	if erected:
		return
	$Shroom.visible = true
	erected = true

func _physics_process(delta: float) -> void:
	if !erected:
		return

	Resources.add_water(delta)
	Resources.add_iron(delta)
	Resources.add_calcium(delta)
