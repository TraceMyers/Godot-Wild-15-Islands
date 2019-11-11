extends KinematicBody2D

const MAX_Y_SPEED : float = 800.0
const GRAVITY : float = 24.0

var velocity := Vector2()
var seeded : bool = false

func _ready():
	$SeedSprite.hide()
	$SeedBalloon.hide()

func _physics_process(delta):
	velocity.x = 0.0
	if velocity.y < MAX_Y_SPEED:		
		if not is_on_floor():	
			velocity.y += GRAVITY		
		else:
			velocity.y = 1.0
	move_and_slide(velocity, Vector2(0.0, -1.0))

func seed():
	$SeedSprite.show()
	$SeedBalloon.show()
