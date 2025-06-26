#include "maze_generator.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void MazeGenerator::_bind_methods()
{
    ClassDB::bind_static_method("MazeGenerator", D_METHOD("generate_maze", "width", "height"), &MazeGenerator::generate_maze);
}

MazeGenerator::MazeGenerator()
{
}

MazeGenerator::~MazeGenerator()
{
}

Ref<MazeGraph> MazeGenerator::generate_maze(int width, int height)
{
    Ref<MazeGraph> maze_graph;
    maze_graph.instantiate();

    maze_graph->set_width(width);
    maze_graph->set_height(height);

    return maze_graph;
}
