class_name Spectre

extends Node3D

signal inactive
signal target_found(marker_position: Vector3)
signal target_lost

var index: int;

var active_timer: float

var target: Node3D = null
var target_in_sight: bool = false

@onready var marker: Marker3D = $Marker3D
@onready var spectre_model: SpectreModel = $SpectreModel

@export var target_enter_range: float = 4.0
@export_flags_3d_physics var collision_mask: int


func _physics_process(_delta: float) -> void:
	if !target or !is_active():
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

	if target_in_sight and (!result.has("collider") or result["collider"] != target):
		target_in_sight = false
		target_lost.emit()
		active_timer = 0
		spectre_model.set_emission_strength(2.0)
		spectre_model.set_emission_color(Color.WHITE)


func _process(delta: float) -> void:
	if target_in_sight:
		return

	active_timer -= delta
	if active_timer <= 0:
		visible = false
		target_in_sight = false
		inactive.emit()


func is_active() -> bool:
	return active_timer > 0


func activate() -> void:
	visible = true
	active_timer = 30.0
