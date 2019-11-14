extends Node2D

const boundary_bottom_right = Vector2(2848.0, 2000.0)

var dirt_block = preload("res://src/blocks/DirtBlock.tscn")

var name_to_object : Dictionary = {
	"dirt_block": dirt_block
}

func _ready():
	Events.connect("create", self, "_Events_create")
	$Shaun/Camera2D.limit_right = boundary_bottom_right.x

func _Events_create(object_name, position, parent_name, run_physics):
	var object =  name_to_object[object_name].instance()
	object.position = position
	object.set_physics_process(run_physics)	
	get_node(parent_name).add_child(object)
	
