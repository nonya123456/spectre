class_name Spectre

extends Node3D

signal target_found(marker_position: Vector3)
signal target_lost

var target: Node3D = null
var target_in_sight: bool = false

@onready var marker: Marker3D = $Marker3D
@onready var spectre_model: SpectreModel = $SpectreModel

@export var target_enter_range: float = 4.0
@export var target_exit_range: float = 12.0
@export_flags_3d_physics var collision_mask: int


func _physics_process(_delta: float) -> void:
	if !target:
		return

	var disp: Vector3 = target.global_position - global_position
	disp.y = 0

	var direction: Vector3 = disp.normalized()
	look_at(global_position - direction, Vector3.UP)

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(marker.global_position, target.global_position, collision_mask, [self])
	var result = space_state.intersect_ray(query)

	if !target_in_sight and (result.has("collider") and result["collider"] == target and disp.length() <= target_enter_range):
		target_in_sight = true
		target_found.emit(marker.global_position)
		spectre_model.set_emission_strength(4.0)
		spectre_model.set_emission_color(Color.DARK_RED)

	if target_in_sight and (!result.has("collider") or result["collider"] != target or disp.length() > target_exit_range):
		target_in_sight = false
		target_lost.emit()
		spectre_model.set_emission_strength(2.0)
		spectre_model.set_emission_color(Color.WHITE)
