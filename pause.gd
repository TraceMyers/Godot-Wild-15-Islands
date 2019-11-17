extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	UserInput.connect("pause",self,"pause")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func pause():
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		get_tree().paused = true
		visible = true
	pass

func _on_Button_pressed():
	get_tree().paused = false
	visible = false
	pass # Replace with function body.


func _on_Button2_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://src/main/menu.tscn")
	pass # Replace with function body.


func _on_Button3_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.
