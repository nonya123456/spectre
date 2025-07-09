class_name Spectre

extends Node3D

signal inactive
signal target_found(marker_position: Vector3)
signal target_lost

var index: int;

var active_timer: float

var target: Node3D = null
var target_in_sight: bool = false
var target_in_attack_range: bool = false

var hint_timer: float

@onready var marker: Marker3D = $Marker3D
@onready var spectre_model: SpectreModel = $SpectreModel
@onready var hint_player: AudioStreamPlayer3D = $HintPlayer

@export var target_attack_range: float = 6.0
@export_flags_3d_physics var collision_mask: int
@export_flags_3d_physics var wall_collision_mask: int

@export var inactive_range: float = 15.0

func _ready() -> void:
	_reset_hint_timer()


func _physics_process(_delta: float) -> void:
	if !target or !is_active():
		return

	var disp: Vector3 = target.global_position - global_position
	disp.y = 0

	var direction: Vector3 = disp.normalized()
	look_at(global_position - direction, Vector3.UP)

	if disp.length() > inactive_range:
		_deactivate()
		return

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(marker.global_position, target.global_position, collision_mask, [self])
	var result = space_state.intersect_ray(query)

	target_in_sight = result.has("collider") and result["collider"] == target

	if !target_in_attack_range and (target_in_sight and disp.length() <= target_attack_range):
		target_in_attack_range = true
		target_found.emit(marker.global_position)
		spectre_model.set_emission_strength(4.0)
		spectre_model.set_emission_color(Color.DARK_RED)

	if target_in_attack_range and !target_in_sight:
		_deactivate()


func _deactivate() -> void:
	target_in_attack_range = false
	target_lost.emit()
	active_timer = 0
	spectre_model.set_emission_strength(2.0)
	spectre_model.set_emission_color(Color.WHITE)


func _process(delta: float) -> void:
	hint_timer -= delta
	if hint_timer < 0:
		hint_player.play()
		_reset_hint_timer()

	if target_in_attack_range:
		return

	if !target_in_sight:
		active_timer -= delta

	if active_timer <= 0:
		visible = false
		target_in_sight = false
		target_in_attack_range = false
		inactive.emit()


func _reset_hint_timer() -> void:
	hint_timer = randf_range(20.0, 40.0)


func is_active() -> bool:
	return active_timer > 0


func activate(duration: float) -> void:
	visible = true
	active_timer = duration
	_reset_hint_timer()


func teleport_nearby(target_position: Vector3) -> void:
	target_position.y = 2.0

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	var directions: PackedVector3Array = [
		Vector3.LEFT,
		Vector3.RIGHT,
		Vector3.BACK,
		Vector3.FORWARD,
		Vector3(1, 0, 1).normalized(),
		Vector3(-1, 0, 1).normalized(),
		Vector3(1, 0, -1).normalized(),
		Vector3(-1, 0, -1).normalized()
	]

	var final_position: Vector3 = target_position + Vector3.LEFT # default
	var max_distance: float = 0.0

	for direction in directions:
		var query := PhysicsRayQueryParameters3D.create(target_position, target_position + direction * target_attack_range, wall_collision_mask, [self])
		var result = space_state.intersect_ray(query)

		var new_position = target_position + direction * target_attack_range - direction * 0.5 # avoid walls
		if result.has("position"):
			new_position = result["position"] - direction * 0.5 # avoid walls

		var new_distance = new_position.distance_to(target_position)

		if new_distance > max_distance:
			max_distance = new_distance
			final_position = new_position
	
	global_position = final_position
	target_in_attack_range = false
	target_in_sight = false
