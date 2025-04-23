class_name Turtles extends Node2D

@onready var spawnable_2d: Spawnable2D = $Spawnable2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(func(): spawnable_2d.call_deferred('despawn'))
