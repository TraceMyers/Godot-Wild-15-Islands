extends Node

const boundary_bottom_right = Vector2(2848.0, 2000.0)
const start_seeds : int = 0

func _ready():
	get_parent().get_node("Shaun").get_node("Camera2D").limit_right = boundary_bottom_right.x
	Events.current_level = 1

