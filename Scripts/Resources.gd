extends Node

export var water: float = 50
export var calcium: float = 50
export var iron: float = 50

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
