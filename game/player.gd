extends CharacterBody3D


func _ready() -> void:
    print("Hello from player.gd")


func _physics_process(delta: float) -> void:
    velocity += Vector3.DOWN * 9.8 * delta
    move_and_slide()
