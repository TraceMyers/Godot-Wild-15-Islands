extends Control

var path_levels= "res://src/levels"
var levels 
var pages =1

func _ready():
	levels = list_files_in_directory(path_levels)
	var w = 0
	for i in levels:
		var a =Button.new()
		a.text = i
		a.rect_min_size.y =50
		a.connect("pressed",self,"load_level",[a.text])
		
		if w >=25:
			a.hide()
		$VBoxContainer2/GridContainer.add_child(a)
		w+=1
	for i in 4: 
		if levels.size() >25*i and i !=0:
			pages+=1
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
func _process(delta):
	if pages>1:
		pass
	pass
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


func _on_Button3_pressed():
	$VBoxContainer2.hide()
	$VBoxContainer.show()
	pass # Replace with function body.


func _on_next_pressed():
	if pages>1:
		var i = 0
		var count = 0
		while i<pages:
			var pos =0
			for x in $VBoxContainer2/GridContainer.get_children():
				x.hide()
				pos +=1
				if pos>=25:
					break
			count =pos
			while count<$VBoxContainer2/GridContainer.get_children().size():
				$VBoxContainer2/GridContainer.get_children()[count].show()
				if count >= pos*2:
					break
				count+=1
			i+=1
	pass # Replace with function body.


func _on_pre_pressed():
	if pages>1:
		var i = 0
		var count = 0
		while i<pages:
			var pos =0
			for x in $VBoxContainer2/GridContainer.get_children():
				x.show()
				pos +=1
				if pos>=25:
					break
			count =pos
			while count<$VBoxContainer2/GridContainer.get_children().size():
				$VBoxContainer2/GridContainer.get_children()[count].hide()
				if count >= pos*2:
					break
				count+=1
			i+=1
	pass # Replace with function body.
