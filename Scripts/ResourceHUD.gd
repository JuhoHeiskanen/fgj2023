extends HBoxContainer

onready var ironLabel: Label = $Iron/Label
onready var waterLabel: Label = $Water/Label
onready var calcLabel: Label = $Calc/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Resources.connect("resources_updated", self, "_on_resources_updated")
	pass # Replace with function body.

func _on_resources_updated():
	update_labels()

func update_labels():
	calcLabel.text = str(round(Resources.calcium))
	ironLabel.text = str(round(Resources.iron))
	waterLabel.text = str(round(Resources.water))
