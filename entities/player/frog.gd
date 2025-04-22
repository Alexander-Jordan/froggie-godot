extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var animation_speed: int = 3
var directions: Dictionary[String, Vector2] = {
	'up': Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
}
var is_moving: bool = false
var tile_size: int = 16

func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return
	for direction in directions:
		if event.is_action_pressed(direction):
			move(direction)

func move(direction: String) -> void:
	ray_cast_2d.target_position = directions[direction] * tile_size
	ray_cast_2d.force_raycast_update()
	if !ray_cast_2d.is_colliding():
		var tween: Tween = create_tween()
		tween.tween_property(
			self,
			'position',
			position + directions[direction] * tile_size,
			1.0/animation_speed,
		).set_trans(Tween.TRANS_SINE)
		is_moving = true
		sprite_2d.frame += 1
		await tween.finished
		is_moving = false
		sprite_2d.frame -= 1
