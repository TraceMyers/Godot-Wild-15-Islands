extends Area2D

func float_collision(this_block, dir):
	var objects = get_overlapping_bodies()
	var count = objects.size()
	for object in objects:
		if object == this_block:
			count -= 1
		var object_name : String = object.get_name()	
		if "Shaun" in object_name and dir == -1:
			count -= 1
	return count > 0
