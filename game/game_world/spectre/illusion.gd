class_name Illusion

extends Node3D

var target: Node3D = null

@onready var marker: Marker3D = $Marker3D
@onready var spectre_model: SpectreModel = $SpectreModel

@export var sight_range: float = 7.5
@export_flags_3d_physics var collision_mask: int


func _physics_process(_delta: float) -> void:
	if !target:
		return

	var disp: Vector3 = target.global_position - global_position
	disp.y = 0

	var direction: Vector3 = disp.normalized()
	look_at(global_position - direction, Vector3.UP)

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	var raycast_direction: Vector3 = (target.global_position - marker.global_position).normalized()
	var raycast_target: Vector3 = marker.global_position + sight_range * raycast_direction
	var query := PhysicsRayQueryParameters3D.create(marker.global_position, raycast_target, collision_mask, [self])

	var result = space_state.intersect_ray(query)

	if result.has("collider") and result["collider"] == target:
		spectre_model.remove_material() # HACK: fix material is null error
		print("illusion found")
		queue_free()
