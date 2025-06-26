#include "maze_generator.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void MazeGenerator::_bind_methods()
{
    ClassDB::bind_static_method("MazeGenerator", D_METHOD("generate_maze"), &MazeGenerator::generate_maze);
}

MazeGenerator::MazeGenerator()
{
}

MazeGenerator::~MazeGenerator()
{
}

String MazeGenerator::generate_maze(int width, int height)
{
    return String("Hello from MazeGenerator") + " with width: " + String::num(width) + " and height: " + String::num(height);
}
