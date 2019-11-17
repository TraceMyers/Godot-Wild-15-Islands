extends Node

const path : String = "res://assets/sounds/"
var sound_name_to_player : Dictionary = {}

signal play_sound

func _ready():
	connect("play_sound", self, "_play_sound")
	var audio_dir := Directory.new()
	if audio_dir.open(path) == OK:
		audio_dir.list_dir_begin()
		var audio_file_name = audio_dir.get_next()
		while audio_file_name != "":
			if audio_file_name.ends_with(".wav"):
				var name_no_ext = audio_file_name.substr(0, audio_file_name.length()-4)
				var new_player = AudioStreamPlayer.new()
				add_child(new_player)
				new_player.set_bus(name_no_ext)
				new_player.stream = load(path + audio_file_name)
				sound_name_to_player[name_no_ext] = new_player
				print("filename: " + audio_file_name)
				print("bus: " + name_no_ext)
			audio_file_name = audio_dir.get_next()

func _play_sound(sound_name):
	sound_name_to_player[sound_name].play()

func sound_is_playing(sound_name):
	return sound_name_to_player[sound_name].is_playing()
