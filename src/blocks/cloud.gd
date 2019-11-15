extends KinematicBody2D

func _ready():
	pass # Replace with function body.

func bounce():
	$AnimationPlayer.play("bounce")
	yield($AnimationPlayer,"animation_finished")

func _on_Area2D_body_entered(body):
	
	#$CollisionPolygon2D.set_disabled(false)
	if body.name == "Shaun" :
		get_node("CollisionPolygon2D").call_deferred("set_disabled",false)
	pass # Replace with function body.

func _on_Area2D2_body_entered(body):
	#$CollisionPolygon2D.set_disabled(true)
	if body.name == "Shaun" :
		get_node("CollisionPolygon2D").call_deferred("set_disabled",true)
	pass # Replace with function body.
