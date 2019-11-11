extends KinematicBody2D

const MAX_Y_SPEED : float = 800.0
const GRAVITY : float = 24.0
const MAX_STACK_SIZE : int = 4

var float_speed : float = 2.0
var velocity := Vector2()
var seeded : bool = false
var stack_size : int = 1

func _enter_tree():
	set_physics_process(false)
	$SeedSprite.hide()
	$SeedBalloon.hide()

func _physics_process(delta):
	if not seeded:
		if velocity.y < MAX_Y_SPEED:		
			if not is_on_floor():	
				velocity.y += GRAVITY		
			else:
				velocity.y = 1.0
		move_and_slide(velocity, Vector2(0.0, -1.0))
	elif (float_speed > 0 and not $DetectCeiling.float_collision(self, -1)) \
		or (float_speed < 0 and not $DetectFloor.float_collision(self, 1)):
		position.y -= float_speed


func plant_seed():
	$SeedSprite.show()
	$SeedBalloon.show()
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
	# very temp
	position.y -= 32.0
	scale.y += 1
	stack_size += 1
	float_speed -= 1.005

func remove_block_from_stack():
	# very temp
	position.y += 32.0
	stack_size -= 1
	if stack_size == 0:
		queue_free()
	scale.y -= 1
	float_speed += 1.005