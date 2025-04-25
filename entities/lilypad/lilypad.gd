class_name Lilypad extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var frog_sprite_2d: Sprite2D = $frog_sprite_2d
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

var occupied: bool = false:
	set(o):
		if o == occupied:
			return
		occupied = o
		frog_sprite_2d.visible = o
		collision_shape_2d.set_deferred('disabled', !o)

func _ready() -> void:
	area_2d.area_entered.connect(func(area: Area2D):
		if area is LilypadDetector:
			area.detected.emit()
			occupied = true
	)
