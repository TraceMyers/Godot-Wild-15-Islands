extends Node2D

var dirt_block = preload("res://src/blocks/DirtBlock.tscn")

var name_to_object : Dictionary = {
	"dirt_block": dirt_block
}

func _ready():
	Events.connect("create", self, "_Events_create")

func _Events_create(object_name, position, parent_name, run_physics):
	var object =  name_to_object[object_name].instance()
	object.position = position
	object.set_physics_process(run_physics)	
	get_node(parent_name).add_child(object)