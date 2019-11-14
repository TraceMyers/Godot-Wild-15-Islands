extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_levels= "res://src/levels"
var levels 
# Called when the node enters the scene tree for the first time.
func _ready():
	levels = list_files_in_directory(path_levels)
	for i in levels:
		var a =Button.new()
		a.text = i
		a.connect("pressed",self,"load_level",[a.text])
		$VBoxContainer2/GridContainer.add_child(a)
	
	pass # Replace with function body.

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.get_extension() == "tscn":
			files.append(file)

	dir.list_dir_end()

	return files
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func call_level(level):
	Events.levels =levels
	fade.raise()
	fade.get_node("AnimationPlayer").play("fadeIn")
	
	yield(fade.get_node("AnimationPlayer"),"animation_finished")
	get_tree().current_scene.queue_free()
	get_tree().change_scene(path_levels+"/"+level)

	pass
func load_level(index):
	for i in levels:
		if i == index:
			call_level(i) 
func _on_Button_pressed():
	$VBoxContainer.hide()
	$VBoxContainer2.show()
	pass # Replace with function body.


func _on_Button2_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_back_pressed():
	$VBoxContainer2.hide()
	$VBoxContainer.show()
	pass # Replace with function body.
