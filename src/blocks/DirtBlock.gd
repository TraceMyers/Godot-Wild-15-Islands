extends KinematicBody2D

const MAX_Y_SPEED : float = 6.0
const GRAVITY : float = 0.3
const MAX_STACK_SIZE : int = 3
const BLOCK_HEIGHT : int = 32

var float_speed : float = 2.0
var velocity := Vector2()
var seeded : bool = false
var stack_size : int = 1
var shaun_y_offset : float = 440
var fan_push := Vector2.ZERO

func _enter_tree():
	set_physics_process(false)
	$SeedSprite.hide()
	$SeedBalloon.hide()

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
		position += Vector2(fan_push.x, fan_push.y - float_speed)
	fan_push = Vector2.ZERO	

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
	print("adding")
	float_speed -= 2.4
	shaun_y_offset -= BLOCK_HEIGHT
	$CollisionPolygon2D.scale.y += 1.0
	$CollisionPolygon2D.position.y -= BLOCK_HEIGHT / 2
	$DetectCeiling.position.y -= BLOCK_HEIGHT
	$SeedBalloon.position.y -= BLOCK_HEIGHT
	$SeedSprite.position.y -= BLOCK_HEIGHT
	stack_size += 1
	$SpriteStack.get_node("StackSize%s" % stack_size).show()

func remove_block_from_stack():
	if stack_size > 1:
		float_speed += 2.4
		shaun_y_offset += BLOCK_HEIGHT
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
