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
var climbing = false
var hard_land : bool = false
var velocity := Vector2()
var move_x_input : bool = false
var jump_input : bool = false
var jump_higher : bool = false
var facing_right = false
var SPEED = 1000
var in_air : bool = false

func _ready():
	UserInput.connect("move_x", self, "_UserInput_move_x")
	UserInput.connect("jp_jump", self, "_UserInput_init_jump")
	UserInput.connect("jump", self, "_UserInput_jump_higher")
	UserInput.connect("jp_dig", self, "_UserInput_dig")
	UserInput.connect("jp_place_block", self, "_UserInput_place_block")
	UserInput.connect("jp_plant", self, "_UserInput_plant")
	UserInput.connect("ladder_dir",self,"ladder_input")
	Events.connect("seed_pickup", self, "_Events_seed_pickup")
	Events.connect("fork_block_destroy", self, "_Events_fork_block_destroy")

func _physics_process(delta):
	if climbing:
		ladder_move(delta)
		return
	var d_block = $Shovel.get_block_underneath()
	if d_block != null:
		if $DetectCeil.colliding("up"):
			d_block.shaun_collis = true
		if d_block.seeded:
			position += d_block.rand_push
			position.y -= d_block.float_speed
	if velocity.y >= 850:
		hard_land = true
	elif velocity.y > 200:
		in_air = true	
	if $DetectFloor.colliding():
		velocity.y = 0.0
		if in_air:
			in_air = false
			Audio.emit_signal("play_sound", "landing")
		if hard_land:
			hard_land = false
			hard_land()
		elif abs(velocity.x) <= 0.1:
			if $Sprite/AnimationPlayer.current_animation != "Plant":
				$Sprite/AnimationPlayer.play("idle")	
		elif $Sprite/AnimationPlayer.current_animation != "Plant":
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

func _UserInput_move_x(dir,facing):
	if dir_x != dir:
		Events.emit_signal("player_change_dir")
		dir_x = dir
	facing_right = facing
	if dir == 1:
		$Sprite.set_flip_h(true)
	else:
		$Sprite.set_flip_h(false)	
	if is_on_wall():
		velocity.x /= 2.0
	if abs(velocity.x) < MAX_X_SPEED or sign(velocity.x) != dir:
		velocity.x += dir * ACCELERATION
	move_x_input = true

func _UserInput_init_jump():
	Audio.emit_signal("play_sound", "jump")
	jump_input = true

func _UserInput_jump_higher():
	if not is_on_floor() and velocity.y < 0:
		jump_higher = true

func _UserInput_dig():
	if climbing:
		return
	var dirt_block = $Shovel.get_block_underneath()
	if dirt_block != null:
		if $Inventory.full("dirt_block"):
			#anim
			pass
		else:	
			Events.emit_signal("store_block")
			$Inventory.add("dirt_block", 1)
			print("(Add) Dirt Blocks: " + String($Inventory.count("dirt_block")))
		if dirt_block.seeded and dirt_block.stack_size == 1:
			if $Inventory.add("seed", 1):
				Events.emit_signal("seed_pickup")
				print("(Add) Seeds: " + String($Inventory.count("seed")))
		dirt_block.remove_block_from_stack()
		Audio.emit_signal("play_sound", "shovel")
		$Camera2D/shake.start()

func _UserInput_place_block():
	if climbing:
		return
	if $Inventory.empty("dirt_block"):
		#anim
		pass
	else:
		var player_pos_change = Vector2(0.0, CREATE_BLOCK_MOVE)
		if _block_place_ok(player_pos_change):
			Events.emit_signal("put_block")
			_create_block_and_move(player_pos_change)
		else: 	
			#anim
			pass
			
func _block_place_ok(player_pos_change):
	var dirt_block = $Shovel.get_block_underneath()
	var self_collision = move_and_collide(player_pos_change, true, true, true) != null
	var place_block_collisions = $PlaceBlock.get_overlapping_bodies()
	var count = place_block_collisions.size()
	for item in place_block_collisions:
		if item == self:
			count -= 1
		if dirt_block != null and dirt_block.seeded and item == dirt_block:
			count -= 1	
	return not self_collision and count <= 0

func _create_block_and_move(player_pos_change):
	var dirt_block = $Shovel.get_block_underneath()
	Audio.emit_signal("play_sound", "dirt_thump")
	if dirt_block != null and dirt_block.seeded and not dirt_block.stack_full():
		dirt_block.add_block_to_stack()
	else:	
		Events.emit_signal(
			"create",
			"dirt_block", 
			position + $PlaceBlock.position, 
			"DirtBlocks",
			true
		)
	position += player_pos_change
	velocity.y /= 5.0
	velocity.x /= 3.0
	$Inventory.remove("dirt_block")
	print("(Rem) Dirt Blocks: " + String($Inventory.count("dirt_block")))

func _UserInput_plant():
	if climbing:
		return
	var dirt_block = $Shovel.get_block_underneath()
	if dirt_block != null:
		if dirt_block.seeded and not $Inventory.full("seed"):
			dirt_block.remove_seed()
			$Sprite/AnimationPlayer.play("Plant")
			$Inventory.add("seed", 1)
			print("(Add) Seeds: " + String($Inventory.count("seed")))
			Events.emit_signal("seed_pickup")
		elif not dirt_block.seeded and not $Inventory.empty("seed"):	
			dirt_block.plant_seed()
			$Sprite/AnimationPlayer.play("Plant")
			$Inventory.remove("seed")
			print("(Rem) Seeds: " + String($Inventory.count("seed")))
			Events.emit_signal("seed_plant")
		else:
			#anim
			pass	

func hard_land():
	_UserInput_dig()
	$Camera2D/shake.start()
	#adding animation or particles
	pass

func ladder_input(move):
	dir = move
	pass

func ladder_move(delta):
	print(velocity)
	dir.x=dir.normalized().x
	velocity= dir * SPEED * delta
	velocity *= 6

	velocity=move_and_slide(velocity,Vector2(0,0))
	if jump_higher:
		velocity.y = -1000
		jump_higher =false
	dir = Vector2(0,0)
	pass

func _on_ladder_body_entered(body):
	if body.name == "Shaun":
		climbing = true
	pass # Replace with function body.


func _on_ladder_body_exited(body):
	if body.name == "Shaun":
		climbing = false
	pass # Replace with function body.

func _Events_seed_pickup():
	$Inventory.add("seed", 1)

func _Events_fork_block_destroy():
	if not $Inventory.full("dirt_block"):
		Events.emit_signal("store_block")
		$Inventory.add("dirt_block", 1)
		print("(Add) Dirt Blocks: " + String($Inventory.count("dirt_block")))