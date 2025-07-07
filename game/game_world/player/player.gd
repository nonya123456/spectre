class_name Player

extends CharacterBody3D

signal died

@export var max_health: int = 4
@export var move_speed: float = 3.0
@export var sensitivity: float = 0.2
@export var sway_strength: float = 0.0002
@export var forced_look_rotate_speed: float = 8.0
@export var forced_look_move_speed: float = 2.0

@export var footstep_interval: float = 0.8
var footstep_timer: float = 0.0
var last_input_dir: Vector3 = Vector3.ZERO

var look_input: Vector2 = Vector2.ZERO
var pitch: float = 0.0
var is_forced_look: bool = false
var forced_look_position: Vector3
var has_died: bool

@export var attack_time: float = 1.0
var attack_timer: float

@export var drain_time: float = 30.0
@onready var drain_timer: float = drain_time

@onready var health = max_health
@onready var marker: Marker3D = $Marker3D
@onready var view_model: ViewModel = $Marker3D/ViewModel
@onready var spot_light: SpotLight3D = $Marker3D/SpotLight3D
@onready var start_spot_range = spot_light.spot_range
@onready var footstep_player: AudioStreamPlayer3D = $FootstepPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_input = event.screen_relative


func _physics_process(delta: float) -> void:
	var input_dir: Vector3 = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1

	if Input.is_action_pressed("move_back"):
		input_dir.z += 1

	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1

	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	input_dir = input_dir.normalized()

	var move_dir: Vector3 = global_basis.z * input_dir.z + global_basis.x * input_dir.x
	move_dir = move_dir.normalized() * (move_speed if !is_forced_look else forced_look_move_speed)

	velocity.x = move_dir.x
	velocity.z = move_dir.z
	velocity += Vector3.DOWN * 9.8 * delta

	move_and_slide()

	if input_dir != Vector3.ZERO and last_input_dir != Vector3.ZERO:
		footstep_timer += delta if !is_forced_look else 0.0
		if footstep_timer >= footstep_interval:
			footstep_player.play()
			footstep_timer = 0.0
	elif input_dir != Vector3.ZERO:
		footstep_timer = footstep_interval / 2.0

	last_input_dir = input_dir

	_handle_look(delta)

	look_input = Vector2.ZERO


func _process(delta: float) -> void:
	if is_forced_look:
		var flicker = abs(sin(Time.get_ticks_msec() * 0.02)) > 0.3
		spot_light.visible = flicker
	else:
		spot_light.visible = true
	
	if is_forced_look:
		attack_timer -= delta
		if attack_timer < 0:
			_take_damage()
			attack_timer = attack_time

			if health <= 0 and !has_died:
				has_died = true
				died.emit()
	else:
		drain_timer -= delta
		if drain_timer < 0 && health > 1:
			_take_damage()
			drain_timer = drain_time


func _take_damage() -> void:
	health -= 1
	_update_spot_range()


func heal() -> void:
	health = move_toward(health, max_health, 1)
	drain_timer = drain_time
	_update_spot_range()


func _update_spot_range() -> void:
	spot_light.spot_range = start_spot_range * float(health) / float(max_health)


func _handle_look(delta: float) -> void:
	if is_forced_look:
		var disp: Vector3 = forced_look_position - marker.global_position
		var disp_xz: Vector2 = Vector2(disp.x, disp.z)
		pitch = rad_to_deg(atan2(disp.y, disp_xz.length()))
	else:
		pitch -= look_input.y * sensitivity
		pitch = clamp(pitch, -89, 89)

	marker.rotation_degrees.x = pitch

	if is_forced_look:
		var direction: Vector3 = forced_look_position - global_position
		var angle: float = atan2(direction.x, direction.z) - PI
		rotation.y = rotate_toward(rotation.y, angle, delta * forced_look_rotate_speed)
	else:
		var horizontal: float = - look_input.x * sensitivity
		var horizontal_rad: float = deg_to_rad(horizontal)
		rotate_y(horizontal_rad)

	if !is_forced_look:
		view_model.sway(Vector2(-look_input.x * sway_strength, look_input.y * sway_strength))


func start_forced_look(marker_position: Vector3) -> void:
	is_forced_look = true
	forced_look_position = marker_position
	attack_timer = attack_time


func stop_forced_look() -> void:
	is_forced_look = false
	forced_look_position = Vector3.ZERO


func get_marker_position() -> Vector3:
	return marker.global_position


func get_marker_rotation() -> Vector3:
	return marker.global_rotation
