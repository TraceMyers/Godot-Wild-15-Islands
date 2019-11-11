extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float,0,1000) var distance = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	limit_left=0
	limit_right = OS.window_size.x
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().is_on_floor():
		drag_margin_v_enabled=false
	else:
		drag_margin_v_enabled= true
	
	if get_parent().facing_right:
		position.x = distance
	else:
		position.x =-distance
