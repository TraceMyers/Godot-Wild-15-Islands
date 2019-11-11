extends Node

signal jump
signal jp_jump
signal move_x
signal jp_dig
signal jp_place_block
signal jp_plant

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		emit_signal("move_x", -1,false)
	if Input.is_action_pressed("ui_right"):
		emit_signal("move_x", 1,true)	
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("jp_jump")	
	elif Input.is_action_pressed("ui_select"):
		emit_signal("jump")	
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("jp_dig")	
	if Input.is_action_just_pressed("ui_option"):
		emit_signal("jp_place_block")	
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("jp_plant")	
