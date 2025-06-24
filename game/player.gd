extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D

@export var move_speed: float = 5.0
@export var sensitivity: float = 0.2
var look_input: Vector2 = Vector2.ZERO
var pitch: float = 0.0


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

    _handle_look()


func _handle_look() -> void:
    pitch -= look_input.y * sensitivity
    pitch = clamp(pitch, -89, 89)
    camera.rotation_degrees.x = pitch

    var horizontal: float = - look_input.x * sensitivity
    var horizontal_rad: float = deg_to_rad(horizontal)
    rotate_y(horizontal_rad)

    look_input = Vector2.ZERO
