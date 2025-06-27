extends Node3D

@export var width: int = 10
@export var height: int = 10
@export var node_size: float = 3.0
@export var node_height: float = 6.0
@export var block_scene: PackedScene = preload("res://game/block.tscn")


func _ready() -> void:
	var maze_graph: MazeGraph = MazeGenerator.generate_maze(width, height)
	print("Maze Graph Width: ", maze_graph.get_width())
	print("Maze Graph Height: ", maze_graph.get_height())

	var floor_block: Block = block_scene.instantiate()
	floor_block.set_size(Vector3(node_size * height, 1, node_size * width))
	add_child(floor_block)

	var ceiling_block: Block = block_scene.instantiate()
	ceiling_block.set_size(Vector3(node_size * height, 3, node_size * width))
	ceiling_block.position.y = node_height
	add_child(ceiling_block)

	# Outer wall 1: along X axis (back wall)
	var outer_wall_1: Block = block_scene.instantiate()
	outer_wall_1.set_size(Vector3(node_size * height, node_height, 1))
	outer_wall_1.position = Vector3(0, node_height / 2, - (node_size * width) / 2)
	add_child(outer_wall_1)

	# Outer wall 2: along X axis (front wall)
	var outer_wall_2: Block = block_scene.instantiate()
	outer_wall_2.set_size(Vector3(node_size * height, node_height, 1))
	outer_wall_2.position = Vector3(0, node_height / 2, (node_size * width) / 2)
	add_child(outer_wall_2)

	# Outer wall 3: along Z axis (left wall)
	var outer_wall_3: Block = block_scene.instantiate()
	outer_wall_3.set_size(Vector3(1, node_height, node_size * width))
	outer_wall_3.position = Vector3(- (node_size * height) / 2, node_height / 2, 0)
	add_child(outer_wall_3)

	# Outer wall 4: along Z axis (right wall)
	var outer_wall_4: Block = block_scene.instantiate()
	outer_wall_4.set_size(Vector3(1, node_height, node_size * width))
	outer_wall_4.position = Vector3((node_size * height) / 2, node_height / 2, 0)
	add_child(outer_wall_4)
