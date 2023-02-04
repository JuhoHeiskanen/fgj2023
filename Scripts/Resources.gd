extends Node

export var water: float = 0
export var calcium: float = 0
export var iron: float = 0

func add_water(amount: float):
	water += amount
	print_resources()
func add_calcium(amount: float):
	calcium += amount
	print_resources()
func add_iron(amount: float):
	iron += amount
	print_resources()
func print_resources():
	print("W: ", water, ", C: ", calcium, ", I: ", iron)
