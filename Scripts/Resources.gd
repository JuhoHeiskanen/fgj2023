extends Node

export var water: float = 0
export var calcium: float = 0
export var iron: float = 0

func reset_resources():
	water = 1
	calcium = 1
	iron = 1
	
func _ready():
	reset_resources()

signal resources_updated

func add_water(amount: float):
	water += amount
	print_resources()
func add_calcium(amount: float):
	calcium += amount
	print_resources()
func add_iron(amount: float):
	iron += amount
	print_resources()

func sub_water(amount: float):
	water -= amount
	print_resources()
func sub_calcium(amount: float):
	calcium -= amount
	print_resources()
func sub_iron(amount: float):
	iron -= amount
	print_resources()

func print_resources():
	# print("W: ", water, ", C: ", calcium, ", I: ", iron)
	emit_signal("resources_updated")
	pass
