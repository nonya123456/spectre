class_name Block

extends StaticBody3D

func set_size(size: Vector3) -> void:
    var shape_node: Node = get_node_or_null("CollisionShape3D")
    if shape_node and shape_node.shape is BoxShape3D:
        shape_node.shape.size = size

    var mesh_node: Node = get_node_or_null("MeshInstance3D")
    if mesh_node and mesh_node.mesh is BoxMesh:
        mesh_node.mesh.size = size
