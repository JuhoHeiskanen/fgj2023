extends AnimatedSprite

onready var lvl1Frames: SpriteFrames = preload("res://Resources/shrooms/Shroom1Frames.tres")
onready var lvl2Frames: SpriteFrames = preload("res://Resources/shrooms/Shroom2Frames.tres")
onready var lvl3Frames: SpriteFrames = preload("res://Resources/shrooms/Shroom3Frames.tres")
onready var lvl4Frames: SpriteFrames = preload("res://Resources/shrooms/Shroom4Frames.tres")

signal restart

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("shroom_level_changed", self, "_on_shroom_level_changed")

func _on_shroom_level_changed():
	frames = [lvl1Frames, lvl2Frames, lvl3Frames, lvl4Frames][Globals.mushroom_level - 1]
	if Globals.mushroom_level == 4:
		emit_signal("restart")
