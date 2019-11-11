extends KinematicBody2D

const ACCELERATION : float = 25.0
const DECELERATION : float = 0.7
const MAX_X_SPEED : float = 200.0
const MIN_X_SPEED : float = 8.0
const INIT_JUMP_SPEED : float = -440.0
const MAX_Y_SPEED : float = 800.0
const GRAVITY : float = 24.0

var dirt_block_prefab = preload("res://src/blocks/DirtBlock.tscn")
var dirt_block_ref_height
var velocity := Vector2()
var move_x_input : bool = false
var jump_input : bool = false
var jump_higher : bool = false

func _ready():
	var dirt_block_ref = dirt_block_prefab.instance()
	dirt_block_ref_height = dirt_block_ref.get_node("Sprite").texture.get_size()[1]
	dirt_block_ref.queue_free()
	Events.connect("move_x", self, "_Events_move_x")
	Events.connect("jp_jump", self, "_Events_init_jump")
	Events.connect("jump", self, "_Events_jump_higher")
	Events.connect("jp_dig", self, "_Events_dig")
	Events.connect("jp_place_block", self, "_Events_place_block")
	Events.connect("jp_plant", self, "_Events_plant")

func _physics_process(delta):
	if velocity.y < MAX_Y_SPEED:		
		if jump_higher:
			velocity.y += GRAVITY * 0.5
		elif not is_on_floor():	
			velocity.y += GRAVITY		
		else:
			# forces player into floor, making is_on_floor() checks work
			velocity.y = 1 
	if is_on_floor():
		if jump_input:
			velocity.y = INIT_JUMP_SPEED
		if not move_x_input:
			velocity.x = int(velocity.x * DECELERATION)
			if abs(velocity.x) < MIN_X_SPEED:
				velocity.x = 0.0
	move_x_input = false	
	jump_input = false
	jump_higher = false
	move_and_slide(velocity, Vector2(0.0, -1.0))

func _get_dirt_block_underneath():
	pass
	
func _Events_move_x(dir):
	if is_on_wall():
		velocity.x /= 2.0
	if abs(velocity.x) < MAX_X_SPEED or sign(velocity.x) != dir:
		velocity.x += dir * ACCELERATION
	move_x_input = true

func _Events_init_jump():
	jump_input = true

func _Events_jump_higher():
	if not is_on_floor() and velocity.y < 0:
		jump_higher = true

func _Events_dig():
	# dirt_block destroy anim
	var objects_underneath = $Shovel.get_overlapping_bodies()
	if objects_underneath.size() > 0:
		var dirt_block = null
		for object in objects_underneath:
			if "DirtBlock" in object.get_name():
				dirt_block = object
		if dirt_block != null:		
			dirt_block.queue_free()
			if $Inventory.full("dirt_block"):
				# full inventory failure anim
				pass
			else:	
				# store in inventory success anim
				$Inventory.add("dirt_block")
				print("(Add) Dirt Blocks: " + String($Inventory.count("dirt_block")))

func _Events_place_block():
	if $Inventory.empty("dirt_block"):
		# empty inventory failure anim
		pass
	else:		
		var new_pos_change = Vector2(0.0, -dirt_block_ref_height - 30.0)
		var self_collision = move_and_collide(new_pos_change, true, true, true)
		var block_collisions : Array = [
			move_and_collide(Vector2(-16.0, 0.0), true, true, true),
			move_and_collide(Vector2(16.0, 0.0), true, true, true),
			move_and_collide(Vector2(-16.0, -16.0), true, true, true),
			move_and_collide(Vector2(16.0, -16.0), true, true, true),
		]
		var block_collide : bool = false
		for collis in block_collisions:
			if collis != null:
				block_collide = true
		if self_collision != null or block_collide:
			# placement failure anim
			pass
		else: 	
			# placement success anim
			var dirt_block = dirt_block_prefab.instance()
			dirt_block.position = Vector2(position.x, position.y - 8.0)
			position += new_pos_change
			velocity.y /= 5.0
			velocity.x /= 3.0
			get_parent().get_node("FreeBlocks").add_child(dirt_block)
			$Inventory.remove("dirt_block")
			print("(Rem) Dirt Blocks: " + String($Inventory.count("dirt_block")))

func _Events_plant():
	pass