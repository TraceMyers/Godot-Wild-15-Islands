extends Node2D

const gravity := Vector2 (0, 3.0)
const largest_scale_x : float = 0.165166

var forces : Array = []
var sprites : Array = []
var delete_timer : Timer

func _ready():
	for sprite in $Sprites.get_children():
		sprites.append(sprite)
		forces.append(Vector2(0.0, 1.3) + sprite.position * (1 - (sprite.scale.x / largest_scale_x)) / 8)
	delete_timer = Timer.new()	
	add_child(delete_timer)
	delete_timer.connect("timeout", self, "_delete_self")
	delete_timer.start(1.0)
			
func _process(delta):
	position.y -= 2
	for i in sprites.size():
		var sprite = sprites[i]
		var sprite_alpha = sprite.modulate[3]
		sprite.modulate = Color(1, 1, 1, sprite_alpha*0.95)
		sprite.position += forces[i]
		forces[i] += gravity * delta

func _delete_self():
	queue_free()
