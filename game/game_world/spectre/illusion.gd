class_name Illusion

extends Node3D

signal inactive(illusion: Illusion)

var index: int

var target: Node3D = null

var is_active: bool
var found_timer: float = 0.25

@onready var marker: Marker3D = $Marker3D
@onready var spectre_model: SpectreModel = $SpectreModel

@export var inactive_range: float = 20.0
@export var sight_range: float = 4.0
@export_flags_3d_physics var collision_mask: int
@export var teleport_player_scene: PackedScene = preload("res://game/game_world/spectre/teleport_player.tscn")


func _physics_process(_delta: float) -> void:
	if !target:
		return

	var disp: Vector3 = target.global_position - global_position
	disp.y = 0

	var direction: Vector3 = disp.normalized()
	look_at(global_position - direction, Vector3.UP)

	if !is_active:
		return
	
	if disp.length() > inactive_range:
		_deactivate()
		return
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(marker.global_position, target.global_position, collision_mask, [self])
	var result = space_state.intersect_ray(query)

	if result.has("collider") and result["collider"] == target and disp.length() <= sight_range:
		_deactivate()
		_play_teleport_sound()


func _play_teleport_sound() -> void:
	var teleport_player: AudioStreamPlayer3D = teleport_player_scene.instantiate()
	get_parent().add_child(teleport_player)
	teleport_player.global_position = global_position
	teleport_player.finished.connect(func() -> void:
		teleport_player.queue_free()
	)


func _process(delta: float) -> void:
	if is_active:
		return
	
	found_timer -= delta
	if found_timer < 0:
		global_position = Vector3(0, -1000, 0)
		inactive.emit(self)


func _deactivate() -> void:
	is_active = false
	spectre_model.set_shake(true)


func reset() -> void:
	is_active = true
	found_timer = 0.25
	spectre_model.set_shake(false)
