class_name GameManager extends Node

enum State {
	NEW,
	PLAYING,
	OVER,
}

const FROGS: int = 5

var frogs: int = 5:
	set(f):
		if f < 0 or f > FROGS or f == frogs:
			return
		frogs = f
		frogs_changed.emit(frogs)
		if f == 0:
			state = State.OVER
		else:
			next_frog.emit()
var state: State = State.NEW:
	set(s):
		if s == state or !State.values().has(s):
			return
		state = s
		state_changed.emit(state)
		match s:
			State.NEW, State.PLAYING:
				frogs = FROGS
				SS.stats.score = 0

signal frogs_changed(frogs: int)
signal lilypad_reached
signal next_frog
signal state_changed(state: State)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('dev_state_new'):
		state = State.NEW
	if event.is_action_pressed('dev_state_playing'):
		state = State.PLAYING
	if event.is_action_pressed('dev_state_over'):
		state = State.OVER
