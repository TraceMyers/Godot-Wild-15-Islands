extends Node2D

func _ready():
	$Area2D/CollisionShape2D.shape.extents.x =OS.window_size.x
	$Area2D/CollisionShape2D2.shape.extents.x =OS.window_size.x
	$Area2D/CollisionShape2D.position.y = OS.window_size.y+300 
	$Area2D/CollisionShape2D2.position.y =-300
	$Area2D/CollisionShape2D.position.x = OS.window_size.x/2
	$Area2D/CollisionShape2D2.position.x =OS.window_size.x/2

func _on_Area2D_body_entered(body):
	if body.name == "Shaun":
		fade.get_node("AnimationPlayer").play("fadeIn")
		yield(fade.get_node("AnimationPlayer"),"animation_finished")
	# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
