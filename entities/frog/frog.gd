extends Node2D

@export var spawn_position: Vector2 = Vector2.ZERO
@export var tile_map_layer: TileMapLayer

@onready var destructable_2d: Destructable2D = $Destructable2D
@onready var platform_detector: PlatformDetector = $PlatformDetector
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
var platform: Platform = null
var tile_size: int = 16
var tween: Tween = null

func _ready() -> void:
	spawn_position = position
	GM.state = GM.State.PLAYING
	
	destructable_2d.destroyed.connect(func(): GM.next_frog.emit(false))
	GM.next_frog.connect(func(_previous_safe: bool): reset())
	GM.state_changed.connect(func(state: GM.State):
		match state:
			GM.State.NEW, GM.State.PLAYING:
				reset()
			GM.State.OVER, GM.State.WIN:
				sprite_2d.visible = false
	)
	platform_detector.platforms_changed.connect(func(platforms: Array[Platform]):
		platform = platforms.front() if !platforms.is_empty() else null
	)

func _process(delta: float) -> void:
	if platform:
		position += platform.velocity * delta

func _unhandled_input(event: InputEvent) -> void:
	if is_moving or GM.state != GM.State.PLAYING:
		return
	for direction in directions:
		if event.is_action_pressed(direction):
			move(direction)

func get_tile_type() -> String:
	if tile_map_layer == null or platform != null:
		return ''
	
	var tile_data: TileData = tile_map_layer.get_cell_tile_data(tile_map_layer.local_to_map(tile_map_layer.to_local(position)))
	if tile_data == null or !tile_data.has_custom_data('type'):
		return ''
	else:
		return tile_data.get_custom_data('type')

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
		sprite_2d.frame = 1
		sprite_2d_parent.look_at(self.position + directions[direction])
		
		await tween.finished
		
		tween = null
		is_moving = false
		sprite_2d.frame = 0
		
		match get_tile_type():
			'water':
				destructable_2d.destruct(1)

func reset() -> void:
	if tween != null:
		tween.kill()
		tween = null
		sprite_2d.frame = 0
		is_moving = false
	position = spawn_position
	sprite_2d_parent.look_at(self.position + directions.up)
	sprite_2d.visible = true # this is set to false when the game is over/won
