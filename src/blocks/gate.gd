extends Node2D

var path = "res://src/levels/"
var z = 0
var door_anim_timer : Timer 
var body

func _ready():
	z=0
	door_anim_timer = Timer.new()
	door_anim_timer.connect("timeout", self, "_door_anim_timer_timeout")
	add_child(door_anim_timer)

func _on_Area2D_body_entered(_body):
	door_anim_timer.start(0.5)
	$AnimationPlayer.play("OpenDoor")
	body = _body

func _door_anim_timer_timeout():
	if z <1 and body.name == "Shaun":
		var x =0
		for i in Events.levels:
			if get_tree().get_current_scene().name ==i:
				if Events.levels.size() != x :
					x+=1
					fade.raise()
					# warning-ignore:return_value_discarded
					fade.get_node("AnimationPlayer").play("fadeIn")
					yield(fade.get_node("AnimationPlayer"),"animation_finished")
					Events.current_level += 1
					get_tree().change_scene(path+"Level%s"%String(Events.current_level)+".tscn")
				else:
					fade.raise()
					fade.get_node("AnimationPlayer").play("fadeIn")
					yield(fade.get_node("AnimationPlayer"),"animation_finished")
# warning-ignore:return_value_discarded
					get_tree().change_scene("res://src/main/menu.tscn")
					x+=1
			
		z =1


