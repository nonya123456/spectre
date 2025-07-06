class_name Orb

extends Area3D

signal collected(orb: Orb)

var index: int

@onready var model: Node3D = $OrbModel

@export var speed: float = 1.0


func _process(delta: float) -> void:
	model.rotate(Vector3(1, 1, 1).normalized(), delta * speed)


func _physics_process(_delta: float) -> void:
	if is_queued_for_deletion():
		return

	if has_overlapping_bodies():
		queue_free()
		collected.emit(self)
