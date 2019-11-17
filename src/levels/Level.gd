extends Node2D

var dirt_block = preload("res://src/blocks/DirtBlock.tscn")
var dirt_block_destroy_anim = preload("res://assets/animations/DirtBlockDestroy.tscn")
var _seed = preload("res://src/seed/Seed.tscn")
var seed_balloon_pop = preload("res://assets/animations/SeedBalloonPop.tscn")

var timers : Array = []
var timer_objects : Array = []
var parents : Array = []

var name_to_object : Dictionary = {
	"dirt_block": dirt_block,
	"dirt_block_destroy_anim": dirt_block_destroy_anim,
	"seed": _seed,
	"seed_balloon_pop": seed_balloon_pop
}

func _ready():
	Events.connect("create", self, "_Events_create")

func _Events_create(object_name, position, parent_name, run_physics, timer_set=-1.0):
	var object =  name_to_object[object_name].instance()
	object.position = position
	object.set_physics_process(run_physics)	
	get_node(parent_name).add_child(object)
	if timer_set > 0:
		var timer = Timer.new()
		timer.set_one_shot(true)
		add_child(timer)
		timer.start(timer_set)
		timers.append(timer)
		timer_objects.append(object)
		parents.append(get_node(parent_name))
		timer.connect("timeout", self, "_check_timers_and_delete")

func _check_timers_and_delete(delta):
	for i in timers.size():
		if timers[i].get_time_left() == 0:
			parents[i].remove_child(timer_objects[i])
			remove_child(timers[i])
			parents.erase(parents[i])
			timers.erase(timers[i])
			timer_objects.erase(timer_objects[i])


