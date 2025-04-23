class_name Platform extends Area2D

@export var direction: Vector2 = Vector2(-1, 0)
@export var root_node: Node2D
@export var speed: int = 100

var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	velocity = direction.normalized() * speed
	root_node.position += velocity * delta
