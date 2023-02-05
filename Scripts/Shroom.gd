extends AnimatedSprite

onready var lvl1Frames: SpriteFrames = load("res://Resources/shrooms/Shroom1Frames.tres")
onready var lvl2Frames: SpriteFrames = load("res://Resources/shrooms/Shroom2Frames.tres")
onready var lvl3Frames: SpriteFrames = load("res://Resources/shrooms/Shroom3Frames.tres")
onready var lvl4Frames: SpriteFrames = load("res://Resources/shrooms/Shroom4Frames.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("shroom_level_changed", self, "_on_shroom_level_changed")

func _on_shroom_level_changed():
	frames = [lvl1Frames, lvl2Frames, lvl3Frames, lvl4Frames][Globals.mushroom_level - 1]
