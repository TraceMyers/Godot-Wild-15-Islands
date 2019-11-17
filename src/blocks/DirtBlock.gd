extends KinematicBody2D

const MAX_Y_SPEED : float = 6.0
const GRAVITY : float = 0.3
const MAX_STACK_SIZE : int = 3
const BLOCK_HEIGHT : int = 64
const INIT_FLOAT_SPEED : float = 2.0

var float_speed : float = INIT_FLOAT_SPEED
var velocity := Vector2()
var seeded : bool = false
var stack_size : int = 1
var shaun_y_offset : float = 440
var fan_push := Vector2.ZERO
var shaun_collis : bool = false
var rand_push : Vector2
var rand_push_timer : Timer
var rand_push_away : bool = false

func _enter_tree():
	set_physics_process(false)
	$SeedSprite.hide()
	$SeedBalloon.hide()

func _ready():
	rand_push_timer = Timer.new()
	rand_push_timer.connect("timeout", self, "_generate_new_rand_push")
	add_child(rand_push_timer)
	rand_push_timer.set_wait_time(1.5)
	rand_push_timer.start()

func _physics_process(delta):
	if not seeded:
		if not $DetectFloor.float_collision(self, 1):
			if velocity.y < MAX_Y_SPEED:
				velocity.y += GRAVITY 
		else:
			velocity.y = 0.0
		position += velocity + fan_push
	elif (float_speed > 0 and not $DetectCeiling.float_collision(self, -1)) \
		or (float_speed < 0 and not $DetectFloor.float_collision(self, 1)):
		if not shaun_collis:
			position += Vector2(fan_push.x, fan_push.y - float_speed) + rand_push
	elif float_speed == 0 and not $DetectCeiling.float_collision(self, -1) and not $DetectFloor.float_collision(self, 1):
		position += Vector2(fan_push.x, fan_push.y) + rand_push
	else:
		rand_push = Vector2.ZERO	
	fan_push = Vector2.ZERO	
	shaun_collis = false

func _generate_new_rand_push():
	if rand_push_away:
		rand_push = Vector2((randf() - 0.5) / 4, (randf() - 0.5) / 4)
		rand_push_away = false
	else:
		rand_push *= -1
		rand_push_away = true
	rand_push_timer.start()	


func plant_seed():
	$SeedSprite.show()
	$SeedBalloon.show()
	$SeedBalloon/AnimationPlayer.play("Grow")
	set_physics_process(true)
	velocity.y = 0.0
	seeded = true

func remove_seed():
	$SeedSprite.hide()
	$SeedBalloon.hide()
	seeded = false

func stack_full():
	return stack_size >= MAX_STACK_SIZE

func stack_empty():
	return stack_size <= 0

func add_block_to_stack():
	print("adding")
	float_speed -= INIT_FLOAT_SPEED
	scale += Vector2(0.65, 0.65)
	stack_size += 1

func remove_block_from_stack():
	if stack_size > 1:
		float_speed += INIT_FLOAT_SPEED
		scale -= Vector2(0.65, 0.65)
		stack_size -= 1
		return true
	else:
		if seeded:
			Events.emit_signal(
				"create",
				"seed_balloon_pop",
				position,
				"DirtBlocks",
				false,
				0.5
			)
		Events.emit_signal(
			"create", 
			"dirt_block_destroy_anim", 
			position, 
			"DirtBlocks", 
			false
		)
		queue_free()	
		return false

func _on_DetectCeiling_body_entered(body):
	if "cloud" in body.name:
		body.get_node("CollisionPolygon2D").call_deferred("set_disabled",true)
	pass # Replace with function body.
