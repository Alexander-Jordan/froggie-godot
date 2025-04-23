class_name CarSpawner extends Spawner2D

@export var direction: Vector2 = Vector2(1, 0)
@export var spawn_point: Vector2 = Vector2.ZERO
@export var speed: int = 100
@export var time: float = 10.0

@onready var timer: Timer = $Timer

func _ready() -> void:
	spawn_car()
	timer.start(time)
	timer.timeout.connect(spawn_car)

func spawn_car() -> void:
	var spawnable: Spawnable2D = spawn(spawn_point, direction)
	if spawnable.root_node is Car:
		spawnable.root_node.speed = speed
