extends Node3D


func _ready() -> void:
    print(MazeGenerator.generate_maze(10, 10))
    print("Hello from game_world.gd")
