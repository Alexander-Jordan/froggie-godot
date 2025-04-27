class_name UIGame extends Control

@export var audio_stream_playing: AudioStream
@export var score_max: int = 10000
@export var time_max: float = 30.0

@onready var button_start: Button = $VBoxContainer/Control/menu_start/button_start
@onready var label_best: Label = $VBoxContainer/HBoxContainer/HBoxContainer3/label_best
@onready var label_frogs: Label = $VBoxContainer/HBoxContainer/HBoxContainer/label_frogs
@onready var label_score: Label = $VBoxContainer/HBoxContainer/HBoxContainer2/label_score
@onready var label_start: Label = $VBoxContainer/Control/menu_start/label_start
@onready var label_time: Label = $VBoxContainer/HBoxContainer/HBoxContainer4/label_time
@onready var menu_start: VBoxContainer = $VBoxContainer/Control/menu_start
@onready var ui_audio_player: UIAudioPlayer = $UIAudioPlayer

var score_current: int = score_max
var time_current: float = time_max
var time_is_ticking: bool = false

func reset_time() -> void:
	time_current = time_max
	score_current = score_max

func _process(delta: float) -> void:
	if GM.state != GM.State.PLAYING or time_current <= 0:
		return
	
	time_current -= delta
	time_current = maxf(time_current, 0.0) # don't go past 0.0
	score_current = floori((time_current / time_max) * score_max)
	label_time.text = "%05d" % score_current

func _ready() -> void:
	label_best.text = "%05d" % SS.stats.highscore
	label_frogs.text = "%d" % GM.frogs
	label_score.text = "%05d" % SS.stats.score
	label_time.text = "%05d" % score_current
	
	button_start.pressed.connect(func(): GM.state = GM.State.PLAYING)
	GM.frogs_changed.connect(func(frogs: int): label_frogs.text = "%d" % GM.frogs)
	GM.lilypad_reached.connect(func(): SS.stats.score += score_current)
	GM.next_frog.connect(reset_time)
	GM.state_changed.connect(func(state: GM.State):
		match state:
			GM.State.PLAYING:
				ui_audio_player.play_audio(audio_stream_playing)
				menu_start.visible = false
				reset_time()
			GM.State.OVER:
				label_start.text = 'GAME OVER'
				button_start.text = 'RESTART'
				menu_start.visible = true
	)
	SS.stats.new_highscore.connect(func(highscore: int): label_best.text = "%05d" % highscore)
	SS.stats.score_changed.connect(func(score: int): label_score.text = "%05d" % score)
