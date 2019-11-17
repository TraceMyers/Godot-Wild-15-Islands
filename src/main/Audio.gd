extends Node

const path : String = "res://assets/sounds/"
var sound_name_to_player : Dictionary = {
	"balloon_inflate": load("res://assets/sounds/balloon_inflate.wav"),
	"balloon_pop": load("res://assets/sounds/balloon_pop.wav"),
	"dirt_crumble": load("res://assets/sounds/dirt_crumble.wav"),
	"dirt_thump": load("res://assets/sounds/dirt_thump.wav"),
	"fan": load("res://assets/sounds/fan.wav"),
	"jump": load("res://assets/sounds/jump.wav"),
	"landing": load("res://assets/sounds/landing.wav"),
	"music": load("res://assets/sounds/music.ogg"),
	"open_door": load("res://assets/sounds/open_door.wav"),
	"rock_wall_move": load("res://assets/sounds/rock_wall_move.wav"),
	"seed_pickup": load("res://assets/sounds/seed_pickup.wav"),
	"shovel": load("res://assets/sounds/shovel.wav"),
	"unlock_door": load("res://assets/sounds/unlock_door.wav"),
	"wind1": load("res://assets/sounds/wind1.wav"),
	"wind2": load("res://assets/sounds/wind2.wav"),
}

signal play_sound

func _ready():
	connect("play_sound", self, "_play_sound")
	for key in sound_name_to_player.keys():
		var new_player = AudioStreamPlayer.new()
		add_child(new_player)
		new_player.set_bus(key)
		new_player.stream = sound_name_to_player[key]
		sound_name_to_player[key] = new_player
		if key == "music":
			new_player.play()

func _play_sound(sound_name):
	sound_name_to_player[sound_name].play()

func sound_is_playing(sound_name):
	return sound_name_to_player[sound_name].is_playing()
