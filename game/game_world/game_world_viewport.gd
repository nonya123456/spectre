extends SubViewportContainer

var force: float = 1.0
var target_force: float = 1.0
var force_change_speed: float = 10.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_zoom"):
		target_force = 1.0 if target_force == 1.5 else 1.5

	force = lerp(force, target_force, delta * force_change_speed)
	material.set_shader_parameter("force", force)
