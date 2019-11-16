extends Node2D

var path = "res://src/levels/"

func _on_Area2D_body_entered(body):
	if body.name == "Shaun":
		var x =1
		for i in Events.levels:
			if get_tree().get_current_scene().name ==i:
				if Events.levels.size() != x :
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
					get_tree().change_scene("res://src/main/menu.tscn")
			x+=1
