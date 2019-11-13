extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func get_block_underneath(objectName ="DirtBlock"):
	var objects_underneath = get_overlapping_bodies()
	var block = null
	if objects_underneath.size() > 0:
		for object in objects_underneath:
			if objectName in object.get_name():
				block = object
	return block			

func _on_body_entered(area):
	if "cloud" in area.get_name():
		area.bounce()
		
func _on_body_exited(area):
	if "cloud" in area.get_name():
		area.bounce()