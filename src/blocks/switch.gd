extends Node2D

export (PackedScene) var object =null
var a
var f :bool =false

func _ready():
	UserInput.connect("switch",self,"switch")

func switch():
	if a:
		var s =get_tree().get_nodes_in_group("switch_inst")
		for i in s:
			var x =i.get_children()
			for z in x:
				z.queue_free()
		if f:
			f=false
			return
		print(s)
		
		for i in s:
			i.add_child(object.instance())
			f = true
		
func _on_Area2D_body_entered(body):
	if body.name == "Shaun" or "DirtBlock" in body.name:
		$Sprite.position.y = 20.0
		a = true

func _on_Area2D_body_exited(body):
	if body.name == "Shaun" or "DirtBlock" in body.name:
		$Sprite.position.y = 0.0
		a = false
