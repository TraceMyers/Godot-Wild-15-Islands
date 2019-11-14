extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var object =null
var a
var f :bool =false
# Called when the node enters the scene tree for the first time.
func _ready():
	UserInput.connect("switch",self,"switch")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		
			
#	pass


func _on_Area2D_body_entered(body):
	if body.name == "Shaun":
		a = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body.name == "Shaun":
		a = false
	pass # Replace with function body.
