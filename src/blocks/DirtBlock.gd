extends KinematicBody2D

const MAX_Y_SPEED : float = 800.0
const GRAVITY : float = 24.0
const MAX_STACK_SIZE : int = 3
const BLOCK_HEIGHT : int = 32

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
	# meh
	float_speed -= 2.4
	$CollisionPolygon2D.scale.y += 1.0
	$CollisionPolygon2D.position.y -= BLOCK_HEIGHT / 2
	$DetectCeiling.position.y -= BLOCK_HEIGHT
	$SeedBalloon.position.y -= BLOCK_HEIGHT
	$SeedSprite.position.y -= BLOCK_HEIGHT
	stack_size += 1
	$SpriteStack.get_node("StackSize%s" % stack_size).show()


func remove_block_from_stack():
	# meh
	if stack_size > 1:
		float_speed += 2.4
		$CollisionPolygon2D.scale.y -= 1.0
		$CollisionPolygon2D.position.y += BLOCK_HEIGHT / 2
		$DetectCeiling.position.y += BLOCK_HEIGHT
		$SeedBalloon.position.y += BLOCK_HEIGHT
		$SeedSprite.position.y += BLOCK_HEIGHT
		$SpriteStack.get_node("StackSize%s" % stack_size).hide()
		stack_size -= 1
	else:
		queue_free()	

func _on_DetectCeiling_body_entered(body):
	if "cloud" in body.name:
		body.get_node("CollisionPolygon2D").call_deferred("set_disabled",true)
	pass # Replace with function body.
