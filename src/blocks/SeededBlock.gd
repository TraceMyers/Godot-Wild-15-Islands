extends Node2D

func _ready():
	for block in get_children():
		block.plant_seed()
		block.add_block_to_stack()
