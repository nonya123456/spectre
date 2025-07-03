extends SubViewportContainer

var zoom_factor: float = 1.0
var zoom_factor_change_speed: float = 5.0
var forced_look: bool = false


func _process(delta: float) -> void:
	var target_force: float = 1.5 if forced_look else 1.0
	zoom_factor = move_toward(zoom_factor, target_force, delta * zoom_factor_change_speed)
	material.set_shader_parameter("zoom_factor", zoom_factor)

	var shake_intensity: float = 0.01 if forced_look else 0.0
	material.set_shader_parameter("shake_intensity", shake_intensity)


func _on_game_world_forced_look_entered() -> void:
	forced_look = true


func _on_game_world_forced_look_exited() -> void:
	forced_look = false
