class_name RandomAudioPlayer2D extends AudioStreamPlayer2D

func play_random_audio_and_await_finished(audio_streams: Array[AudioStream] = []) -> void:
	if !audio_streams.is_empty():
		stream = audio_streams.pick_random()
	pitch_scale = randf_range(0.8, 1.2)
	play()
	await finished
