extends SubViewportContainer

var force: float = 1.0
var force_change_speed: float = 10.0
var haunt: bool = false


func _process(delta: float) -> void:
	var target_force: float = 1.5 if haunt else 1.0
	force = lerp(force, target_force, delta * force_change_speed)
	material.set_shader_parameter("force", force)

	var shake_intensity: float = 0.01 if haunt else 0.0
	material.set_shader_parameter("shake_intensity", shake_intensity)


func _on_game_world_haunt_entered() -> void:
	haunt = true


func _on_game_world_haunt_exited() -> void:
	haunt = false
