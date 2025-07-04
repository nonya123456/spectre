class_name SpectreModel

extends Node3D

@onready var mesh: MeshInstance3D = $rig/Skeleton3D/Spectre


func set_emission_strength(strength: float) -> void:
	mesh.get_surface_override_material(0).set_shader_parameter("emission_strength", strength)


func remove_material() -> void:
	for i in range(0, mesh.get_surface_override_material_count()):
		mesh.set_surface_override_material(i, null)
