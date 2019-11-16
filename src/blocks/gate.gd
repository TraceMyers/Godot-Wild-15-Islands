extends Node2D

var path = "res://src/levels/"
var z = 0
func _ready():
	z=0
func _on_Area2D_body_entered(body):
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