class_name Illusion

extends Node3D

signal found(illusion: Illusion)

var index: int

var target: Node3D = null

var is_found: bool
var found_timer: float = 0.25

@onready var marker: Marker3D = $Marker3D
@onready var spectre_model: SpectreModel = $SpectreModel

@export var sight_range: float = 4.0
@export_flags_3d_physics var collision_mask: int


func _physics_process(_delta: float) -> void:
	if !target:
		return

	var disp: Vector3 = target.global_position - global_position
	disp.y = 0

	var direction: Vector3 = disp.normalized()
	look_at(global_position - direction, Vector3.UP)

	if is_found:
		return

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(marker.global_position, target.global_position, collision_mask, [self])
	var result = space_state.intersect_ray(query)

	if result.has("collider") and result["collider"] == target and disp.length() <= sight_range:
		handle_target_entered_sight()


func _process(delta: float) -> void:
	if !is_found:
		return
	
	found_timer -= delta
	if found_timer < 0:
		found.emit(self)


func handle_target_entered_sight() -> void:
	is_found = true
	spectre_model.set_shake(true)


func reset() -> void:
	is_found = false
	found_timer = 0.25
	spectre_model.set_shake(false)
