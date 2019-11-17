extends Node2D

var hide_timer : Timer
var show_timer : Timer
var sprites : Array = []
var fading_out : bool = false
var fading_in : bool = false
var fade_speed : float = 0.01
var cur_alpha : float = 1
var cur : int = 0

func _ready():
	hide_timer = Timer.new()
	show_timer = Timer.new()
	hide_timer.one_shot = true
	show_timer.one_shot = true
	hide_timer.connect("timeout", self, "_time_to_hide")
	show_timer.connect("timeout", self, "_time_to_show")
	for sprite in get_children():
		sprites.append(sprite)
	add_child(hide_timer)
	add_child(show_timer)
	hide_timer.start(6.5)	


func _time_to_hide():
	fading_out = true

func _time_to_show():
	fading_in = true

func _process(delta):
	if cur <= 2:
		if fading_out:	
			cur_alpha -= fade_speed
			if cur_alpha > 0:
				sprites[cur].modulate = Color(1,1,1,cur_alpha)
			else:
				sprites[cur].hide()
				fading_out = false	
				cur_alpha = 0
				cur += 1
				show_timer.start(0.8)
		elif fading_in:		
			if cur_alpha <= 1:
				sprites[cur].modulate = Color(1,1,1,cur_alpha)
				if cur_alpha == 0:
					sprites[cur].show()
			else:		
				fading_in = false
				hide_timer.start(5)
			cur_alpha += fade_speed


