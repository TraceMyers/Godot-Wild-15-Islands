extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera
var timer
var amplitude =0
var priority = 0
const trans = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent()
	timer = get_node("frequency")
	pass # Replace with function body.

func start(Duration=0.2,Frequency=15,amplitude =16,priority =0):
	if self.priority <= priority:
		self.priority =priority
		self.amplitude=amplitude
		$duration.wait_time=Duration
		timer.wait_time =1/float(Frequency)
		$duration.start()
		timer.start()
		new_shake()
		pass
func new_shake():
	var rand =Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)
	$Tween.interpolate_property(camera,"offset",camera.offset,rand,timer.wait_time,trans,EASE)
	$Tween.start()


func restart():
	var rand =Vector2()
	rand.x = rand_range(-amplitude,amplitude)
	rand.y = rand_range(-amplitude,amplitude)
	$Tween.interpolate_property(camera,"offset",camera.offset,Vector2(),timer.wait_time,trans,EASE)
	$Tween.start()
	priority = 0

func _on_frequency_timeout():
	new_shake()
	pass # Replace with function body.


func _on_duration_timeout():
	restart()
	timer.stop()
	pass # Replace with function body.
