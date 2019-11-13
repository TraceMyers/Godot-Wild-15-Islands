extends KinematicBody2D

const ACCELERATION : float = 25.0
const DECELERATION : float = 0.7
const MAX_X_SPEED : float = 200.0
const MIN_X_SPEED : float = 8.0
const INIT_JUMP_SPEED : float = -440.0
const MAX_Y_SPEED : float = 1000.0
const GRAVITY : float = 24.0
const CREATE_BLOCK_MOVE : float = -80.0

var hard_land : bool = false
var velocity := Vector2()
var move_x_input : bool = false
var jump_input : bool = false
var jump_higher : bool = false
var facing_right = false

func _ready():
	UserInput.connect("move_x", self, "_UserInput_move_x")
	UserInput.connect("jp_jump", self, "_UserInput_init_jump")
	UserInput.connect("jump", self, "_UserInput_jump_higher")
	UserInput.connect("jp_dig", self, "_UserInput_dig")
	UserInput.connect("jp_place_block", self, "_UserInput_place_block")
	UserInput.connect("jp_plant", self, "_UserInput_plant")

func _physics_process(delta):
	var dirt_block = $Shovel.get_block_underneath()
	if dirt_block != null and dirt_block.seeded:
		#reparent
		pass
	if velocity.y >= MAX_Y_SPEED :
		hard_land = true
	if $DetectFloor.on_floor():
		velocity.y = 0.0
		if hard_land:
			hard_land = false
			hard_land()
		if jump_input:
			velocity.y = INIT_JUMP_SPEED
		if not move_x_input:
			velocity.x = int(velocity.x * DECELERATION)
			if abs(velocity.x) < MIN_X_SPEED:
				velocity.x = 0.0
	elif velocity.y < MAX_Y_SPEED:		
		if jump_higher:
			velocity.y += GRAVITY * 0.5 
		elif not is_on_floor():	
			velocity.y += GRAVITY 
	move_and_slide_with_snap(velocity, Vector2(0.0, -1.0))
	move_x_input = false	
	jump_input = false
	jump_higher = false

func _UserInput_move_x(dir,facing):
	facing_right = facing
	if is_on_wall():
		velocity.x /= 2.0
	if abs(velocity.x) < MAX_X_SPEED or sign(velocity.x) != dir:
		velocity.x += dir * ACCELERATION
	move_x_input = true

func _UserInput_init_jump():
	jump_input = true

func _UserInput_jump_higher():
	if not is_on_floor() and velocity.y < 0:
		jump_higher = true

func _UserInput_dig():
	var dirt_block = $Shovel.get_block_underneath()
	if dirt_block != null:
		if $Inventory.full("dirt_block"):
			#anim
			pass
		else:	
			$Inventory.add("dirt_block", 1)
			print("(Add) Dirt Blocks: " + String($Inventory.count("dirt_block")))
		if dirt_block.seeded and dirt_block.stack_size == 1:
			$Inventory.add("seed", 1)	
			print("(Add) Seeds: " + String($Inventory.count("seed")))
		dirt_block.remove_block_from_stack()
		$Camera2D/shake.start()

func _UserInput_place_block():
	if $Inventory.empty("dirt_block"):
		#anim
		pass
	else:
		var player_pos_change = Vector2(0.0, CREATE_BLOCK_MOVE)
		if _block_place_ok(player_pos_change):
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
	if dirt_block != null and dirt_block.seeded and not dirt_block.stack_full():
		dirt_block.add_block_to_stack()
	else:	
		Events.emit_signal(
			"create",
			"dirt_block", 
			position + $PlaceBlock.position, 
			"FreeBlocks",
			true
		)
	position += player_pos_change
	velocity.y /= 5.0
	velocity.x /= 3.0
	$Inventory.remove("dirt_block")
	print("(Rem) Dirt Blocks: " + String($Inventory.count("dirt_block")))

func _UserInput_plant():
	var dirt_block = $Shovel.get_block_underneath()
	if dirt_block != null:
		if dirt_block.seeded and not $Inventory.full("seed"):
			dirt_block.remove_seed()
			$Inventory.add("seed", 1)
			print("(Add) Seeds: " + String($Inventory.count("seed")))
		elif not dirt_block.seeded and not $Inventory.empty("seed"):	
			dirt_block.plant_seed()
			$Inventory.remove("seed")
			print("(Rem) Seeds: " + String($Inventory.count("seed")))
		else:
			#anim
			pass	

func hard_land():
	_UserInput_dig()
	$Camera2D/shake.start()
	#adding animation or particles
	pass
