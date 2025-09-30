extends Node

enum Bus {
	MASTER,
	MUSIC,
	SFX
}

func play_sound(sound: Resource, vary_pitch := true, bus: Bus = Bus.SFX, loop := false) -> void:
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.bus
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

func reset():
	for child in get_children():
		child.queue_free()
	
	
