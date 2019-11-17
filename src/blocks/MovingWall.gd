extends KinematicBody2D

const MOVE_DIST : float = 148.0
const START_Y : float = -MOVE_DIST
const MOVE_SPEED : float = 100.0

var move : bool = false

func switch_action_do():
	move = true
func switch_action_undo():
	move = false

func _process(delta):
	if move and $Sprite.position.y < MOVE_DIST:
		$Sprite.position.y += MOVE_SPEED * delta
		$CollisionShape2D.position.y += MOVE_SPEED * delta
		if not Audio.sound_is_playing("rock_wall_move"):
			Audio.emit_signal("play_sound", "rock_wall_move")
	elif not move and $Sprite.position.y > START_Y:
		$Sprite.position.y -= MOVE_SPEED * delta	
		$CollisionShape2D.position.y -= MOVE_SPEED * delta	
		if not Audio.sound_is_playing("rock_wall_move"):
			Audio.emit_signal("play_sound", "rock_wall_move")