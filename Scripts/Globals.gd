extends Node

const TILE_INDEX_OFFSET = 4

const FLAG_NORTH = 1
const FLAG_EAST = 2
const FLAG_SOUTH = 4
const FLAG_WEST = 8

const BITMASK_I = FLAG_WEST | FLAG_EAST
const BITMASK_L = FLAG_WEST | FLAG_SOUTH
const BITMASK_T = FLAG_WEST | FLAG_EAST | FLAG_SOUTH
const BITMASK_X = FLAG_WEST | FLAG_EAST | FLAG_SOUTH | FLAG_NORTH

const RESOURCE_CALCIUM = 2
const RESOURCE_IRON = 3
const RESOURCE_WATER = 4


const UPGRADE_PRICE_WATER = 5 
const UPGRADE_PRICE_IRON = 5 
const UPGRADE_PRICE_CALC = 5 

var mushroom_level = 1

signal shroom_level_changed

func upgrade_available():
	var hasRes =  Resources.water > UPGRADE_PRICE_WATER && Resources.calcium > UPGRADE_PRICE_CALC && Resources.iron > UPGRADE_PRICE_IRON
	return hasRes && mushroom_level < 4

func upgrade_mushroom():
	print("trying to upgrade mushroom")
	if upgrade_available():
		print("Upgrading mushroom")
		Resources.sub_water(UPGRADE_PRICE_WATER)
		Resources.sub_iron(UPGRADE_PRICE_IRON)
		Resources.sub_calcium(UPGRADE_PRICE_CALC)
		mushroom_level += 1
		emit_signal("shroom_level_changed")
		
	
