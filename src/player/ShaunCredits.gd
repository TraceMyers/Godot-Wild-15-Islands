extends KinematicBody2D

const ACCELERATION : float = 25.0
const DECELERATION : float = 0.7
const MAX_X_SPEED : float = 200.0
const MIN_X_SPEED : float = 8.0
const INIT_JUMP_SPEED : float = -440.0
const MAX_Y_SPEED : float = 1000.0
const GRAVITY : float = 24.0
const CREATE_BLOCK_MOVE : float = -66.0

var dir = Vector2()
var dir_x : float = -1.0
var velocity := Vector2()
var move_x_input : bool = false
var jump_input : bool = false
var jump_higher : bool = false
var facing_right = false
var SPEED = 1000

func _physics_process(delta):
	var d_block = $Shovel.get_block_underneath()
	if d_block != null:
		if $DetectCeil.colliding("up"):
			d_block.shaun_collis = true
		if d_block.seeded:
			position += d_block.rand_push
			position.y -= d_block.float_speed
	if $DetectFloor.colliding():
		velocity.y = 0.0
		if abs(velocity.x) <= 0.1:
			$Sprite/AnimationPlayer.play("idle")	
		else:
			$Sprite/AnimationPlayer.play("Run")	
		if jump_input:
			$Sprite/AnimationPlayer.play("Jump")
			velocity.y = INIT_JUMP_SPEED
		if not move_x_input:
			velocity.x = int(velocity.x * DECELERATION)
			if abs(velocity.x) < MIN_X_SPEED:
				velocity.x = 0.0
	elif velocity.y < MAX_Y_SPEED:		
		if jump_higher:
			velocity.y += GRAVITY * 0.47 
		elif not is_on_floor():	
			velocity.y += GRAVITY 
	if velocity.y > 0.0:
		$Sprite/AnimationPlayer.play("Fall")		
	move_and_slide_with_snap(velocity, Vector2(0.0, -1.0))
	move_x_input = false	
	jump_input = false
	jump_higher = false
