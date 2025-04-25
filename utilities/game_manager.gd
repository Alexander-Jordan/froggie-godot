class_name GameManager extends Node

enum State {
	NEW,
	PLAYING,
	OVER,
	WIN,
}

const LILYPADS: int = 5

var lilypads_occupied: int = 0:
	set(lo):
		if lo < 0 or lo > LILYPADS or lo == lilypads_occupied:
			return
		lilypads_occupied = lo
		if lo == LILYPADS:
			state = State.WIN
		else:
			next_frog.emit(true)
var state: State = State.NEW:
	set(s):
		if s == state or !State.values().has(s):
			return
		state = s
		state_changed.emit(state)
		match s:
			State.NEW, State.PLAYING:
				SS.stats.score = 0

signal next_frog(previous_safe: bool)
signal state_changed(state: State)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('dev_state_new'):
		state = State.NEW
	if event.is_action_pressed('dev_state_playing'):
		state = State.PLAYING
	if event.is_action_pressed('dev_state_over'):
		state = State.OVER
	if event.is_action_pressed('dev_state_win'):
		state = State.WIN
