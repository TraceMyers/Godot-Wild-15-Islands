extends Area2D

var balloons_entered : Array = []

func _ready():
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area):
	if "Balloon" in area.name:
		balloons_entered.append(area)

func _on_area_exited(area):
	if area in balloons_entered:
		balloons_entered.erase(area)
		
func _process(delta):
	for area in balloons_entered:
		if area.get_parent().seeded:
			var dirt_block = area.get_parent()
			dirt_block.remove_seed()
			var block_exists = true
			while block_exists:
				block_exists = dirt_block.remove_block_from_stack()
				Events.emit_signal("fork_block_destroy")
			Events.emit_signal("seed_pickup")	
			Events.emit_signal(
				"create",
				"seed_balloon_pop",
				dirt_block.position,
				"DirtBlocks",
				false,
				0.5
			)
