extends Node2D

var path = "res://src/levels/"
var door_anim_timer : Timer 
var body
var already_opened : bool = false

func _ready():
	door_anim_timer = Timer.new()
	door_anim_timer.connect("timeout", self, "_door_anim_timer_timeout")
	add_child(door_anim_timer)

func _on_Area2D_body_entered(_body):
	if _body.name == "Shaun" and not already_opened:
		door_anim_timer.start(0.5)
		$AnimationPlayer.play("OpenDoor")
		body = _body
		already_opened = true

func _door_anim_timer_timeout():
	if Events.levels.size() > Events.current_level:
		fade.raise()
		# warning-ignore:return_value_discarded
		fade.get_node("AnimationPlayer").play("fadeIn")
		yield(fade.get_node("AnimationPlayer"),"animation_finished")
		get_tree().change_scene(path+Events.levels[Events.current_level])
	else:
		fade.raise()
		fade.get_node("AnimationPlayer").play("fadeIn")
		yield(fade.get_node("AnimationPlayer"),"animation_finished")
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/main/menu.tscn")
		


