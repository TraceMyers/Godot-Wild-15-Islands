extends Node

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		Events.emit_signal("move_x", -1)
	if Input.is_action_pressed("ui_right"):
		Events.emit_signal("move_x", 1)	
	if Input.is_action_just_pressed("ui_select"):
		Events.emit_signal("jp_jump")	
	elif Input.is_action_pressed("ui_select"):
		Events.emit_signal("jump")	
	if Input.is_action_just_pressed("ui_accept"):
		Events.emit_signal("jp_dig")	
	if Input.is_action_just_pressed("ui_option"):
		Events.emit_signal("jp_place_block")	
	if Input.is_action_just_pressed("ui_cancel"):
		Events.emit_signal("jp_plant")	
