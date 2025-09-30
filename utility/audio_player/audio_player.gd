extends Node

const STARTING_VOLUME_DB := -7.0

var master_volume := STARTING_VOLUME_DB
var music_volume := STARTING_VOLUME_DB
var sfx_volume := STARTING_VOLUME_DB

enum Bus {
	MASTER,
	MUSIC,
	SFX
}

func play_sound(sound: Resource, vary_pitch := true, bus: Bus = Bus.SFX, loop := false) -> void:
	var audioPlayer = AudioStreamPlayer.new()
	match bus:
		Bus.MASTER:
			audioPlayer.bus = "Master"
		Bus.MUSIC:
			audioPlayer.bus = "Music"
		Bus.SFX:
			audioPlayer.bus = "Sfx"
	add_child(audioPlayer)
	audioPlayer.finished.connect(func():
		if loop:
			play_sound(sound, vary_pitch, bus, loop)
		audioPlayer.queue_free()
	)
	audioPlayer.stream = sound
	if vary_pitch:
		audioPlayer.pitch_scale = randf_range(.9, 1.1)
	audioPlayer.play()
	
func set_volume(master: float, music: float, sfx: float):
	master_volume = master
	music_volume = music
	sfx_volume = sfx

func reset():
	for child in get_children():
		child.queue_free()
	
