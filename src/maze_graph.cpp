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

    ClassDB::bind_method(D_METHOD("get_num_edges"), &MazeGraph::get_num_edges);

    ClassDB::bind_method(D_METHOD("is_adjacent", "ax", "ay", "bx", "by"), &MazeGraph::is_adjacent);
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

void MazeGraph::set_adj(const std::vector<std::set<int>> &p_adj)
{
    adj = p_adj;
}

int MazeGraph::get_num_edges() const
{
    int count = 0;
    for (const auto &edges : adj)
    {
        count += edges.size();
    }
    return count / 2;
}

bool MazeGraph::is_adjacent(int ax, int ay, int bx, int by) const
{
    if (ax < 0 || ax >= height || ay < 0 || ay >= width || bx < 0 || bx >= height || by < 0 || by >= width)
    {
        return false;
    }

    int a_index = ax * width + ay;
    int b_index = bx * width + by;

    return adj[a_index].find(b_index) != adj[a_index].end();
}
