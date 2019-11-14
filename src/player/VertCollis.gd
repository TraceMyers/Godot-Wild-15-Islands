extends Area2D

func colliding(direction="down"):
	var objects = get_overlapping_bodies()
	var count = objects.size() - 1
	for object in objects:
		if direction == "up" and "cloud" == object.name:
			count -= 1
	return count > 0
