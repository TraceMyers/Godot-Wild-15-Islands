extends Node

const SEEDS_MAX : int = 1
const DIRT_BLOCKS_MAX : int = 3

var inventory : Dictionary = {
	"seed" : [1, SEEDS_MAX],
	"dirt_block" : [0, DIRT_BLOCKS_MAX]
}

func add(item_name) -> bool:
	if inventory[item_name][0] < inventory[item_name][1]:
		inventory[item_name][0] += 1
		return true
	return false	

func remove(item_name) -> bool:
	if inventory[item_name][0] > 0:
		inventory[item_name][0] -= 1
		return true
	return false	

func full(item_name) -> bool:
	return inventory[item_name][0] >= inventory[item_name][1]

func empty(item_name) -> bool:
	return inventory[item_name][0] <= 0

func count(item_name) -> int:
	return inventory[item_name][0]