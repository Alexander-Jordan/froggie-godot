class_name Destructable2D extends Area2D
## A simple component to make anything a destructable.

#region VARIABLES
@export_group('Audio', 'audio_')
## The audio streams to choose from when taking hits.
@export var audio_streams_destruct: Array[AudioStream] = []
## The audio streams to choose from when destroyed.
@export var audio_streams_destroyed: Array[AudioStream] = []
@export var disabled: bool = false
## The maximum, or default, amount of health.
@export_range(1, 10) var health_max: int = 1

## Amount of health before being destroyed.
var health: int = health_max:
	set(h):
		if disabled:
			return
		health = h if h >= 0 else 0
		destructed.emit()
		if health <= 0:
			destroyed.emit()
			health = health_max # reset
#endregion

#region SIGNALS
## Emitted when destructed.
signal destructed
## Emitted when destroyed.
signal destroyed
#endregion

#region FUNCTIONS
## Called by a destructor to make this destructable take damage.
## Returns the destruct amount left in the destructor.
func destruct(amount: int = health) -> int:
	var amount_left = amount - health
	health -= amount
	return amount_left if amount_left >= 0 else 0
#endregion
