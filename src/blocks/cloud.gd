extends KinematicBody2D

func _ready():
	pass # Replace with function body.

func bounce():
	$AnimationPlayer.play("bounce")
	yield($AnimationPlayer,"animation_finished")

func _on_Area2D_body_entered(body):
	#$CollisionPolygon2D.set_disabled(false)
	get_node("CollisionPolygon2D").call_deferred("set_disabled",false)
	pass # Replace with function body.
