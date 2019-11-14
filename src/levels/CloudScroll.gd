extends Node2D

const bg_size := Vector2(2400, 1600)
const scroll_speed : float = 16.0

var bg := preload("res://src/background/CloudBG.tscn")
var tile_matrix : Array = []
var reset : bool = false
var total_size_x : float

func _ready():
	var lvl_bot_right = get_parent().boundary_bottom_right
	var tile_ct := Vector2(
		ceil(lvl_bot_right.x / bg_size.x) + 1.0,
		ceil(lvl_bot_right.y / bg_size.y)
	)
	var start_tiling_at := Vector2(-bg_size.x, 0.0)
	for i in range(tile_ct.x):
		tile_matrix.append([])
		for j in range(tile_ct.y):
			var new_tile := bg.instance()
			new_tile.position = Vector2(
				start_tiling_at.x + bg_size.x * i,
				start_tiling_at.y + bg_size.y * j
			)
			add_child(new_tile)
			tile_matrix[i].append(new_tile)
	total_size_x = tile_matrix.size() * bg_size.x		

func _process(delta):
	var new_scroll_x = position.x + scroll_speed * delta
	if new_scroll_x >= bg_size.x:
		position.x = bg_size.x - new_scroll_x
		reset = true
	elif reset:
		position.x = 0.0
		reset = false
	else:
		position.x = new_scroll_x

			
