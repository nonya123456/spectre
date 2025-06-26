#include "maze_graph.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void MazeGraph::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("set_width", "p_width"), &MazeGraph::set_width);
    ClassDB::bind_method(D_METHOD("get_width"), &MazeGraph::get_width);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "width"), "set_width", "get_width");

    ClassDB::bind_method(D_METHOD("set_height", "p_height"), &MazeGraph::set_height);
    ClassDB::bind_method(D_METHOD("get_height"), &MazeGraph::get_height);
    ADD_PROPERTY(PropertyInfo(Variant::STRING, "height"), "set_height", "get_height");
}

MazeGraph::MazeGraph()
{
}

MazeGraph::~MazeGraph()
{
}

void MazeGraph::set_width(int p_width)
{
    width = p_width;
}

int MazeGraph::get_width() const
{
    return width;
}

void MazeGraph::set_height(int p_height)
{
    height = p_height;
}

int MazeGraph::get_height() const
{
    return height;
}
