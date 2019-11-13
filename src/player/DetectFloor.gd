extends Area2D

func on_floor():
	var objects_underneath = get_overlapping_bodies()
	return objects_underneath.size() > 1