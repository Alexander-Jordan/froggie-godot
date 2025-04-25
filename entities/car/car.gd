class_name Car extends Node2D

@export var speed: int = 100

@onready var destructor_2d: Destructor2D = $Destructor2D
@onready var random_audio_player_2d: RandomAudioPlayer2D = $RandomAudioPlayer2D
@onready var spawnable_2d: Spawnable2D = $Spawnable2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	destructor_2d.destructable_entered.connect(func(): random_audio_player_2d.play_random_audio_and_await_finished())
	spawnable_2d.spawned.connect(func(_spawn_point: Vector2): sprite_2d.look_at(position + spawnable_2d.direction.normalized()))
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable_2d.call_deferred('despawn'))

func _process(delta: float) -> void:
	position += spawnable_2d.direction.normalized() * speed * delta
