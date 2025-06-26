extends Node3D


func _ready() -> void:
    var maze_graph: MazeGraph = MazeGenerator.generate_maze(10, 12)
    print("Maze Graph Width: ", maze_graph.get_width())
    print("Maze Graph Height: ", maze_graph.get_height())
