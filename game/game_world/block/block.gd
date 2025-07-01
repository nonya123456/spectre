class_name Block

extends StaticBody3D


func set_size(size: Vector3) -> void:
    var collision_shape: CollisionShape3D = $CollisionShape3D
    collision_shape.shape = BoxShape3D.new()
    collision_shape.shape.size = size

    var mesh_instance: MeshInstance3D = $MeshInstance3D
    mesh_instance.mesh = BoxMesh.new()
    mesh_instance.mesh.size = size
