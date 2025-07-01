class_name SpectreModel

extends Node3D

@onready var mesh: MeshInstance3D = $rig/Skeleton3D/Spectre


func set_emission_strength(strength: float) -> void:
	mesh.get_surface_override_material(0).set_shader_parameter("emission_strength", strength)
