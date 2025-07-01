extends Node3D

@onready var spectre: Spectre = $Spectre

@export var rng_seed: int = 0
@export var width: int = 10
@export var height: int = 10
@export var node_size: float = 3.0
@export var node_height: float = 6.0
@export var wall_thickness: float = 0.5
@export var block_scene: PackedScene = preload("res://game/game_world/block/block.tscn")


func _ready() -> void:
	var maze_graph: MazeGraph = MazeGenerator.generate_maze(rng_seed, width, height)
	var map_height: float = node_size * height + wall_thickness * (height + 1)
	var map_width: float = node_size * width + wall_thickness * (width + 1)

	var floor_block: Block = block_scene.instantiate()
	floor_block.set_size(Vector3(map_height, wall_thickness, map_width))
	add_child(floor_block)

	var ceiling_block: Block = block_scene.instantiate()
	ceiling_block.set_size(Vector3(map_height, wall_thickness, map_width))
	ceiling_block.position.y = node_height
	add_child(ceiling_block)

	# Outer wall 1: along X axis (back wall)
	var outer_wall_1: Block = block_scene.instantiate()
	outer_wall_1.set_size(Vector3(map_height, node_height, wall_thickness))
	outer_wall_1.position = Vector3(0, node_height / 2, - (map_width - wall_thickness) / 2)
	add_child(outer_wall_1)

	# Outer wall 2: along X axis (front wall)
	var outer_wall_2: Block = block_scene.instantiate()
	outer_wall_2.set_size(Vector3(map_height, node_height, wall_thickness))
	outer_wall_2.position = Vector3(0, node_height / 2, (map_width - wall_thickness) / 2)
	add_child(outer_wall_2)

	# Outer wall 3: along Z axis (left wall)
	var outer_wall_3: Block = block_scene.instantiate()
	outer_wall_3.set_size(Vector3(wall_thickness, node_height, map_width))
	outer_wall_3.position = Vector3(- (map_height - wall_thickness) / 2, node_height / 2, 0)
	add_child(outer_wall_3)

	# Outer wall 4: along Z axis (right wall)
	var outer_wall_4: Block = block_scene.instantiate()
	outer_wall_4.set_size(Vector3(wall_thickness, node_height, map_width))
	outer_wall_4.position = Vector3((map_height - wall_thickness) / 2, node_height / 2, 0)
	add_child(outer_wall_4)

	# Inner walls
	for i in range(height):
		for j in range(width):
			if j + 1 < width && !maze_graph.is_adjacent(i, j, i, j + 1):
				var wall: Block = block_scene.instantiate()
				wall.set_size(Vector3(node_size, node_height, wall_thickness))
				var pos_x: float = (i + 1) * (node_size + wall_thickness) - node_size / 2 - map_height / 2
				var pos_z: float = (j + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_width / 2
				wall.position = Vector3(pos_x, node_height / 2, pos_z)
				add_child(wall)

			if i + 1 < height && !maze_graph.is_adjacent(i, j, i + 1, j):
				var wall: Block = block_scene.instantiate()
				wall.set_size(Vector3(wall_thickness, node_height, node_size))
				var pos_x: float = (i + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_height / 2
				var pos_z: float = (j + 1) * (node_size + wall_thickness) - node_size / 2 - map_width / 2
				wall.position = Vector3(pos_x, node_height / 2, pos_z)
				add_child(wall)
	
	# Corners
	for i in range(height - 1):
		for j in range(width - 1):
			if !maze_graph.is_adjacent(i, j, i + 1, j) or !maze_graph.is_adjacent(i, j, i, j + 1) or \
			   !maze_graph.is_adjacent(i, j + 1, i + 1, j + 1) or !maze_graph.is_adjacent(i + 1, j, i + 1, j + 1):
				var corner: Block = block_scene.instantiate()
				corner.set_size(Vector3(wall_thickness, node_height, wall_thickness))
				var pos_x: float = (i + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_height / 2
				var pos_z: float = (j + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_width / 2
				corner.position = Vector3(pos_x, node_height / 2, pos_z)
				add_child(corner)


func _on_player_flashlight_toggled(is_light_visible: bool) -> void:
	spectre.on_player_flashlight_toggled(is_light_visible)
