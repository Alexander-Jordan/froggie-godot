class_name PlatformDetector extends Area2D

@export var root_node: Node2D

var platforms: Array[Platform] = []

signal platforms_changed(detectables: Array[Platform])

func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is Platform:
			platforms.append(area)
			platforms_changed.emit(platforms)
	)
	area_exited.connect(func(area: Area2D):
		if area is Platform and platforms.has(area):
			platforms.erase(area)
			platforms_changed.emit(platforms)
	)
