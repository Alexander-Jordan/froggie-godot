class_name UIAudioPlayer
extends AudioStreamPlayer

@export var audio_button_pressed:AudioStream

func play_audio(audio:AudioStream):
	stream = audio
	pitch_scale = randf_range(0.8, 1.2)
	play()
	await finished

func button_pressed():
	await play_audio(audio_button_pressed)
