class_name Player

extends CharacterBody3D

signal flashlight_toggled(is_light_visible: bool)

@onready var camera: Camera3D = $Camera3D
@onready var view_model: ViewModel = $Camera3D/SubViewportContainer/SubViewport/ViewModel
@onready var spot_light: SpotLight3D = $SpotLight3D

@export var move_speed: float = 5.0
@export var sensitivity: float = 0.2
@export var sway_strength: float = 0.0002
var look_input: Vector2 = Vector2.ZERO
var pitch: float = 0.0

var is_forced_look: bool = false
var forced_look_position: Vector3
var forced_look_speed: float = 8.0


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
	move_dir = move_dir.normalized() * move_speed

	velocity.x = move_dir.x
	velocity.z = move_dir.z
	velocity += Vector3.DOWN * 9.8 * delta

	move_and_slide()

	_handle_look(delta)

	_update_view_model()

	look_input = Vector2.ZERO


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_flashlight"):
		spot_light.visible = !spot_light.visible
		flashlight_toggled.emit(spot_light.visible)


func _handle_look(delta: float) -> void:
	if is_forced_look:
		var disp: Vector3 = forced_look_position - camera.global_position
		var disp_xz: Vector2 = Vector2(disp.x, disp.z)
		pitch = rad_to_deg(atan2(disp.y, disp_xz.length()))
	else:
		pitch -= look_input.y * sensitivity
		pitch = clamp(pitch, -89, 89)

	camera.rotation_degrees.x = pitch
	spot_light.rotation_degrees.x = pitch

	if is_forced_look:
		var direction: Vector3 = forced_look_position - global_position
		var angle: float = atan2(direction.x, direction.z) - PI
		rotation.y = rotate_toward(rotation.y, angle, delta * forced_look_speed)
	else:
		var horizontal: float = - look_input.x * sensitivity
		var horizontal_rad: float = deg_to_rad(horizontal)
		rotate_y(horizontal_rad)

	
func _update_view_model() -> void:
	view_model.global_position = camera.global_position
	view_model.global_rotation_degrees = camera.global_rotation_degrees
	if !is_forced_look:
		view_model.sway(Vector2(-look_input.x * sway_strength, look_input.y * sway_strength))


func start_forced_look(marker_position: Vector3) -> void:
	is_forced_look = true
	forced_look_position = marker_position


func stop_forced_look() -> void:
	is_forced_look = false
	forced_look_position = Vector3.ZERO
