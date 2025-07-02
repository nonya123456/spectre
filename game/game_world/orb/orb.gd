extends Node3D

@onready var model: Node3D = $OrbModel

@export var speed: float = 1.0


func _process(delta: float) -> void:
	model.rotate(Vector3(1, 1, 1).normalized(), delta * speed)
