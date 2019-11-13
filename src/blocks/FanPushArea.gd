extends Area2D

const MAX_PUSH_SPEED : float = 3.0

var push_area_len : float
var fan_angle : float
var pushable_body_names : Array = [
	"Dirt",
	"Shaun",
	"Seed",
]

func _ready():
	push_area_len = $Sprite.texture.get_size().x * $Sprite.scale.x
	fan_angle = global_transform.get_rotation()
	print(push_area_len)
	set_physics_process(true)

func _process(delta):
	var bodies : Array = get_overlapping_bodies()
	# If it works, I'm happy
	for body in bodies:
		for pbn in pushable_body_names:
			var body_name = body.get_name()
			if pbn in body.get_name():
				var push : Vector2
				if body_name == "Shaun":
					var dirt_block = body.get_node("Shovel").get_block_underneath()
					if dirt_block != null and dirt_block.seeded:
						if dirt_block in bodies:
							push = _get_push(dirt_block)
						else:
							push = Vector2.ZERO	
					else:
						push = _get_push(body)
				elif "Dirt" in body_name and body.seeded:		
					push = _get_push(body)
					body.fan_push = push
				body.position += push

func _get_push(body):
	var distance = get_parent().position.distance_to(body.position)
	var norm_dist = distance / push_area_len
	var push_strength = 2.0 - norm_dist
	var push = log(pow(MAX_PUSH_SPEED * push_strength, 2))
	if push <= 0:
		return Vector2.ZERO
	return Vector2(cos(fan_angle) * push, sin(fan_angle) * push)

