extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body):
	if body.name == "Shaun" and not body.get_node("Inventory").full("seed"):
		Events.emit_signal("seed_pickup")
		get_parent().queue_free()
