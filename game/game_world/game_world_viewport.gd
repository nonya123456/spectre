extends SubViewportContainer

var force: float = 1.0
var force_change_speed: float = 10.0
var is_zoomed: bool = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_zoom"):
		is_zoomed = !is_zoomed

	var target_force: float = 1.5 if is_zoomed else 1.0
	force = lerp(force, target_force, delta * force_change_speed)
	material.set_shader_parameter("force", force)

	var shake_intensity: float = 0.005 if is_zoomed else 0.0
	material.set_shader_parameter("shake_intensity", shake_intensity)
