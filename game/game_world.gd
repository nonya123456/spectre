extends Node3D

@export var block_scene: PackedScene


func _ready() -> void:
	var maze_graph: MazeGraph = MazeGenerator.generate_maze(10, 12)
	print("Maze Graph Width: ", maze_graph.get_width())
	print("Maze Graph Height: ", maze_graph.get_height())
	print("Maze Graph Number Of Edges: ", maze_graph.get_num_edges())

	var count: int = 0
	for x in range(maze_graph.get_width()):
		for y in range(maze_graph.get_height()):
			if maze_graph.is_adjacent(x, y, x + 1, y):
				count += 1
				print("Adjacent: %d, %d and %d, %d" % [x, y, x + 1, y])
			if maze_graph.is_adjacent(x, y, x, y + 1):
				count += 1
				print("Adjacent: %d, %d and %d, %d" % [x, y, x, y + 1])

	print("Total Adjacent Pairs: ", count)

	var block: Block = block_scene.instantiate()
	block.set_size(Vector3(10, 1, 10))
	add_child(block)
