class_name LogSpawner extends Spawner2D

@export var spawn_point: Vector2 = Vector2.ZERO
@export var time: float = 10.0

@onready var timer: Timer = $Timer

func _ready() -> void:
	spawn_log()
	timer.start(time)
	timer.timeout.connect(spawn_log)

func spawn_log() -> void:
	spawn(spawn_point)
