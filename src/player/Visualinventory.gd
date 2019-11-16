extends Node2D

const MAX_DISTANCE : float = 3.0
const SPEED : float = 3.0

var sprites : Array = []
var center_position_ys : Array = []
var directions : Array = []
var cur_block_ct : int = 0

onready var target_pos_x : float = position.x

func _ready():
	var vary_sign : int = -1
	Events.connect("player_change_dir", self, "_Events_player_change_dir")
	Events.connect("store_block", self, "_Events_store_block")
	Events.connect("put_block", self, "_Events_put_block")
	Events.connect("seed_pickup", self, "_Events_seed_pickup")
	Events.connect("seed_plant", self, "_Events_seed_plant")
	for sprite in get_children():
		sprites.append(sprite)
		center_position_ys.append(sprite.position.y)
		directions.append(vary_sign)
		vary_sign *= -1

func _process(delta):
	for i in sprites.size():
		var dir = directions[i]
		var center_y = center_position_ys[i]
		var new_y = sprites[i].position.y + dir * SPEED * delta
		sprites[i].position.y = new_y
		if abs(new_y - center_y) >= MAX_DISTANCE:
			directions[i] *= -1
		if abs(position.x - target_pos_x) > 0.005:
			position.x += (target_pos_x - position.x) * 0.85 * delta

func _Events_player_change_dir():
	target_pos_x *= -1	

func _Events_store_block():
	cur_block_ct += 1
	get_node("Block%s" % String(cur_block_ct)).show()

func _Events_put_block():
	get_node("Block%s" % String(cur_block_ct)).hide()
	cur_block_ct -= 1

func _Events_seed_pickup():
	$Seed.show()

func _Events_seed_plant():
	$Seed.hide()