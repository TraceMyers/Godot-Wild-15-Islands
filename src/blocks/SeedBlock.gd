extends Node2D

func _ready():
	for block in get_children():
		block.plant_seed()
		block.float_speed = 1.0