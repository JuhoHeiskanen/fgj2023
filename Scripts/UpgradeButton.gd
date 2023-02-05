extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _pressed():
	# This automatically checks if the upgrade is available
	Globals.upgrade_mushroom()
