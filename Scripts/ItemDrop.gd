extends Spatial

export var kind: int;
export var amount: float;

func on_body_enter(body: Node):
	match kind:
		Globals.RESOURCE_CALCIUM: Resources.add_calcium(amount)
		Globals.RESOURCE_WATER: Resources.add_water(amount)
		Globals.RESOURCE_IRON: Resources.add_iron(amount)
	self.get_parent().remove_child(self)
