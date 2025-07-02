class_name Spectre

extends Node3D

signal target_found
signal target_lost

@onready var spectre_model: SpectreModel = $SpectreModel
@onready var marker: Marker3D = $Marker3D

var target: Node3D = null
var target_in_sight: bool = false

@export_flags_3d_physics var collision_mask: int


func _physics_process(_delta: float) -> void:
	if !target:
		return

	var direction: Vector3 = target.global_position - global_position
	direction.y = 0
	direction = direction.normalized()
	look_at(global_position - direction, Vector3.UP)

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(marker.global_position, target.global_position, collision_mask, [self])
	var result = space_state.intersect_ray(query)

	if result["collider"] == target and !target_in_sight:
		target_in_sight = true
		target_found.emit()

	if result["collider"] != target and target_in_sight:
		target_in_sight = false
		target_lost.emit()


func on_player_flashlight_toggled(is_light_visible: bool) -> void:
	if is_light_visible:
		spectre_model.set_emission_strength(2.0)
	else:
		spectre_model.set_emission_strength(0.0)
