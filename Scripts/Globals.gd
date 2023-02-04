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
