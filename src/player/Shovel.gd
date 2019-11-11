extends Area2D

func get_dirt_block_underneath(objectName ="DirtBlock"):
	var objects_underneath = get_overlapping_bodies()
	var dirt_block = null
	if objects_underneath.size() > 0:
		for object in objects_underneath:
			if objectName in object.get_name():
				dirt_block = object
	return dirt_block			

