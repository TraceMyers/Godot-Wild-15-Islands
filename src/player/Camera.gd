extends Camera2D

export(float,0,1000) var distance = 1

func _enter_tree():
	limit_left=0
	limit_right = OS.window_size.x # updated by level

func _process(delta):
	if get_parent().is_on_floor():
		drag_margin_v_enabled=false
	else:
		drag_margin_v_enabled= true
	
	if get_parent().facing_right:
		position.x = distance
	else:
		position.x =-distance
