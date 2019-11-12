extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path ="res://src/levels/"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Shaun":
		var x =1
		for i in Events.levels:
			
			if get_tree().get_current_scene().name+".tscn" ==i:
				if Events.levels.size() != x :
					fade.raise()
# warning-ignore:return_value_discarded
					fade.get_node("AnimationPlayer").play("fadeIn")
					yield(fade.get_node("AnimationPlayer"),"animation_finished")
					get_tree().change_scene(path+Events.levels[Events.levels.find(i)+1])
				else:
					fade.raise()
					fade.get_node("AnimationPlayer").play("fadeIn")
					yield(fade.get_node("AnimationPlayer"),"animation_finished")
					get_tree().change_scene("res://src/main/menu.tscn")
			x+=1
	pass # Replace with function body.
