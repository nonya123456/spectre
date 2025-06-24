extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D

@export var sensitivity: float = 0.2
var look_input: Vector2 = Vector2.ZERO
var pitch: float = 0.0


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        look_input = event.screen_relative


func _physics_process(delta: float) -> void:
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
