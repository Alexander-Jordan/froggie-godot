extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var tile_size: int = 16
var directions: Dictionary[String, Vector2] = {
	'up': Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
}

func _unhandled_input(event: InputEvent) -> void:
	for direction in directions:
		if event.is_action_pressed(direction):
			move(direction)

func move(direction: String) -> void:
	ray_cast_2d.target_position = directions[direction] * tile_size
	ray_cast_2d.force_raycast_update()
	if !ray_cast_2d.is_colliding():
		position += directions[direction] * tile_size
