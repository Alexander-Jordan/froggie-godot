extends Node2D

@export var spawn_position: Vector2 = Vector2.ZERO

@onready var destructable_2d: Destructable2D = $Destructable2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: Sprite2D = $sprite_2d_parent/Sprite2D
@onready var sprite_2d_parent: Node2D = $sprite_2d_parent

var animation_speed: int = 8
var directions: Dictionary[String, Vector2] = {
	'up': Vector2.UP,
	'down': Vector2.DOWN,
	'left': Vector2.LEFT,
	'right': Vector2.RIGHT,
}
var is_moving: bool = false
var tile_size: int = 16
var tween: Tween = null

func _ready() -> void:
	spawn_position = position
	
	destructable_2d.destroyed.connect(reset)

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
		tween = create_tween()
		tween.tween_property(
			self,
			'position',
			position + directions[direction] * tile_size,
			1.0/animation_speed,
		).set_trans(Tween.TRANS_SINE)
		
		is_moving = true
		sprite_2d.frame += 1
		sprite_2d_parent.look_at(self.position + directions[direction])
		
		await tween.finished
		
		tween = null
		is_moving = false
		sprite_2d.frame -= 1

func reset() -> void:
	if tween != null:
		tween.kill()
		tween = null
		sprite_2d.frame = 0
		is_moving = false
	position = spawn_position
	sprite_2d_parent.look_at(self.position + directions.up)
